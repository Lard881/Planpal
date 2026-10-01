// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'PlanPal';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get login => 'Se Connecter';

  @override
  String get signup => 'S\'inscrire';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de Passe';

  @override
  String get confirmPassword => 'Confirmer le Mot de Passe';

  @override
  String get forgotPassword => 'Mot de Passe Oublié?';

  @override
  String get createAccount => 'Créer un Compte';

  @override
  String get orContinueWith => 'ou continuer avec';

  @override
  String get google => 'Google';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte?';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte?';

  @override
  String get home => 'Accueil';

  @override
  String get tasks => 'Tâches';

  @override
  String get calendar => 'Calendrier';

  @override
  String get chat => 'Chat';

  @override
  String get documents => 'Documents';

  @override
  String get analytics => 'Analytiques';

  @override
  String get team => 'Équipe';

  @override
  String get settings => 'Paramètres';

  @override
  String get profile => 'Profil';

  @override
  String get notifications => 'Notifications';

  @override
  String get logout => 'Se Déconnecter';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get create => 'Créer';

  @override
  String get search => 'Rechercher';

  @override
  String get filter => 'Filtrer';

  @override
  String get sort => 'Trier';

  @override
  String get loading => 'Chargement...';

  @override
  String get retry => 'Réessayer';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get offline => 'Hors Ligne';

  @override
  String get online => 'En Ligne';

  @override
  String get syncing => 'Synchronisation...';

  @override
  String get noData => 'Aucune donnée disponible';

  @override
  String get noResults => 'Aucun résultat trouvé';

  @override
  String get notificationTitleTaskAssigned => 'Task Assigned';

  @override
  String get notificationTitleTaskCompleted => 'Task Completed';

  @override
  String get notificationTitleTaskOverdue => 'Task Overdue';

  @override
  String get notificationTitleTaskDueSoon => 'Task Due Soon';

  @override
  String get notificationTitleTaskCommented => 'New Comment';

  @override
  String get notificationTitleTaskStatusChanged => 'Task Status Changed';

  @override
  String get notificationTitleProjectInvite => 'Project Invitation';

  @override
  String get notificationTitleProjectUpdated => 'Project Updated';

  @override
  String get notificationTitleProjectDeadline => 'Project Deadline';

  @override
  String get notificationTitleEventReminder => 'Event Reminder';

  @override
  String get notificationTitleEventStartingSoon => 'Event Starting Soon';

  @override
  String get notificationTitleEventUpdated => 'Event Updated';

  @override
  String get notificationTitleEventCancelled => 'Event Cancelled';

  @override
  String get notificationTitleChatMessage => 'New Message';

  @override
  String get notificationTitleChatMention => 'You Were Mentioned';

  @override
  String get notificationTitleWorkspaceInvite => 'Workspace Invitation';

  @override
  String get notificationTitleWorkspaceRoleChanged => 'Role Changed';

  @override
  String get notificationTitleSystem => 'System Notification';

  @override
  String get notificationTitleDefault => 'Notification';

  @override
  String notificationBodyTaskAssigned(String actor, String task) {
    return '$actor assigned you to \"$task\"';
  }

  @override
  String get notificationBodyTaskAssignedGeneric =>
      'You have been assigned to a new task';

  @override
  String notificationBodyTaskCompleted(String actor, String task) {
    return '$actor completed \"$task\"';
  }

  @override
  String get notificationBodyTaskCompletedGeneric =>
      'A task has been completed';

  @override
  String notificationBodyTaskOverdue(String task) {
    return '\"$task\" is overdue';
  }

  @override
  String get notificationBodyTaskOverdueGeneric => 'You have overdue tasks';

  @override
  String notificationBodyTaskDueSoon(String task, String time) {
    return '\"$task\" is due $time';
  }

  @override
  String get notificationBodyTaskDueSoonGeneric => 'You have tasks due soon';

  @override
  String notificationBodyTaskCommented(String actor, String task) {
    return '$actor commented on \"$task\"';
  }

  @override
  String get notificationBodyTaskCommentedGeneric => 'New comment on a task';

  @override
  String notificationBodyTaskStatusChanged(String task, String status) {
    return '\"$task\" status changed to $status';
  }

  @override
  String get notificationBodyTaskStatusChangedGeneric =>
      'Task status has changed';

  @override
  String notificationBodyProjectInvite(String actor, String project) {
    return '$actor invited you to join \"$project\"';
  }

  @override
  String get notificationBodyProjectInviteGeneric =>
      'You have been invited to a project';

  @override
  String notificationBodyProjectUpdated(String project) {
    return '\"$project\" has been updated';
  }

  @override
  String get notificationBodyProjectUpdatedGeneric =>
      'A project has been updated';

  @override
  String notificationBodyProjectDeadline(String project, String time) {
    return '\"$project\" deadline is $time';
  }

  @override
  String get notificationBodyProjectDeadlineGeneric =>
      'Project deadline approaching';

  @override
  String notificationBodyEventReminder(String event, String time) {
    return 'Reminder: \"$event\" starts $time';
  }

  @override
  String get notificationBodyEventReminderGeneric =>
      'You have an upcoming event';

  @override
  String notificationBodyEventStartingSoon(String event, String time) {
    return '\"$event\" starts $time';
  }

  @override
  String get notificationBodyEventStartingSoonGeneric =>
      'An event is starting soon';

  @override
  String notificationBodyEventUpdated(String event) {
    return '\"$event\" has been updated';
  }

  @override
  String get notificationBodyEventUpdatedGeneric => 'An event has been updated';

  @override
  String notificationBodyEventCancelled(String event) {
    return '\"$event\" has been cancelled';
  }

  @override
  String get notificationBodyEventCancelledGeneric =>
      'An event has been cancelled';

  @override
  String notificationBodyChatMessage(String actor) {
    return '$actor sent you a message';
  }

  @override
  String get notificationBodyChatMessageGeneric => 'You have a new message';

  @override
  String notificationBodyChatMention(String actor) {
    return '$actor mentioned you in a chat';
  }

  @override
  String get notificationBodyChatMentionGeneric =>
      'You were mentioned in a chat';

  @override
  String notificationBodyWorkspaceInvite(String actor, String workspace) {
    return '$actor invited you to join \"$workspace\"';
  }

  @override
  String get notificationBodyWorkspaceInviteGeneric =>
      'You have been invited to a workspace';

  @override
  String notificationBodyWorkspaceRoleChanged(String workspace, String role) {
    return 'Your role in \"$workspace\" changed to $role';
  }

  @override
  String get notificationBodyWorkspaceRoleChangedGeneric =>
      'Your workspace role has changed';

  @override
  String get notificationBodySystemGeneric => 'System notification';

  @override
  String get notificationBodyDefault => 'You have a new notification';

  @override
  String timeRemainingDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return 'in $days $_temp0';
  }

  @override
  String timeRemainingHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'hours',
      one: 'hour',
    );
    return 'in $hours $_temp0';
  }

  @override
  String timeRemainingMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'minutes',
      one: 'minute',
    );
    return 'in $minutes $_temp0';
  }

  @override
  String timeOverdueDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$days $_temp0 overdue';
  }

  @override
  String timeOverdueHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'hours',
      one: 'hour',
    );
    return '$hours $_temp0 overdue';
  }

  @override
  String timeOverdueMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'minutes',
      one: 'minute',
    );
    return '$minutes $_temp0 overdue';
  }
}
