// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationSettings _$NotificationSettingsFromJson(Map<String, dynamic> json) {
  return _NotificationSettings.fromJson(json);
}

/// @nodoc
mixin _$NotificationSettings {
// Push notification settings
  bool get pushEnabled => throw _privateConstructorUsedError;
  bool get soundEnabled => throw _privateConstructorUsedError;
  bool get vibrationEnabled =>
      throw _privateConstructorUsedError; // Task notifications
  bool get taskAssignedEnabled => throw _privateConstructorUsedError;
  bool get taskCompletedEnabled => throw _privateConstructorUsedError;
  bool get taskOverdueEnabled => throw _privateConstructorUsedError;
  bool get taskDueSoonEnabled => throw _privateConstructorUsedError;
  bool get taskCommentedEnabled => throw _privateConstructorUsedError;
  bool get taskStatusChangedEnabled =>
      throw _privateConstructorUsedError; // Project notifications
  bool get projectInviteEnabled => throw _privateConstructorUsedError;
  bool get projectUpdatedEnabled => throw _privateConstructorUsedError;
  bool get projectDeadlineEnabled =>
      throw _privateConstructorUsedError; // Event notifications
  bool get eventReminderEnabled => throw _privateConstructorUsedError;
  bool get eventStartingSoonEnabled => throw _privateConstructorUsedError;
  bool get eventUpdatedEnabled => throw _privateConstructorUsedError;
  bool get eventCancelledEnabled =>
      throw _privateConstructorUsedError; // Chat notifications
  bool get chatMessageEnabled => throw _privateConstructorUsedError;
  bool get chatMentionEnabled =>
      throw _privateConstructorUsedError; // Workspace notifications
  bool get workspaceInviteEnabled => throw _privateConstructorUsedError;
  bool get workspaceRoleChangedEnabled =>
      throw _privateConstructorUsedError; // System notifications
  bool get systemEnabled => throw _privateConstructorUsedError; // Quiet hours
  bool get quietHoursEnabled => throw _privateConstructorUsedError;
  int get quietHoursStart => throw _privateConstructorUsedError; // 10 PM
  int get quietHoursEnd => throw _privateConstructorUsedError;

  /// Serializes this NotificationSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationSettingsCopyWith<NotificationSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingsCopyWith<$Res> {
  factory $NotificationSettingsCopyWith(NotificationSettings value,
          $Res Function(NotificationSettings) then) =
      _$NotificationSettingsCopyWithImpl<$Res, NotificationSettings>;
  @useResult
  $Res call(
      {bool pushEnabled,
      bool soundEnabled,
      bool vibrationEnabled,
      bool taskAssignedEnabled,
      bool taskCompletedEnabled,
      bool taskOverdueEnabled,
      bool taskDueSoonEnabled,
      bool taskCommentedEnabled,
      bool taskStatusChangedEnabled,
      bool projectInviteEnabled,
      bool projectUpdatedEnabled,
      bool projectDeadlineEnabled,
      bool eventReminderEnabled,
      bool eventStartingSoonEnabled,
      bool eventUpdatedEnabled,
      bool eventCancelledEnabled,
      bool chatMessageEnabled,
      bool chatMentionEnabled,
      bool workspaceInviteEnabled,
      bool workspaceRoleChangedEnabled,
      bool systemEnabled,
      bool quietHoursEnabled,
      int quietHoursStart,
      int quietHoursEnd});
}

