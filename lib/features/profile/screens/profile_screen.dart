import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../auth/presentation/auth_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/db/app_database.dart';

/// Profile Screen - Shows user profile information
/// Matches mobile design mockup with REAL user data from database
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userProfileAsync = ref.watch(currentUserProfileProvider);
    final workspaceId = ref.watch(currentWorkspaceIdProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: userProfileAsync.when(
          data: (userProfile) => _buildContent(context, ref, userProfile, workspaceId),
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
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, dynamic userProfile, String? workspaceId) {
    final theme = Theme.of(context);
    final userName = userProfile?.fullName ?? 'User';
    final userEmail = userProfile?.email ?? 'email@example.com';
    final userInitials = _getUserInitials(userName);
    final taskRepository = ref.watch(taskRepositoryProvider);

    return CustomScrollView(
      slivers: [
        // Profile Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                // Profile Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.primary,
                          backgroundImage: userProfile?.avatarUrl != null
                              ? NetworkImage(userProfile!.avatarUrl!)
                              : null,
                          child: userProfile?.avatarUrl == null
                              ? Text(
                                  userInitials,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 16),
                        // Name
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Email
                        Text(
                          userEmail,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Role badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Workspace Admin',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Edit Profile Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              // TODO: Navigate to edit profile
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Stats Section - REAL DATA from database
        if (workspaceId != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<List<Task>>(
                stream: taskRepository.watchTasks(workspaceId),
                builder: (context, snapshot) {
                  final allTasks = snapshot.data ?? <Task>[];
                  final completedCount = allTasks.where((t) => t.status == 'completed').length;
                  
                  // Count unique projects
                  final projectIds = allTasks
                      .where((t) => t.projectId != null)
                      .map((t) => t.projectId)
                      .toSet();
                  final projectCount = projectIds.length;
                  
                  // Calculate streak (days with completed tasks)
                  final completedTasks = allTasks.where((t) => t.completedAt != null).toList();
                  final streakDays = _calculateStreak(completedTasks);
                  
                  return Row(
                    children: [
                      Expanded(child: _buildStatCard('$completedCount', 'Completed', theme)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatCard('$projectCount', 'Projects', theme)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatCard('${streakDays}d', 'Streak', theme)),
                    ],
                  );
                },
              ),
            ),
          )
        else
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(child: _buildStatCard('0', 'Completed', theme)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('0', 'Projects', theme)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('0d', 'Streak', theme)),
                ],
              ),
            ),
          ),

        // Recent Activity Section - REAL DATA from tasks
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // Activity List - REAL DATA
        if (workspaceId != null)
          StreamBuilder<List<Task>>(
            stream: taskRepository.watchTasks(workspaceId),
            builder: (context, snapshot) {
              final allTasks = snapshot.data ?? <Task>[];
              
              // Get recently completed or updated tasks
              final recentTasks = (allTasks as List)
                  .where((t) => t.completedAt != null || t.updatedAt.isAfter(DateTime.now().subtract(const Duration(days: 7))))
                  .toList()
                ..sort((a, b) {
                  final aTime = a.completedAt ?? a.updatedAt;
                  final bTime = b.completedAt ?? b.updatedAt;
                  return bTime.compareTo(aTime);
                });
              
              final displayTasks = recentTasks.take(5).toList();
              
              if (displayTasks.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: theme.colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          child: Text(
                            'No recent activity',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
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
                    (context, index) {
                      final task = displayTasks[index];
                      final isCompleted = task.status == 'completed';
                      final timeAgo = timeago.format(
                        task.completedAt ?? task.updatedAt,
                      );
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildActivityItem(
                          context,
                          isCompleted ? Icons.check_circle : Icons.edit,
                          isCompleted ? 'Marked completed' : 'Updated',
                          task.title,
                          timeAgo,
                          theme,
                        ),
                      );
                    },
                    childCount: displayTasks.length,
                  ),
                ),
              );
            },
          )
        else
          const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          ),

        // Add bottom padding for nav bar
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  int _calculateStreak(List<dynamic> completedTasks) {
    if (completedTasks.isEmpty) return 0;
    
    // Sort by completion date descending
    final sorted = completedTasks.toList()
      ..sort((a, b) => b.completedAt!.compareTo(a.completedAt!));
    
    int streak = 0;
    DateTime? lastDate;
    
    for (final task in sorted) {
      final completionDate = DateTime(
        task.completedAt!.year,
        task.completedAt!.month,
        task.completedAt!.day,
      );
      
      if (lastDate == null) {
        // First task - check if it's today or yesterday
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        final yesterday = todayDate.subtract(const Duration(days: 1));
        
        if (completionDate == todayDate || completionDate == yesterday) {
          streak = 1;
          lastDate = completionDate;
        } else {
          // Streak is broken
          break;
        }
      } else {
        final expectedDate = lastDate.subtract(const Duration(days: 1));
        if (completionDate == expectedDate || completionDate == lastDate) {
          if (completionDate != lastDate) {
            streak++;
          }
          lastDate = completionDate;
        } else {
          // Streak is broken
          break;
        }
      }
    }
    
    return streak;
  }

  String _getUserInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  Widget _buildStatCard(String value, String label, ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    IconData icon,
    String action,
    String target,
    String time,
    ThemeData theme,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                      children: [
                        TextSpan(
                          text: '$action ',
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text: target,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
