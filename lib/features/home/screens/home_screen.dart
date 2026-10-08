import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import '../../workspaces/providers/workspace_providers.dart';
import '../presentation/home_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

/// Home Dashboard Screen - Supports both Mobile and Desktop layouts
/// Shows greeting, today's tasks, quick actions, and overview stats
/// Mobile: Vertical scroll with bottom nav
/// Desktop: Sidebar navigation with calendar widget on right
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    
    // Get real user data
    final userProfileAsync = ref.watch(currentUserProfileProvider);
    final workspaceId = ref.watch(currentWorkspaceIdProvider);

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F5F7) : theme.colorScheme.surface,
      floatingActionButton: !isDesktop ? FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/tasks/new'),
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
        backgroundColor: AppColors.primary,
      ) : null,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final syncEngine = ref.read(syncEngineProvider);
            await syncEngine.sync();
          },
          child: userProfileAsync.when(
            data: (userProfile) => isDesktop 
                ? _buildDesktopContent(context, userProfile, workspaceId)
                : _buildMobileContent(context, userProfile, workspaceId),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error loading profile: $error'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ========== MOBILE LAYOUT ==========
  Widget _buildMobileContent(BuildContext context, dynamic userProfile, String? workspaceId) {
    final theme = Theme.of(context);
    final userName = userProfile?.fullName ?? 'User';
    final firstName = userName.split(' ').first;
    final userInitials = _getUserInitials(userName);
    final taskRepository = ref.watch(taskRepositoryProvider);
    final workspacesAsync = ref.watch(workspacesProvider);
    
    return CustomScrollView(
      slivers: [
        // Top Bar with Workspace Switcher (Like Asana/ClickUp/Notion)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Workspace Switcher Button
                workspacesAsync.when(
                  data: (workspaces) {
                    final currentWorkspace = workspaces.firstWhere(
                      (w) => w.id == workspaceId,
                      orElse: () => workspaces.isNotEmpty ? workspaces.first : null,
                    );
                    
                    if (currentWorkspace == null) {
                      return const Text('PlanPal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
                    }
                    
                    return GestureDetector(
                      onTap: () => _showWorkspaceSwitcher(context, workspaces, workspaceId),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Workspace Avatar
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  currentWorkspace.name[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Workspace Name
                            Text(
                              currentWorkspace.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_drop_down, size: 20, color: Colors.grey[600]),
                          ],
                        ),
                      ),
                    );
                  },
                  loading: () => const Text('PlanPal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  error: (_, __) => const Text('PlanPal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                // Notification and Profile
                Row(
                  children: [
                    StreamBuilder(
                      stream: workspaceId != null 
                        ? ref.read(notificationRepositoryProvider).watchUnreadCount(userProfile?.id ?? '', workspaceId)
                        : Stream.value(0),
                      builder: (context, snapshot) {
                        final unreadCount = snapshot.data ?? 0;
                        return IconButton(
                          icon: unreadCount > 0
                              ? Badge(label: Text(unreadCount > 9 ? '9+' : '$unreadCount'), child: const Icon(Icons.notifications_outlined))
                              : const Icon(Icons.notifications_outlined),
                          onPressed: () => Navigator.pushNamed(context, '/notifications'),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/profile'),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary,
                        backgroundImage: userProfile?.avatarUrl != null ? NetworkImage(userProfile!.avatarUrl!) : null,
                        child: userProfile?.avatarUrl == null ? Text(userInitials, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)) : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Greeting
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_getGreeting()}, $firstName! ☀️', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("Let's make today productive.", style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
              ],
            ),
          ),
        ),

        // Your Tasks Today
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Your Tasks Today', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                TextButton(onPressed: () => Navigator.pushNamed(context, '/tasks'), child: const Text('View All →')),
              ],
            ),
          ),
        ),

        // Today's Tasks
        if (workspaceId != null)
          StreamBuilder(
            stream: taskRepository.watchTasksFiltered(workspaceId: workspaceId, view: TaskView.today),
            builder: (context, snapshot) {
              final tasks = (snapshot.data ?? []).take(3).toList();
              if (tasks.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.check_circle_outline, size: 48, color: theme.colorScheme.primary.withValues(alpha: 0.5)),
                              const SizedBox(height: 12),
                              Text('No tasks for today', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildTaskCard(context, tasks[index], false),
                    childCount: tasks.length,
                  ),
                ),
              );
            },
          ),

        // Quick Actions
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildQuickActionCard(context, 'New Task', Icons.add_task, AppColors.primary, () => Navigator.pushNamed(context, '/tasks/new'))),
                    const SizedBox(width: 12),
                    Expanded(child: _buildQuickActionCard(context, 'Calendar', Icons.calendar_today, const Color(0xFF10B981), () => Navigator.pushNamed(context, '/calendar'))),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildQuickActionCard(context, 'Analytics', Icons.bar_chart, const Color(0xFFF59E0B), () => Navigator.pushNamed(context, '/analytics'))),
                    const SizedBox(width: 12),
                    Expanded(child: _buildQuickActionCard(context, 'Documents', Icons.description, const Color(0xFF8B5CF6), () => Navigator.pushNamed(context, '/documents'))),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  // ========== DESKTOP LAYOUT ==========
  Widget _buildDesktopContent(BuildContext context, dynamic userProfile, String? workspaceId) {
    final userName = userProfile?.fullName ?? 'User';
    final firstName = userName.split(' ').first;
    final taskRepository = ref.watch(taskRepositoryProvider);

    return Row(
      children: [
        // Main Content Area
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting
                Text('${_getGreeting()}, $firstName! ☀️', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("Let's make today productive.", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                const SizedBox(height: 32),

                // Your Tasks Today
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Your Tasks Today', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Text('View All Tasks'),
                      label: const Icon(Icons.arrow_forward, size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Task Cards (3 columns)
                if (workspaceId != null)
                  StreamBuilder(
                    stream: taskRepository.watchTasksFiltered(workspaceId: workspaceId, view: TaskView.today),
                    builder: (context, snapshot) {
                      final tasks = (snapshot.data ?? []).take(3).toList();
                      return Row(
                        children: List.generate(3, (index) {
                          if (index < tasks.length) {
                            return Expanded(child: _buildDesktopTaskCard(context, tasks[index]));
                          }
                          return Expanded(child: Container());
                        }).expand((widget) => [widget, const SizedBox(width: 16)]).toList()..removeLast(),
                      );
                    },
                  ),

                const SizedBox(height: 32),

                // Quick Actions
                const Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildDesktopQuickAction('New Task', Icons.add, AppColors.primary, () => Navigator.pushNamed(context, '/tasks/new'))),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDesktopQuickAction('Calendar', Icons.calendar_today, const Color(0xFF10B981), () => Navigator.pushNamed(context, '/calendar'))),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDesktopQuickAction('Analytics', Icons.bar_chart, const Color(0xFFF59E0B), () => Navigator.pushNamed(context, '/analytics'))),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDesktopQuickAction('Documents', Icons.description, const Color(0xFF8B5CF6), () => Navigator.pushNamed(context, '/documents'))),
                  ],
                ),

                const SizedBox(height: 32),

                // Overview Section with Chart
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    DropdownButton<String>(
                      value: ref.watch(dashboardRangeProvider),
                      items: const [
                        DropdownMenuItem(value: 'week', child: Text('This Week')),
                        DropdownMenuItem(value: '7d', child: Text('Last 7 Days')),
                        DropdownMenuItem(value: '30d', child: Text('Last 30 Days')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          ref.read(dashboardRangeProvider.notifier).state = value;
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Stats Row - Using real analytics data
                if (workspaceId != null)
                  Consumer(
                    builder: (context, ref, _) {
                      final overviewAsync = ref.watch(dashboardOverviewProvider);
                      
                      return overviewAsync.when(
                        data: (overview) {
                          if (overview == null) {
                            // Fallback to task repository if analytics fails
                            return StreamBuilder(
                              stream: taskRepository.watchAllTasks(workspaceId),
                              builder: (context, snapshot) {
                                final allTasks = snapshot.data ?? [];
                                final completed = allTasks.where((t) => t.status == 'completed').length;
                                final inProgress = allTasks.where((t) => t.status == 'in_progress').length;
                                final overdue = allTasks.where((t) => t.dueDate != null && t.dueDate!.isBefore(DateTime.now()) && t.status != 'completed').length;
                                final productivity = allTasks.isEmpty ? 0 : ((completed / allTasks.length) * 100).round();
                                
                                return Row(
                                  children: [
                                    Expanded(child: _buildStatCard('$completed', 'Tasks Completed', Icons.check_circle, const Color(0xFF10B981))),
                                    const SizedBox(width: 16),
                                    Expanded(child: _buildStatCard('$inProgress', 'In Progress', Icons.sync, const Color(0xFF3B82F6))),
                                    const SizedBox(width: 16),
                                    Expanded(child: _buildStatCard('$overdue', 'Overdue', Icons.warning, const Color(0xFFF87171))),
                                    const SizedBox(width: 16),
                                    Expanded(child: _buildStatCard('$productivity%', 'Productivity', Icons.trending_up, const Color(0xFF8B5CF6))),
                                  ],
                                );
                              },
                            );
                          }
                          
                          // Use analytics data
                          final counts = overview.counts;
                          final productivity = overview.productivityPercent;
                          
                          return Row(
                            children: [
                              Expanded(child: _buildStatCard('${counts.completed}', 'Completed', Icons.check_circle, const Color(0xFF10B981))),
                              const SizedBox(width: 16),
                              Expanded(child: _buildStatCard('${counts.inProgress}', 'In Progress', Icons.sync, const Color(0xFF3B82F6))),
                              const SizedBox(width: 16),
                              Expanded(child: _buildStatCard('${counts.overdue}', 'Overdue', Icons.warning, const Color(0xFFF87171))),
                              const SizedBox(width: 16),
                              Expanded(child: _buildStatCard('$productivity%', 'Productivity', Icons.trending_up, const Color(0xFF8B5CF6))),
                            ],
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (_, __) => const SizedBox(),
                      );
                    },
                  ),

                const SizedBox(height: 24),
                
                // Chart - Using real data
                if (workspaceId != null)
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Consumer(
                      builder: (context, ref, _) {
                        final overviewAsync = ref.watch(dashboardOverviewProvider);
                        return overviewAsync.when(
                          data: (overview) => overview != null
                              ? _buildProductivityChart(overview.dailySeries)
                              : _buildProductivityChartFallback(),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (_, __) => _buildProductivityChartFallback(),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Right Sidebar - Calendar & Upcoming
        Container(
          width: 350,
          color: Colors.white,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar Widget
              _buildCalendarWidget(),
              const SizedBox(height: 32),
              
              // Upcoming Events
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Upcoming', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  TextButton(onPressed: () {}, child: const Text('View All')),
                ],
              ),
              const SizedBox(height: 16),
              if (workspaceId != null)
                Expanded(
                  child: StreamBuilder(
                    stream: taskRepository.watchTasksFiltered(workspaceId: workspaceId, view: TaskView.week),
                    builder: (context, snapshot) {
                      final tasks = (snapshot.data ?? []).take(4).toList();
                      return ListView.separated(
                        itemCount: tasks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => _buildUpcomingItem(tasks[index]),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductivityChart(List<dynamic> dailySeries) {
    if (dailySeries.isEmpty) {
      return _buildProductivityChartFallback();
    }

    // Convert daily series to chart spots
    final spots = <FlSpot>[];
    for (int i = 0; i < dailySeries.length && i < 7; i++) {
      final day = dailySeries[i];
      final completed = (day.completed as num?)?.toDouble() ?? 0.0;
      spots.add(FlSpot(i.toDouble(), completed));
    }

    // Get date labels
    final dateLabels = dailySeries.take(7).map((day) {
      try {
        final date = DateTime.parse(day.date as String);
        return DateFormat('MMM d').format(date);
      } catch (e) {
        return '';
      }
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey[200]!,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < dateLabels.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      dateLabels[index],
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (dailySeries.length - 1).toDouble(),
        minY: 0,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: AppColors.primary,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductivityChartFallback() {
    // Fallback chart with sample data
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final now = DateTime.now();
                final date = now.subtract(Duration(days: 6 - value.toInt()));
                return Text(DateFormat('MMM d').format(date), style: const TextStyle(fontSize: 10));
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 3),
              FlSpot(1, 2.5),
              FlSpot(2, 4),
              FlSpot(3, 3.5),
              FlSpot(4, 4.5),
              FlSpot(5, 4),
              FlSpot(6, 3),
            ],
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarWidget() {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final startingWeekday = firstDayOfMonth.weekday % 7;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Calendar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Row(
              children: [
                IconButton(icon: const Icon(Icons.chevron_left, size: 20), onPressed: () {}),
                const Text('Today'),
                IconButton(icon: const Icon(Icons.chevron_right, size: 20), onPressed: () {}),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('May 2024', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
              .map((day) => SizedBox(width: 32, child: Text(day, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey[600]))))
              .toList(),
        ),
        const SizedBox(height: 8),
        // Calendar grid
        ...List.generate((daysInMonth + startingWeekday) ~/ 7 + 1, (weekIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (dayIndex) {
                final dayNumber = weekIndex * 7 + dayIndex - startingWeekday + 1;
                final isValidDay = dayNumber > 0 && dayNumber <= daysInMonth;
                final isToday = isValidDay && dayNumber == now.day;

                return Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isToday ? AppColors.primary : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: isValidDay
                      ? Text(
                          '$dayNumber',
                          style: TextStyle(
                            fontSize: 12,
                            color: isToday ? Colors.white : Colors.black,
                            fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                          ),
                        )
                      : null,
                );
              }),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildUpcomingItem(dynamic task) {
    final priorityColor = task.priority == 'high' ? Colors.red : task.priority == 'medium' ? Colors.orange : Colors.green;
    return Row(
      children: [
        Container(width: 4, height: 4, decoration: BoxDecoration(color: priorityColor, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              Text(
                task.dueDate != null ? 'May ${task.dueDate!.day}, ${task.dueDate!.hour}:${task.dueDate!.minute.toString().padLeft(2, '0')} ${task.dueDate!.hour >= 12 ? 'PM' : 'AM'}' : 'No due date',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopTaskCard(BuildContext context, dynamic task) {
    final theme = Theme.of(context);
    final isPriorityHigh = task.priority == 'high' || task.priority == 'urgent';
    final priorityColor = task.priority == 'high' ? Colors.red : task.priority == 'medium' ? Colors.orange : Colors.green;
    final priorityLabel = task.priority == 'high' ? 'High Priority' : task.priority == 'medium' ? 'Med Priority' : 'Low Priority';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    final taskRepository = ref.read(taskRepositoryProvider);
                    taskRepository.toggleComplete(task.id, task.status != 'completed');
                  },
                  child: Icon(
                    task.status == 'completed' ? Icons.check_circle : Icons.check_circle_outline,
                    color: task.status == 'completed' ? Colors.green : Colors.grey,
                    size: 24,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              task.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              task.dueDate != null ? '${task.dueDate!.hour}:${task.dueDate!.minute.toString().padLeft(2, '0')} ${task.dueDate!.hour >= 12 ? 'PM' : 'AM'}' : '',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 8, color: priorityColor),
                      const SizedBox(width: 4),
                      Text(priorityLabel, style: TextStyle(fontSize: 11, color: priorityColor, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: const Text('Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopQuickAction(String label, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 12),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  // ========== SHARED WIDGETS ==========
  String _getUserInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  Widget _buildTaskCard(BuildContext context, dynamic task, bool isDesktop) {
    final theme = Theme.of(context);
    final isPriorityHigh = task.priority == 'high' || task.priority == 'urgent';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/tasks/${task.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  final taskRepository = ref.read(taskRepositoryProvider);
                  taskRepository.toggleComplete(task.id, task.status != 'completed');
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: task.status == 'completed' ? AppColors.primary : theme.colorScheme.outline, width: 2),
                    color: task.status == 'completed' ? AppColors.primary : Colors.transparent,
                  ),
                  child: task.status == 'completed' ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: task.status == 'completed' ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (task.dueDate != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                          const SizedBox(width: 4),
                          Text(
                            'Today, ${_formatTime(task.dueDate)}',
                            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (isPriorityHigh)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.flag, size: 12, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        task.priority == 'urgent' ? 'Urgent' : 'High',
                        style: const TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  Widget _buildQuickActionCard(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  // Workspace Switcher Modal (Like Asana/ClickUp/Notion)
  void _showWorkspaceSwitcher(BuildContext context, List<dynamic> workspaces, String? currentWorkspaceId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Switch Workspace',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Workspace List
            ...workspaces.map((workspace) {
              final isSelected = workspace.id == currentWorkspaceId;
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      workspace.name[0].toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  workspace.name,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  workspace.type == 'personal' ? 'Personal Workspace' : 'Team Workspace',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                trailing: isSelected 
                    ? const Icon(Icons.check, color: AppColors.primary) 
                    : null,
                onTap: () async {
                  if (!isSelected) {
                    // Switch workspace
                    ref.read(currentWorkspaceIdProvider.notifier).state = workspace.id;
                    
                    // Save last used workspace (like Asana/ClickUp/Notion)
                    final prefs = ref.read(sharedPreferencesProvider);
                    await prefs.setString('last_workspace_id', workspace.id);
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              );
            }),
            
            const Divider(height: 32),
            
            // Create New Workspace Button
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, color: AppColors.primary),
              ),
              title: const Text(
                'Create Workspace',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to create workspace screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Create workspace feature coming soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
