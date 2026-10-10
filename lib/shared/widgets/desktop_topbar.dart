import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../features/auth/presentation/auth_providers.dart';
import '../../core/providers/app_providers.dart';

/// Desktop Top Bar
/// Matches the design mockup with search, notifications, and user profile
class DesktopTopBar extends ConsumerWidget {
  const DesktopTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(currentUserProfileProvider);
    final workspaceId = ref.watch(currentWorkspaceIdProvider);

    return Container(
      height: 72,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            flex: 2,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search tasks, projects...',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20),
                  suffixText: '⌘K',
                  suffixStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (value) {
                  // TODO: Implement search
                },
              ),
            ),
          ),

          const Spacer(),

          // Notifications
          StreamBuilder(
            stream: workspaceId != null
                ? ref.read(notificationRepositoryProvider).watchUnreadCount()
                : Stream.value(0),
            builder: (context, snapshot) {
              final unreadCount = snapshot.data ?? 0;
              return IconButton(
                icon: unreadCount > 0
                    ? Badge(
                        label: Text(unreadCount > 9 ? '9+' : '$unreadCount'),
                        child: const Icon(Icons.notifications_outlined),
                      )
                    : const Icon(Icons.notifications_outlined),
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              );
            },
          ),

          const SizedBox(width: 16),

          // User Profile
          userProfileAsync.when(
            data: (userProfile) {
              final userName = userProfile?.fullName ?? 'User';
              final userInitials = _getUserInitials(userName);

              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primary,
                        backgroundImage: userProfile?.avatarUrl != null
                            ? NetworkImage(userProfile!.avatarUrl!)
                            : null,
                        child: userProfile?.avatarUrl == null
                            ? Text(
                                userInitials,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Workspace Admin',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Icon(Icons.error),
          ),
        ],
      ),
    );
  }

  String _getUserInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}
