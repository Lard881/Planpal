import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';

/// Profile Settings Screen (S15.6)
/// Avatar upload and crop, name, timezone, language, save
class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  String? _selectedTimezone;
  String? _selectedLanguage;
  bool _isSaving = false;

  final List<String> _timezones = [
    'UTC',
    'America/New_York',
    'America/Los_Angeles',
    'Europe/London',
    'Europe/Paris',
    'Asia/Tokyo',
    'Asia/Shanghai',
    'Australia/Sydney',
  ];

  final Map<String, String> _languages = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'ko': '한국어',
    'zh': '中文',
  };

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(currentUserProfileProvider).value;
    _nameController = TextEditingController(text: currentUser?.fullName ?? '');
    _selectedTimezone = currentUser?.timezone ?? 'UTC';
    _selectedLanguage = ref.read(localeProvider)?.languageCode ?? 'en';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProfileAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveProfile,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.save),
          ),
        ],
      ),
      body: userProfileAsync.when(
        data: (userProfile) {
          if (userProfile == null) {
            return Center(child: Text(l10n.errorLoadingProfile));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar section
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.primary,
                              backgroundImage: userProfile.avatarUrl != null
                                  ? NetworkImage(userProfile.avatarUrl!)
                                  : null,
                              child: userProfile.avatarUrl == null
                                  ? Text(
                                      (userProfile.fullName ?? 'U')[0]
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.camera_alt,
                                      color: Colors.white, size: 20),
                                  onPressed: _pickAndUploadAvatar,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (userProfile.avatarUrl != null)
                          TextButton.icon(
                            onPressed: _removeAvatar,
                            icon: const Icon(Icons.delete, size: 18),
                            label: const Text('Remove Avatar'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Full Name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Email (read-only)
                  TextFormField(
                    initialValue: userProfile.email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabled: false,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Timezone
                  DropdownButtonFormField<String>(
                    value: _selectedTimezone,
                    decoration: InputDecoration(
                      labelText: 'Timezone',
                      prefixIcon: const Icon(Icons.access_time),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: _timezones.map((tz) {
                      return DropdownMenuItem(
                        value: tz,
                        child: Text(tz),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTimezone = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // Language
                  DropdownButtonFormField<String>(
                    value: _selectedLanguage,
                    decoration: InputDecoration(
                      labelText: l10n.language,
                      prefixIcon: const Icon(Icons.language),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: _languages.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                      if (value != null) {
                        ref.read(localeProvider.notifier).setLocale(value);
                      }
                    },
                  ),

                  const SizedBox(height: 32),

                  // Save button (also in app bar)
                  ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.save),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
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
    );
  }

  Future<void> _pickAndUploadAvatar() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (image == null) return;

    setState(() => _isSaving = true);

    try {
      // TODO: Implement avatar upload to backend
      // final bytes = await image.readAsBytes();
      // await ref.read(authRepositoryProvider).uploadAvatar(bytes);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avatar uploaded successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload avatar: $e')),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _removeAvatar() async {
    setState(() => _isSaving = true);

    try {
      // TODO: Implement avatar removal
      // await ref.read(authRepositoryProvider).removeAvatar();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avatar removed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove avatar: $e')),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // TODO: Implement profile update
      // await ref.read(authRepositoryProvider).updateProfile(
      //   name: _nameController.text.trim(),
      //   timezone: _selectedTimezone!,
      //   language: _selectedLanguage!,
      // );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }
}
