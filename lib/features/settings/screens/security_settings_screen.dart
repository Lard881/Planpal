import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecuritySettingsScreen extends ConsumerStatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  ConsumerState<SecuritySettingsScreen> createState() =>
      _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState
    extends ConsumerState<SecuritySettingsScreen> {
  bool _twoFactorEnabled = false;
  bool _biometricEnabled = false;
  bool _sessionTimeout = true;
  int _timeoutMinutes = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Authentication
          Text(
            'Authentication',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: _twoFactorEnabled,
                  onChanged: (value) {
                    setState(() {
                      _twoFactorEnabled = value;
                    });
                    if (value) {
                      _show2FASetupDialog(context);
                    }
                  },
                  title: const Text('Two-Factor Authentication'),
                  subtitle: Text(
                    _twoFactorEnabled
                        ? 'Enabled - Extra security layer'
                        : 'Disabled - Tap to enable',
                  ),
                  secondary: const Icon(Icons.security),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _biometricEnabled,
                  onChanged: (value) {
                    setState(() {
                      _biometricEnabled = value;
                    });
                  },
                  title: const Text('Biometric Login'),
                  subtitle: const Text('Use fingerprint or face recognition'),
                  secondary: const Icon(Icons.fingerprint),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Password
          Text(
            'Password',
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
                  subtitle: const Text('Last changed 30 days ago'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showChangePasswordDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Password History'),
                  subtitle: const Text('View previous password changes'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Show password history
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sessions
          Text(
            'Sessions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: _sessionTimeout,
                  onChanged: (value) {
                    setState(() {
                      _sessionTimeout = value;
                    });
                  },
                  title: const Text('Auto Lock'),
                  subtitle: Text(
                    _sessionTimeout
                        ? 'Lock after $_timeoutMinutes minutes'
                        : 'Disabled',
                  ),
                  secondary: const Icon(Icons.timer),
                ),
                if (_sessionTimeout) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Timeout Duration: $_timeoutMinutes minutes',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Slider(
                          value: _timeoutMinutes.toDouble(),
                          min: 5,
                          max: 60,
                          divisions: 11,
                          label: '$_timeoutMinutes min',
                          onChanged: (value) {
                            setState(() {
                              _timeoutMinutes = value.toInt();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.devices),
                  title: const Text('Active Sessions'),
                  subtitle: const Text('Manage your active devices'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showActiveSessionsDialog(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Privacy
          Text(
            'Privacy',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.visibility),
                  title: const Text('Privacy Settings'),
                  subtitle: const Text('Control who can see your information'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to privacy settings
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text('Blocked Users'),
                  subtitle: const Text('Manage blocked users'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Show blocked users
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Data & Permissions
          Text(
            'Data & Permissions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Download Your Data'),
                  subtitle: const Text('Export all your data'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(context, '/analytics/export');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.vpn_key),
                  title: const Text('App Permissions'),
                  subtitle: const Text('Manage app permissions'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Show permissions
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Save button
          FilledButton(
            onPressed: _saveSettings,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _show2FASetupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable 2FA'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.qr_code, size: 120),
            const SizedBox(height: 16),
            const Text('Scan this QR code with your authenticator app'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Enter 6-digit code',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _twoFactorEnabled = false;
              });
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('2FA enabled successfully')),
              );
            },
            child: const Text('Enable'),
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
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
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
                const SnackBar(content: Text('Password changed')),
              );
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showActiveSessionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Active Sessions'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _SessionItem(
                device: 'Android Phone',
                location: 'New York, USA',
                lastActive: 'Active now',
                isCurrent: true,
              ),
              const Divider(),
              _SessionItem(
                device: 'Windows Desktop',
                location: 'New York, USA',
                lastActive: '2 hours ago',
                isCurrent: false,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All sessions terminated')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout All'),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Security settings saved')),
    );
  }
}

class _SessionItem extends StatelessWidget {
  final String device;
  final String location;
  final String lastActive;
  final bool isCurrent;

  const _SessionItem({
    required this.device,
    required this.location,
    required this.lastActive,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.devices),
      title: Row(
        children: [
          Text(device),
          if (isCurrent) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Current',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ],
      ),
      subtitle: Text('$location\n$lastActive'),
      isThreeLine: true,
      trailing: isCurrent
          ? null
          : IconButton(
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: () {
                // Terminate session
              },
            ),
    );
  }
}