/// @nodoc
class _$NotificationSettingsCopyWithImpl<$Res,
        $Val extends NotificationSettings>
    implements $NotificationSettingsCopyWith<$Res> {
  _$NotificationSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pushEnabled = null,
    Object? soundEnabled = null,
    Object? vibrationEnabled = null,
    Object? taskAssignedEnabled = null,
    Object? taskCompletedEnabled = null,
    Object? taskOverdueEnabled = null,
    Object? taskDueSoonEnabled = null,
    Object? taskCommentedEnabled = null,
    Object? taskStatusChangedEnabled = null,
    Object? projectInviteEnabled = null,
    Object? projectUpdatedEnabled = null,
    Object? projectDeadlineEnabled = null,
    Object? eventReminderEnabled = null,
    Object? eventStartingSoonEnabled = null,
    Object? eventUpdatedEnabled = null,
    Object? eventCancelledEnabled = null,
    Object? chatMessageEnabled = null,
    Object? chatMentionEnabled = null,
    Object? workspaceInviteEnabled = null,
    Object? workspaceRoleChangedEnabled = null,
    Object? systemEnabled = null,
    Object? quietHoursEnabled = null,
    Object? quietHoursStart = null,
    Object? quietHoursEnd = null,
  }) {
    return _then(_value.copyWith(
      pushEnabled: null == pushEnabled
          ? _value.pushEnabled
          : pushEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      soundEnabled: null == soundEnabled
          ? _value.soundEnabled
          : soundEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      vibrationEnabled: null == vibrationEnabled
          ? _value.vibrationEnabled
          : vibrationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      taskAssignedEnabled: null == taskAssignedEnabled
          ? _value.taskAssignedEnabled
          : taskAssignedEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      taskCompletedEnabled: null == taskCompletedEnabled
          ? _value.taskCompletedEnabled
          : taskCompletedEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      taskOverdueEnabled: null == taskOverdueEnabled
          ? _value.taskOverdueEnabled
          : taskOverdueEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      taskDueSoonEnabled: null == taskDueSoonEnabled
          ? _value.taskDueSoonEnabled
          : taskDueSoonEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      taskCommentedEnabled: null == taskCommentedEnabled
          ? _value.taskCommentedEnabled
          : taskCommentedEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      taskStatusChangedEnabled: null == taskStatusChangedEnabled
          ? _value.taskStatusChangedEnabled
          : taskStatusChangedEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      projectInviteEnabled: null == projectInviteEnabled
          ? _value.projectInviteEnabled
          : projectInviteEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      projectUpdatedEnabled: null == projectUpdatedEnabled
          ? _value.projectUpdatedEnabled
          : projectUpdatedEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      projectDeadlineEnabled: null == projectDeadlineEnabled
          ? _value.projectDeadlineEnabled
          : projectDeadlineEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      eventReminderEnabled: null == eventReminderEnabled
          ? _value.eventReminderEnabled
          : eventReminderEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      eventStartingSoonEnabled: null == eventStartingSoonEnabled
          ? _value.eventStartingSoonEnabled
          : eventStartingSoonEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      eventUpdatedEnabled: null == eventUpdatedEnabled
          ? _value.eventUpdatedEnabled
          : eventUpdatedEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      eventCancelledEnabled: null == eventCancelledEnabled
          ? _value.eventCancelledEnabled
          : eventCancelledEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      chatMessageEnabled: null == chatMessageEnabled
          ? _value.chatMessageEnabled
          : chatMessageEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      chatMentionEnabled: null == chatMentionEnabled
          ? _value.chatMentionEnabled
          : chatMentionEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      workspaceInviteEnabled: null == workspaceInviteEnabled
          ? _value.workspaceInviteEnabled
          : workspaceInviteEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      workspaceRoleChangedEnabled: null == workspaceRoleChangedEnabled
          ? _value.workspaceRoleChangedEnabled
          : workspaceRoleChangedEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      systemEnabled: null == systemEnabled
          ? _value.systemEnabled
          : systemEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      quietHoursEnabled: null == quietHoursEnabled
          ? _value.quietHoursEnabled
          : quietHoursEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      quietHoursStart: null == quietHoursStart
          ? _value.quietHoursStart
          : quietHoursStart // ignore: cast_nullable_to_non_nullable
              as int,
      quietHoursEnd: null == quietHoursEnd
          ? _value.quietHoursEnd
          : quietHoursEnd // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationSettingsImplCopyWith<$Res>
    implements $NotificationSettingsCopyWith<$Res> {
  factory _$$NotificationSettingsImplCopyWith(_$NotificationSettingsImpl value,
          $Res Function(_$NotificationSettingsImpl) then) =
      __$$NotificationSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool pushEnabled,
      bool soundEnabled,
      bool vibrationEnabled,
      bool taskAssignedEnabled,
      bool taskCompletedEnabled,
      bool taskOverdueEnabled,
      bool taskDueSoonEnabled,
      bool taskCommentedEnabled,
      bool taskStatusChangedEnabled,
      bool projectInviteEnabled,
      bool projectUpdatedEnabled,
      bool projectDeadlineEnabled,
      bool eventReminderEnabled,
      bool eventStartingSoonEnabled,
      bool eventUpdatedEnabled,
      bool eventCancelledEnabled,
      bool chatMessageEnabled,
      bool chatMentionEnabled,
      bool workspaceInviteEnabled,
      bool workspaceRoleChangedEnabled,
      bool systemEnabled,
      bool quietHoursEnabled,
      int quietHoursStart,
      int quietHoursEnd});
}

/// @nodoc
class __$$NotificationSettingsImplCopyWithImpl<$Res>
    extends _$NotificationSettingsCopyWithImpl<$Res, _$NotificationSettingsImpl>
    implements _$$NotificationSettingsImplCopyWith<$Res> {
  __$$NotificationSettingsImplCopyWithImpl(_$NotificationSettingsImpl _value,
      $Res Function(_$NotificationSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pushEnabled = null,
    Object? soundEnabled = null,
    Object? vibrationEnabled = null,
    Object? taskAssignedEnabled = null,
    Object? taskCompletedEnabled = null,
    Object? taskOverdueEnabled = null,
    Object? taskDueSoonEnabled = null,
    Object? taskCommentedEnabled = null,
    Object? taskStatusChangedEnabled = null,
    Object? projectInviteEnabled = null,
    Object? projectUpdatedEnabled = null,
    Object? projectDeadlineEnabled = null,
    Object? eventReminderEnabled = null,
    Object? eventStartingSoonEnabled = null,
    Object? eventUpdatedEnabled = null,
    Object? eventCancelledEnabled = null,
    Object? chatMessageEnabled = null,
    Object? chatMentionEnabled = null,
    Object? workspaceInviteEnabled = null,
    Object? workspaceRoleChangedEnabled = null,
    Object? systemEnabled = null,
    Object? quietHoursEnabled = null,
    Object? quietHoursStart = null,
    Object? quietHoursEnd = null,
  }) {
    return _then(_$NotificationSettingsImpl(
      pushEnabled: null == pushEnabled
          ? _value.pushEnabled
          : pushEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      soundEnabled: null == soundEnabled
          ? _value.soundEnabled
          : soundEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      vibrationEnabled: null == vibrationEnabled
          ? _value.vibrationEnabled
          : vibrationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      taskAssignedEnabled: null == taskAssignedEnabled
          ? _value.taskAssignedEnabled
          : taskAssignedEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      taskCompletedEnabled: null == taskCompletedEnabled
          ? _value.taskCompletedEnabled
          : taskCompletedEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      taskOverdueEnabled: null == taskOverdueEnabled
          ? _value.taskOverdueEnabled
          : taskOverdueEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      taskDueSoonEnabled: null == taskDueSoonEnabled
          ? _value.taskDueSoonEnabled
          : taskDueSoonEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      taskCommentedEnabled: null == taskCommentedEnabled
          ? _value.taskCommentedEnabled
          : taskCommentedEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      taskStatusChangedEnabled: null == taskStatusChangedEnabled
          ? _value.taskStatusChangedEnabled
          : taskStatusChangedEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      projectInviteEnabled: null == projectInviteEnabled
          ? _value.projectInviteEnabled
          : projectInviteEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      projectUpdatedEnabled: null == projectUpdatedEnabled
          ? _value.projectUpdatedEnabled
          : projectUpdatedEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      projectDeadlineEnabled: null == projectDeadlineEnabled
          ? _value.projectDeadlineEnabled
          : projectDeadlineEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      eventReminderEnabled: null == eventReminderEnabled
          ? _value.eventReminderEnabled
          : eventReminderEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      eventStartingSoonEnabled: null == eventStartingSoonEnabled
          ? _value.eventStartingSoonEnabled
          : eventStartingSoonEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      eventUpdatedEnabled: null == eventUpdatedEnabled
          ? _value.eventUpdatedEnabled
          : eventUpdatedEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      eventCancelledEnabled: null == eventCancelledEnabled
          ? _value.eventCancelledEnabled
          : eventCancelledEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      chatMessageEnabled: null == chatMessageEnabled
          ? _value.chatMessageEnabled
          : chatMessageEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      chatMentionEnabled: null == chatMentionEnabled
          ? _value.chatMentionEnabled
          : chatMentionEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      workspaceInviteEnabled: null == workspaceInviteEnabled
          ? _value.workspaceInviteEnabled
          : workspaceInviteEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      workspaceRoleChangedEnabled: null == workspaceRoleChangedEnabled
          ? _value.workspaceRoleChangedEnabled
          : workspaceRoleChangedEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      systemEnabled: null == systemEnabled
          ? _value.systemEnabled
          : systemEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      quietHoursEnabled: null == quietHoursEnabled
          ? _value.quietHoursEnabled
          : quietHoursEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      quietHoursStart: null == quietHoursStart
          ? _value.quietHoursStart
          : quietHoursStart // ignore: cast_nullable_to_non_nullable
              as int,
      quietHoursEnd: null == quietHoursEnd
          ? _value.quietHoursEnd
          : quietHoursEnd // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationSettingsImpl implements _NotificationSettings {
  const _$NotificationSettingsImpl(
      {this.pushEnabled = true,
      this.soundEnabled = true,
      this.vibrationEnabled = true,
      this.taskAssignedEnabled = true,
      this.taskCompletedEnabled = true,
      this.taskOverdueEnabled = true,
      this.taskDueSoonEnabled = true,
      this.taskCommentedEnabled = true,
      this.taskStatusChangedEnabled = true,
      this.projectInviteEnabled = true,
      this.projectUpdatedEnabled = true,
      this.projectDeadlineEnabled = true,
      this.eventReminderEnabled = true,
      this.eventStartingSoonEnabled = true,
      this.eventUpdatedEnabled = true,
      this.eventCancelledEnabled = true,
      this.chatMessageEnabled = true,
      this.chatMentionEnabled = true,
      this.workspaceInviteEnabled = true,
      this.workspaceRoleChangedEnabled = true,
      this.systemEnabled = true,
      this.quietHoursEnabled = false,
      this.quietHoursStart = 22,
      this.quietHoursEnd = 7});

  factory _$NotificationSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationSettingsImplFromJson(json);

// Push notification settings
  @override
  @JsonKey()
  final bool pushEnabled;
  @override
  @JsonKey()
  final bool soundEnabled;
  @override
  @JsonKey()
  final bool vibrationEnabled;
// Task notifications
  @override
  @JsonKey()
  final bool taskAssignedEnabled;
  @override
  @JsonKey()
  final bool taskCompletedEnabled;
  @override
  @JsonKey()
  final bool taskOverdueEnabled;
  @override
  @JsonKey()
  final bool taskDueSoonEnabled;
  @override
  @JsonKey()
  final bool taskCommentedEnabled;
  @override
  @JsonKey()
  final bool taskStatusChangedEnabled;
// Project notifications
  @override
  @JsonKey()
  final bool projectInviteEnabled;
  @override
  @JsonKey()
  final bool projectUpdatedEnabled;
  @override
  @JsonKey()
  final bool projectDeadlineEnabled;
// Event notifications
  @override
  @JsonKey()
  final bool eventReminderEnabled;
  @override
  @JsonKey()
  final bool eventStartingSoonEnabled;
  @override
  @JsonKey()
  final bool eventUpdatedEnabled;
  @override
  @JsonKey()
  final bool eventCancelledEnabled;
// Chat notifications
  @override
  @JsonKey()
  final bool chatMessageEnabled;
  @override
  @JsonKey()
  final bool chatMentionEnabled;
// Workspace notifications
  @override
  @JsonKey()
  final bool workspaceInviteEnabled;
  @override
  @JsonKey()
  final bool workspaceRoleChangedEnabled;
// System notifications
  @override
  @JsonKey()
  final bool systemEnabled;
// Quiet hours
  @override
  @JsonKey()
  final bool quietHoursEnabled;
  @override
  @JsonKey()
  final int quietHoursStart;
// 10 PM
  @override
  @JsonKey()
  final int quietHoursEnd;

  @override
  String toString() {
    return 'NotificationSettings(pushEnabled: $pushEnabled, soundEnabled: $soundEnabled, vibrationEnabled: $vibrationEnabled, taskAssignedEnabled: $taskAssignedEnabled, taskCompletedEnabled: $taskCompletedEnabled, taskOverdueEnabled: $taskOverdueEnabled, taskDueSoonEnabled: $taskDueSoonEnabled, taskCommentedEnabled: $taskCommentedEnabled, taskStatusChangedEnabled: $taskStatusChangedEnabled, projectInviteEnabled: $projectInviteEnabled, projectUpdatedEnabled: $projectUpdatedEnabled, projectDeadlineEnabled: $projectDeadlineEnabled, eventReminderEnabled: $eventReminderEnabled, eventStartingSoonEnabled: $eventStartingSoonEnabled, eventUpdatedEnabled: $eventUpdatedEnabled, eventCancelledEnabled: $eventCancelledEnabled, chatMessageEnabled: $chatMessageEnabled, chatMentionEnabled: $chatMentionEnabled, workspaceInviteEnabled: $workspaceInviteEnabled, workspaceRoleChangedEnabled: $workspaceRoleChangedEnabled, systemEnabled: $systemEnabled, quietHoursEnabled: $quietHoursEnabled, quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingsImpl &&
            (identical(other.pushEnabled, pushEnabled) ||
                other.pushEnabled == pushEnabled) &&
            (identical(other.soundEnabled, soundEnabled) ||
                other.soundEnabled == soundEnabled) &&
            (identical(other.vibrationEnabled, vibrationEnabled) ||
                other.vibrationEnabled == vibrationEnabled) &&
            (identical(other.taskAssignedEnabled, taskAssignedEnabled) ||
                other.taskAssignedEnabled == taskAssignedEnabled) &&
            (identical(other.taskCompletedEnabled, taskCompletedEnabled) ||
                other.taskCompletedEnabled == taskCompletedEnabled) &&
            (identical(other.taskOverdueEnabled, taskOverdueEnabled) ||
                other.taskOverdueEnabled == taskOverdueEnabled) &&
            (identical(other.taskDueSoonEnabled, taskDueSoonEnabled) ||
                other.taskDueSoonEnabled == taskDueSoonEnabled) &&
            (identical(other.taskCommentedEnabled, taskCommentedEnabled) ||
                other.taskCommentedEnabled == taskCommentedEnabled) &&
            (identical(
                    other.taskStatusChangedEnabled, taskStatusChangedEnabled) ||
                other.taskStatusChangedEnabled == taskStatusChangedEnabled) &&
            (identical(other.projectInviteEnabled, projectInviteEnabled) ||
                other.projectInviteEnabled == projectInviteEnabled) &&
            (identical(other.projectUpdatedEnabled, projectUpdatedEnabled) ||
                other.projectUpdatedEnabled == projectUpdatedEnabled) &&
            (identical(other.projectDeadlineEnabled, projectDeadlineEnabled) ||
                other.projectDeadlineEnabled == projectDeadlineEnabled) &&
            (identical(other.eventReminderEnabled, eventReminderEnabled) ||
                other.eventReminderEnabled == eventReminderEnabled) &&
            (identical(
                    other.eventStartingSoonEnabled, eventStartingSoonEnabled) ||
                other.eventStartingSoonEnabled == eventStartingSoonEnabled) &&
            (identical(other.eventUpdatedEnabled, eventUpdatedEnabled) ||
                other.eventUpdatedEnabled == eventUpdatedEnabled) &&
            (identical(other.eventCancelledEnabled, eventCancelledEnabled) ||
                other.eventCancelledEnabled == eventCancelledEnabled) &&
            (identical(other.chatMessageEnabled, chatMessageEnabled) ||
                other.chatMessageEnabled == chatMessageEnabled) &&
            (identical(other.chatMentionEnabled, chatMentionEnabled) ||
                other.chatMentionEnabled == chatMentionEnabled) &&
            (identical(other.workspaceInviteEnabled, workspaceInviteEnabled) ||
                other.workspaceInviteEnabled == workspaceInviteEnabled) &&
            (identical(other.workspaceRoleChangedEnabled,
                    workspaceRoleChangedEnabled) ||
                other.workspaceRoleChangedEnabled ==
                    workspaceRoleChangedEnabled) &&
            (identical(other.systemEnabled, systemEnabled) ||
                other.systemEnabled == systemEnabled) &&
            (identical(other.quietHoursEnabled, quietHoursEnabled) ||
                other.quietHoursEnabled == quietHoursEnabled) &&
            (identical(other.quietHoursStart, quietHoursStart) ||
                other.quietHoursStart == quietHoursStart) &&
            (identical(other.quietHoursEnd, quietHoursEnd) ||
                other.quietHoursEnd == quietHoursEnd));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        pushEnabled,
        soundEnabled,
        vibrationEnabled,
        taskAssignedEnabled,
        taskCompletedEnabled,
        taskOverdueEnabled,
        taskDueSoonEnabled,
        taskCommentedEnabled,
        taskStatusChangedEnabled,
        projectInviteEnabled,
        projectUpdatedEnabled,
        projectDeadlineEnabled,
        eventReminderEnabled,
        eventStartingSoonEnabled,
        eventUpdatedEnabled,
        eventCancelledEnabled,
        chatMessageEnabled,
        chatMentionEnabled,
        workspaceInviteEnabled,
        workspaceRoleChangedEnabled,
        systemEnabled,
        quietHoursEnabled,
        quietHoursStart,
        quietHoursEnd
      ]);

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
      get copyWith =>
          __$$NotificationSettingsImplCopyWithImpl<_$NotificationSettingsImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationSettingsImplToJson(
      this,
    );
  }
}

abstract class _NotificationSettings implements NotificationSettings {
  const factory _NotificationSettings(
      {final bool pushEnabled,
      final bool soundEnabled,
      final bool vibrationEnabled,
      final bool taskAssignedEnabled,
      final bool taskCompletedEnabled,
      final bool taskOverdueEnabled,
      final bool taskDueSoonEnabled,
      final bool taskCommentedEnabled,
      final bool taskStatusChangedEnabled,
      final bool projectInviteEnabled,
      final bool projectUpdatedEnabled,
      final bool projectDeadlineEnabled,
      final bool eventReminderEnabled,
      final bool eventStartingSoonEnabled,
      final bool eventUpdatedEnabled,
      final bool eventCancelledEnabled,
      final bool chatMessageEnabled,
      final bool chatMentionEnabled,
      final bool workspaceInviteEnabled,
      final bool workspaceRoleChangedEnabled,
      final bool systemEnabled,
      final bool quietHoursEnabled,
      final int quietHoursStart,
      final int quietHoursEnd}) = _$NotificationSettingsImpl;

  factory _NotificationSettings.fromJson(Map<String, dynamic> json) =
      _$NotificationSettingsImpl.fromJson;

// Push notification settings
  @override
  bool get pushEnabled;
  @override
  bool get soundEnabled;
  @override
  bool get vibrationEnabled; // Task notifications
  @override
  bool get taskAssignedEnabled;
  @override
  bool get taskCompletedEnabled;
  @override
  bool get taskOverdueEnabled;
  @override
  bool get taskDueSoonEnabled;
  @override
  bool get taskCommentedEnabled;
  @override
  bool get taskStatusChangedEnabled; // Project notifications
  @override
  bool get projectInviteEnabled;
  @override
  bool get projectUpdatedEnabled;
  @override
  bool get projectDeadlineEnabled; // Event notifications
  @override
  bool get eventReminderEnabled;
  @override
  bool get eventStartingSoonEnabled;
  @override
  bool get eventUpdatedEnabled;
  @override
  bool get eventCancelledEnabled; // Chat notifications
  @override
  bool get chatMessageEnabled;
  @override
  bool get chatMentionEnabled; // Workspace notifications
  @override
  bool get workspaceInviteEnabled;
  @override
  bool get workspaceRoleChangedEnabled; // System notifications
  @override
  bool get systemEnabled; // Quiet hours
  @override
  bool get quietHoursEnabled;
  @override
  int get quietHoursStart; // 10 PM
  @override
  int get quietHoursEnd;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
