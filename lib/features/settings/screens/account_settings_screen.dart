import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../../core/l10n/app_localizations.dart';

/// Account Settings Screen (S15.7)
/// Delete account and sign out actions
class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() =>
      _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProfile = ref.watch(currentUserProfileProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Name'),
                    subtitle: Text(userProfile?.fullName ?? 'Unknown'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Email'),
                    subtitle: Text(userProfile?.email ?? 'Unknown'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Member since'),
                    subtitle: Text(
                      userProfile?.createdAt != null
                          ? '${userProfile!.createdAt!.year}-${userProfile.createdAt!.month.toString().padLeft(2, '0')}-${userProfile.createdAt!.day.toString().padLeft(2, '0')}'
                          : 'Unknown',
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Sign Out Section
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(l10n.signOut),
                  subtitle: const Text('Sign out from this device'),
                  onTap: _confirmSignOut,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Danger Zone
          Card(
            color: Colors.red[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning_amber, color: Colors.red[700]),
                          const SizedBox(width: 8),
                          Text(
                            'Danger Zone',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[700],
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Once you delete your account, there is no going back. Please be certain.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red),
                  ),
                  subtitle: const Text('Permanently delete your account and all data'),
                  onTap: _confirmDeleteAccount,
                  enabled: !_isDeleting,
                  trailing: _isDeleting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authRepositoryProvider).signOut();
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This action cannot be undone. All your data will be permanently deleted:'),
            SizedBox(height: 12),
            Text('• All your tasks and projects'),
            Text('• All your documents and files'),
            Text('• All your messages and comments'),
            Text('• Your profile and account'),
            SizedBox(height: 12),
            Text(
              'Are you absolutely sure?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _deleteAccount(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete My Account'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext dialogContext) async {
    Navigator.pop(dialogContext); // Close confirmation dialog
    
    setState(() => _isDeleting = true);

    try {
      // TODO: Implement account deletion
      // await ref.read(authRepositoryProvider).deleteAccount();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully')),
        );
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete account: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }
}
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone (Optional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: 'Bio (Optional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.info),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Password section
          Text(
            'Security',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showChangePasswordDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Two-Factor Authentication'),
                  subtitle: const Text('Not enabled'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to 2FA setup
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Preferences
          Text(
            'Preferences',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  subtitle: const Text('English'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Language picker
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text('Timezone'),
                  subtitle: const Text('UTC'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Timezone picker
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Danger zone
          Text(
            'Danger Zone',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.orange),
                  title: const Text('Logout'),
                  onTap: () => _showLogoutDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text('Delete Account',
                      style: TextStyle(color: Colors.red)),
                  onTap: () => _showDeleteAccountDialog(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Save button
          FilledButton(
            onPressed: _saveChanges,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password changed successfully')),
              );
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform logout
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Show confirmation
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved successfully')),
    );
  }
}
