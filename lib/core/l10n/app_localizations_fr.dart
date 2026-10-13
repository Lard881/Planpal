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
  String get navHome => 'Accueil';

  @override
  String get navTasks => 'Tâches';

  @override
  String get navCalendar => 'Calendrier';

  @override
  String get navChat => 'Chat';

  @override
  String get navDocuments => 'Documents';

  @override
  String get navAnalytics => 'Analytique';

  @override
  String get navTeam => 'Équipe';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get navProfile => 'Profil';

  @override
  String get searchPlaceholder => 'Rechercher tâches, docs, personnes...';

  @override
  String get searchCtrlK => 'Ctrl K';

  @override
  String get btnSave => 'Enregistrer';

  @override
  String get btnCancel => 'Annuler';

  @override
  String get btnDelete => 'Supprimer';

  @override
  String get btnCreate => 'Créer';

  @override
  String get btnConfirm => 'Confirmer';

  @override
  String get btnRetry => 'Réessayer';

  @override
  String get btnViewAll => 'Voir tout';

  @override
  String get btnDetails => 'Détails';

  @override
  String get btnCopy => 'Copier';

  @override
  String get btnCopied => 'Copié';

  @override
  String get btnAddTask => '+ Ajouter une tâche';

  @override
  String get btnCreateTask => 'Créer une tâche';

  @override
  String get btnUpload => 'Téléverser un fichier';

  @override
  String get emptyStateNoTasks => 'Aucune tâche';

  @override
  String get emptyStateNoTasksDesc =>
      'Créez votre première tâche pour commencer.';

  @override
  String get emptyStateNoEvents => 'Aucun événement cette semaine';

  @override
  String get emptyStateNoMessages => 'Aucun message pour l\'instant';

  @override
  String get emptyStateNoDocuments => 'Aucun document pour l\'instant';

  @override
  String get emptyStateNoNotifications => 'Vous êtes à jour';

  @override
  String get emptyStateNoResults => 'Aucun résultat';

  @override
  String get errorGeneric =>
      'Quelque chose s\'est mal passé. Veuillez réessayer.';

  @override
  String get errorNetwork =>
      'Pas de connexion internet. Vérifiez votre réseau.';

  @override
  String get errorServer =>
      'Erreur serveur. Veuillez réessayer dans un moment.';

  @override
  String get errorPermission => 'Vous n\'avez pas la permission de faire cela.';

  @override
  String get errorNotFound => 'Cet élément n\'existe plus.';

  @override
  String get errorSessionExpired =>
      'Votre session a expiré. Veuillez vous reconnecter.';

  @override
  String get bannerOffline =>
      'Vous êtes hors ligne. Vos modifications sont sauvegardées et se synchroniseront dès votre retour.';

  @override
  String get bannerServerUnreachable => 'Impossible d\'atteindre le serveur.';

  @override
  String get bannerWakingUp =>
      'Démarrage du serveur, cela peut prendre jusqu\'à une minute.';

  @override
  String get bannerBackOnline => 'De retour en ligne. Synchronisation...';

  @override
  String syncWaiting(int count) {
    return 'En attente de synchronisation $count';
  }

  @override
  String get priorityHigh => 'Haute';

  @override
  String get priorityMedium => 'Moyenne';

  @override
  String get priorityLow => 'Faible';

  @override
  String get statusTodo => 'À faire';

  @override
  String get statusInProgress => 'En cours';

  @override
  String get statusCompleted => 'Terminé';

  @override
  String get statusOverdue => 'En retard';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleMember => 'Membre';

  @override
  String get roleGuest => 'Invité';

  @override
  String get workspacePersonal => 'Personnel';

  @override
  String get workspaceTeam => 'Équipe';

  @override
  String workspaceMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membres',
      one: '1 membre',
    );
    return '$_temp0';
  }

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get overdue => 'En retard';

  @override
  String get all => 'Tout';

  @override
  String get pageLoading => 'Chargement...';

  @override
  String errorCode(String code) {
    return 'Code d\'erreur: $code';
  }

  @override
  String requestId(String id) {
    return 'ID de requête: $id';
  }

  @override
  String get confirmDeleteTitle => 'Supprimer cet élément?';

  @override
  String get confirmDeleteBody => 'Cette action ne peut pas être annulée.';

  @override
  String get logIn => 'Se connecter';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get signUp => 'Créer un compte';

  @override
  String get forgotPassword => 'Mot de passe oublié';

  @override
  String get goodMorning => 'Bonjour';

  @override
  String get goodAfternoon => 'Bon après-midi';

  @override
  String get goodEvening => 'Bonsoir';

  @override
  String get letsGetStarted => 'Rendons cette journée productive.';
}
