import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Desktop Sidebar Navigation
/// Matches the design mockup with PlanPal logo, navigation items, and upgrade button
class DesktopSidebar extends StatelessWidget {
  final String currentRoute;

  const DesktopSidebar({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color(0xFF1E293B), // Dark blue-gray
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PlanPal Logo
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'PlanPal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Navigation Items
          _buildNavItem(context, Icons.home_outlined, Icons.home, 'Home', '/home'),
          _buildNavItem(context, Icons.task_alt_outlined, Icons.task_alt, 'Tasks', '/tasks'),
          _buildNavItem(context, Icons.calendar_today_outlined, Icons.calendar_today, 'Calendar', '/calendar'),
          _buildNavItem(context, Icons.chat_bubble_outline, Icons.chat_bubble, 'Chat', '/chat'),
          _buildNavItem(context, Icons.description_outlined, Icons.description, 'Documents', '/documents'),
          _buildNavItem(context, Icons.bar_chart_outlined, Icons.bar_chart, 'Analytics', '/analytics'),
          _buildNavItem(context, Icons.people_outline, Icons.people, 'Team', '/team'),
          _buildNavItem(context, Icons.settings_outlined, Icons.settings, 'Settings', '/settings'),

          const Spacer(),

          // Upgrade to Pro Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upgrade to Pro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Unlock power features and amplify your productivity.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Upgrade Now',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    IconData activeIcon,
    String label,
    String route,
  ) {
    final isActive = currentRoute == route;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          isActive ? activeIcon : icon,
          color: isActive ? AppColors.primary : Colors.white.withValues(alpha: 0.8),
          size: 24,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.primary : Colors.white.withValues(alpha: 0.8),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
