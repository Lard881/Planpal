/// User profile model
class UserProfile {
  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final String timezone;
  final String language;
  final String theme;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    required this.timezone,
    required this.language,
    required this.theme,
    required this.createdAt,
  });

  /// Create from JSON (from backend /me endpoint)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String? ?? json['full_name'] as String? ?? 'User',
      avatarUrl: json['avatarUrl'] as String? ?? json['avatar_url'] as String?,
      timezone: json['timezone'] as String? ?? 'UTC',
      language: json['language'] as String? ?? 'en',
      theme: json['theme'] as String? ?? 'system',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'timezone': timezone,
      'language': language,
      'theme': theme,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Copy with
  UserProfile copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    String? timezone,
    String? language,
    String? theme,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      timezone: timezone ?? this.timezone,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, email: $email, fullName: $fullName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
