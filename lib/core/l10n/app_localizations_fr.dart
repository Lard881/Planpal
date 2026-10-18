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
  String get searchOfflineNotice =>
      'Hors ligne : résultats affichés depuis cet appareil.';

  @override
  String get searchCtrlK => 'Ctrl K';

  @override
  String get searchChats => 'Rechercher des chats...';

  @override
  String get searchFiles => 'Rechercher des fichiers...';

  @override
  String get searchTasks => 'Rechercher des tâches...';

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
  String get btnViewAll => 'Tout voir';

  @override
  String get btnViewAllTasks => 'Voir toutes les tâches';

  @override
  String get btnDetails => 'Détails';

  @override
  String get btnCopy => 'Copier';

  @override
  String get btnEdit => 'Modifier';

  @override
  String get btnCopied => 'Copié';

  @override
  String get btnAddTask => '+ Ajouter une tâche';

  @override
  String get btnCreateTask => 'Créer une tâche';

  @override
  String get btnUpload => 'Télécharger un fichier';

  @override
  String get btnNewDocument => '+ Nouveau document';

  @override
  String get btnScheduleEvent => '+ Planifier un événement';

  @override
  String get btnSaveEvent => 'Enregistrer l\'événement';

  @override
  String get btnSaveSettings => 'Enregistrer les paramètres';

  @override
  String get btnSignOut => 'Se déconnecter';

  @override
  String get btnDeleteAccount => 'Supprimer le compte';

  @override
  String get btnMarkAllRead => 'Tout marquer comme lu';

  @override
  String get btnMarkComplete => 'Marquer comme terminé';

  @override
  String get btnDeleteSelected => 'Supprimer la sélection';

  @override
  String get btnInviteWithCode => 'Inviter avec un code';

  @override
  String get btnNewCode => '+ Nouveau code';

  @override
  String get btnJoin => 'Rejoindre';

  @override
  String get btnCreateWorkspace => '+ Créer un espace';

  @override
  String get btnJoinWithCode => 'Rejoindre avec un code';

  @override
  String get btnUploadNew => 'Télécharger nouveau';

  @override
  String get btnRemove => 'Retirer';

  @override
  String get btnRevoke => 'Révoquer';

  @override
  String get btnAdd => 'Ajouter';

  @override
  String get btnOpen => 'Ouvrir';

  @override
  String get btnRename => 'Renommer';

  @override
  String get btnDiscard => 'Ignorer';

  @override
  String get btnSkipForNow => 'Ignorer pour l\'instant';

  @override
  String get btnContinueWith => 'Continuer ->';

  @override
  String get btnGetStarted => 'Commencer ->';

  @override
  String get btnCreateCode => 'Créer un code';

  @override
  String get emptyStateNoTasks => 'Aucune tâche';

  @override
  String get emptyStateNoTasksDesc =>
      'Créez votre première tâche pour commencer.';

  @override
  String get emptyStateNoTasksToday => 'Rien d\'urgent aujourd\'hui.';

  @override
  String get emptyStateNoEvents => 'Aucun événement cette semaine';

  @override
  String get emptyStateNoEventsDay => 'Aucun événement ce jour.';

  @override
  String get emptyStateNoMessages => 'Aucun message.';

  @override
  String get emptyStateNoDocuments => 'Aucun document';

  @override
  String get emptyStateNoNotifications => 'Vous êtes à jour';

  @override
  String get emptyStateNoResults => 'Aucun résultat';

  @override
  String emptyStateNoResultsFor(String query) {
    return 'Aucun résultat pour \"$query\"';
  }

  @override
  String get emptyStateNoInviteCodes => 'Aucun code d\'invitation';

  @override
  String get emptyStateNoInviteCodesDesc =>
      'Créez-en un pour inviter des coéquipiers.';

  @override
  String get emptyStateNoMembers => 'Aucun membre trouvé';

  @override
  String get emptyStateNoAnalytics => 'Aucune analytique';

  @override
  String get emptyStateNoAnalyticsDesc =>
      'Terminez des tâches pour voir vos statistiques.';

  @override
  String get emptyStateNoChannels => 'Aucun canal';

  @override
  String get emptyStateNoChannelsDesc => 'Créez un canal pour commencer.';

  @override
  String get emptyStateSelectChannel => 'Sélectionner un canal';

  @override
  String get emptyStateSelectChannelDesc =>
      'Choisissez un canal pour commencer à discuter.';

  @override
  String get emptyStateChatTeamOnly => 'Le chat est pour les équipes';

  @override
  String get emptyStateChatTeamOnlyDesc =>
      'Le chat n\'est disponible que dans les espaces d\'équipe.';

  @override
  String get emptyStateTeamOnly => 'L\'équipe est pour les espaces d\'équipe';

  @override
  String get emptyStateTeamOnlyDesc =>
      'Créez ou rejoignez un espace d\'équipe pour voir les membres.';

  @override
  String get emptyStateTaskNotFound => 'Tâche introuvable';

  @override
  String get emptyStateDocNotFound => 'Document introuvable';

  @override
  String get emptyStateNothingUpcoming => 'Rien de prévu.';

  @override
  String get errorGeneric => 'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get errorNetwork =>
      'Pas de connexion internet. Vérifiez votre réseau.';

  @override
  String get errorServer =>
      'Erreur serveur. Veuillez réessayer dans un moment.';

  @override
  String get errorPermission => 'Vous n\'avez pas la permission de faire ça.';

  @override
  String get errorNotFound => 'Cet élément n\'existe plus.';

  @override
  String get errorSessionExpired =>
      'Votre session a expiré. Veuillez vous reconnecter.';

  @override
  String get errorAuthRequired => 'Connectez-vous pour continuer.';

  @override
  String get errorInvalidRequest => 'Vérifiez les informations et réessayez.';

  @override
  String get errorConflict =>
      'Cette modification entre en conflit avec une mise à jour plus récente. Actualisez puis réessayez.';

  @override
  String get errorRateLimited =>
      'Trop de requêtes. Veuillez patienter puis réessayer.';

  @override
  String get errorTimeout =>
      'La requête a expiré. Vérifiez votre connexion puis réessayez.';

  @override
  String get errorInvalidInviteCode => 'Ce code d’invitation est invalide.';

  @override
  String get errorInviteCodeExpired => 'Ce code d’invitation a expiré.';

  @override
  String get errorInviteCodeRevoked => 'Ce code d’invitation a été révoqué.';

  @override
  String get errorInviteCodeExhausted =>
      'Ce code d’invitation a atteint sa limite d’utilisation.';

  @override
  String get errorAlreadyMember =>
      'Vous êtes déjà membre de cet espace de travail.';

  @override
  String get errorTransferAdminFirst =>
      'Transférez la propriété de l’espace de travail avant de supprimer votre compte.';

  @override
  String get errorChatPersonalOnly =>
      'Le chat est disponible uniquement dans les espaces d’équipe.';

  @override
  String get bannerOffline =>
      'Vous êtes hors ligne. Vos modifications sont enregistrées et seront synchronisées à la reconnexion.';

  @override
  String get bannerServerUnreachable =>
      'Impossible d\'atteindre le serveur. Vérifiez votre connexion.';

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
  String get syncSaved => 'Enregistré';

  @override
  String get syncSaving => 'Enregistrement...';

  @override
  String get syncWaitingShort => 'En attente de synchronisation';

  @override
  String get priorityHigh => 'Haute';

  @override
  String get priorityMedium => 'Moyenne';

  @override
  String get priorityLow => 'Basse';

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
  String get workspaceNameLabel => 'Nom de l\'espace';

  @override
  String get workspaceNameHint => 'Mon équipe';

  @override
  String get workspaceSwitchTitle => 'Changer d\'espace';

  @override
  String get workspaceCreateTitle => 'Créer un espace';

  @override
  String get workspaceCreateSubtitle => 'Donnez un nom à votre nouvel espace.';

  @override
  String get workspaceCreateTip =>
      'Astuce : vous pouvez inviter des coéquipiers juste après la création.';

  @override
  String get workspaceJoinTitle => 'Rejoindre avec un code';

  @override
  String get workspaceJoinSubtitle =>
      'Demandez le code d\'invitation à 8 caractères à votre coéquipier.';

  @override
  String workspaceJoinedSuccess(String name) {
    return 'Vous avez rejoint $name !';
  }

  @override
  String get workspaceSettings => 'Paramètres de l\'espace';

  @override
  String workspaceSettingsSubtitle(String name) {
    return '$name · Gérer les personnes et l\'accès';
  }

  @override
  String get workspaceTeamOnlySettings =>
      'Les paramètres des personnes et des accès sont disponibles uniquement dans les espaces d\'équipe.';

  @override
  String get authGoogleBrowserComplete =>
      'Connexion terminée. Vous pouvez fermer cette fenêtre et revenir à PlanPal.';

  @override
  String get authGoogleBrowserFailure =>
      'La connexion Google n\'a pas pu aboutir. Revenez à PlanPal et réessayez.';

  @override
  String get tabMembers => 'Membres';

  @override
  String get tabInviteCodes => 'Codes d\'invitation';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get overdue => 'En retard';

  @override
  String get all => 'Tout';

  @override
  String get yesterday => 'Hier';

  @override
  String get tomorrow => 'Demain';

  @override
  String get pageLoading => 'Chargement...';

  @override
  String errorCode(String code) {
    return 'Code d\'erreur : $code';
  }

  @override
  String requestId(String id) {
    return 'ID de requête : $id';
  }

  @override
  String get confirmDeleteTitle => 'Supprimer cet élément ?';

  @override
  String get confirmDeleteBody => 'Cette action est irréversible.';

  @override
  String get confirmDeleteTaskTitle => 'Supprimer cette tâche ?';

  @override
  String get confirmDeleteTasksTitle => 'Supprimer les tâches sélectionnées ?';

  @override
  String get confirmRemoveMemberTitle => 'Retirer le membre ?';

  @override
  String confirmRemoveMemberBody(String name) {
    return 'Retirer $name de cet espace ?';
  }

  @override
  String get confirmDiscardTitle => 'Ignorer la modification ?';

  @override
  String get confirmDiscardBody =>
      'Cette modification sera définitivement supprimée.';

  @override
  String get logIn => 'Se connecter';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get signUp => 'Créer un compte';

  @override
  String get forgotPassword => 'Mot de passe oublié';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get createOrJoinTeam => 'Créer ou rejoindre une équipe';

  @override
  String get loginTitle => 'Bon retour';

  @override
  String get authInvalidCredentials =>
      'E-mail ou mot de passe incorrect. Veuillez réessayer.';

  @override
  String get authEmailNotConfirmed =>
      'Veuillez vérifier votre e-mail avant de vous connecter.';

  @override
  String get authAccountAlreadyExists =>
      'Un compte avec cet e-mail existe déjà.';

  @override
  String get authWeakPassword =>
      'Ce mot de passe n\'est pas assez sécurisé. Veuillez en choisir un plus robuste.';

  @override
  String get authTooManyAttempts =>
      'Trop de tentatives. Veuillez patienter un instant puis réessayer.';

  @override
  String get authInvalidCode => 'Code invalide ou expiré. Veuillez réessayer.';

  @override
  String get loginSubtitleMobile => 'Connectez-vous pour continuer la journée.';

  @override
  String get loginSubtitleDesktop =>
      'Connectez-vous pour reprendre où vous en étiez.';

  @override
  String get loginForgotPassword => 'Mot de passe oublié ?';

  @override
  String get loginNewHere => 'Nouveau ici ?';

  @override
  String get loginCreateAccount => 'Créer un compte';

  @override
  String get loginCalm => 'Journées calmes, tâches faites.';

  @override
  String get loginCalmDesc =>
      'PlanPal réunit tâches, calendrier et chat en un endroit convivial.';

  @override
  String get signupTitle => 'Créez votre compte';

  @override
  String get signupTeamworkTitle => 'Travail d\'équipe, sans le chaos.';

  @override
  String get signupTeamworkDesc =>
      'Tâches, calendrier, chat, docs et insights — conçus pour être sereins.';

  @override
  String get signupHaveAccount => 'Vous avez un compte ?';

  @override
  String get signupTermsPrefix => 'J\'accepte les';

  @override
  String get signupTerms => 'Conditions';

  @override
  String get signupTermsAnd => 'et la';

  @override
  String get signupPrivacy => 'Politique de confidentialité';

  @override
  String get fieldFullName => 'Nom complet';

  @override
  String get fieldFullNameHint => 'Prénom Nom';

  @override
  String get fieldEmail => 'E-mail';

  @override
  String get fieldEmailHint => 'name@example.com';

  @override
  String get fieldPassword => 'Mot de passe';

  @override
  String get fieldPasswordHint => '••••••••••';

  @override
  String get fieldConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get fieldNewPassword => 'Nouveau mot de passe';

  @override
  String get fieldConfirmNewPassword => 'Confirmer le nouveau mot de passe';

  @override
  String get fieldTaskName => 'Nom de la tâche';

  @override
  String get fieldTaskNameHint => 'Planifier la réunion d\'équipe';

  @override
  String get fieldDescription => 'Description';

  @override
  String get fieldDescriptionHint => 'Lieu, date, ordre du jour...';

  @override
  String get fieldDueDate => 'Date limite';

  @override
  String get fieldDueDateOptional => 'Choisir une date limite';

  @override
  String get fieldTime => 'Heure';

  @override
  String get fieldTimeOptional => 'Facultatif';

  @override
  String get fieldTaskReminder => 'Rappel (minutes avant)';

  @override
  String get fieldTaskReminderHint =>
      'Saisissez un nombre de minutes ; vide utilise le délai par défaut de 24 heures.';

  @override
  String get taskReminderDefault => 'Par défaut (24 heures avant)';

  @override
  String taskReminderCustom(int minutes) {
    return '$minutes minutes avant';
  }

  @override
  String get taskNoDueDate => 'Aucune date limite';

  @override
  String get taskClearDueDate => 'Effacer la date limite';

  @override
  String get validationTaskReminderRequiresDueDate =>
      'Choisissez d\'abord une date limite.';

  @override
  String get validationTaskReminderMinimum =>
      'Saisissez un nombre entier d\'au moins 5 minutes.';

  @override
  String get fieldPriority => 'Priorité';

  @override
  String get fieldStatus => 'Statut';

  @override
  String get fieldAssignee => 'Assigné à';

  @override
  String get fieldAssigneeOptional => 'Assigné à (optionnel)';

  @override
  String get fieldLabel => 'Étiquette';

  @override
  String get fieldLabelOptional => 'Étiquette (optionnel)';

  @override
  String get fieldTitle => 'Titre';

  @override
  String get fieldTitleHint => 'Revue de conception';

  @override
  String get fieldStarts => 'Début';

  @override
  String get fieldEnds => 'Fin';

  @override
  String get fieldAllDay => 'Toute la journée';

  @override
  String get fieldReminder => 'Rappel';

  @override
  String get fieldChannelName => 'Nom du canal';

  @override
  String get fieldDocTitle => 'Titre du document';

  @override
  String get fieldUntitled => 'Sans titre';

  @override
  String get fieldStartWriting => 'Commencez à écrire...';

  @override
  String get fieldAddDetailsHint => 'Ajouter des détails...';

  @override
  String get fieldWriteComment => 'Écrire un commentaire...';

  @override
  String get fieldMessageHint => 'Message...';

  @override
  String get fieldSubtaskHint => 'Titre de la sous-tâche';

  @override
  String fieldMessageChannelHint(String channel) {
    return 'Message #$channel...';
  }

  @override
  String get validationEmailRequired => 'L\'e-mail est obligatoire.';

  @override
  String get validationEmailInvalid => 'Entrez un e-mail valide.';

  @override
  String get validationPasswordRequired => 'Le mot de passe est obligatoire.';

  @override
  String get validationPasswordTooShort =>
      'Le mot de passe doit comporter au moins 8 caractères.';

  @override
  String get validationPasswordsNoMatch =>
      'Les mots de passe ne correspondent pas.';

  @override
  String get validationNameRequired => 'Le nom complet est obligatoire.';

  @override
  String get validationTermsRequired =>
      'Veuillez accepter les Conditions et la Politique de confidentialité.';

  @override
  String get validationTaskNameRequired =>
      'Le nom de la tâche est obligatoire.';

  @override
  String get validationWorkspaceNameRequired =>
      'Le nom de l\'espace est obligatoire.';

  @override
  String get forgotPasswordTitle => 'Réinitialiser le mot de passe';

  @override
  String get forgotPasswordSubtitle => 'Entrez l\'e-mail lié à votre compte.';

  @override
  String forgotPasswordStep(int current) {
    return 'Étape $current sur 3';
  }

  @override
  String get forgotPasswordSendCode => 'Envoyer le code';

  @override
  String get forgotPasswordBackToLogin => 'Retour à la connexion';

  @override
  String get forgotPasswordEnterCode => 'Entrer le code';

  @override
  String get forgotPasswordCodeSent =>
      'Code à 6 chiffres envoyé à votre e-mail.';

  @override
  String get forgotPasswordContinue => 'Continuer';

  @override
  String get forgotPasswordSetNew => 'Définir un nouveau mot de passe';

  @override
  String get forgotPasswordSaveNew => 'Enregistrer le nouveau mot de passe';

  @override
  String get verifyEmailTitle => 'Vérifiez votre boîte mail';

  @override
  String verifyEmailSentDesktop(String email) {
    return 'Nous avons envoyé un code à 6 chiffres à $email';
  }

  @override
  String verifyEmailSentMobile(String email) {
    return 'Code envoyé à $email';
  }

  @override
  String get verifyEmailVerify => 'Vérifier';

  @override
  String get verifyEmailResend => 'Pas reçu ? Renvoyer le code';

  @override
  String verifyEmailResendCooldown(int seconds) {
    return 'Pas reçu ? Renvoyer dans ${seconds}s';
  }

  @override
  String get onboardingTitle => 'Par où voulez-vous commencer ?';

  @override
  String get onboardingSubtitle =>
      'Vous pouvez toujours changer ou en créer d\'autres.';

  @override
  String get onboardingPersonalTitle => 'Mon espace personnel';

  @override
  String get onboardingPersonalSubtitle => 'Tâches et notes privées.';

  @override
  String get onboardingPersonalTitleDesktop =>
      'Continuer avec mon espace personnel';

  @override
  String get onboardingPersonalSubtitleDesktop =>
      'Un espace privé et calme pour vos propres tâches et notes.';

  @override
  String get onboardingTeamTitle => 'Créer ou rejoindre une équipe';

  @override
  String get onboardingTeamSubtitle => 'Partagez le travail avec d\'autres.';

  @override
  String get onboardingTeamSubtitleDesktop =>
      'Invitez des coéquipiers, partagez des tâches et discutez ensemble.';

  @override
  String get tasksTitle => 'Tâches';

  @override
  String get tasksBackToTasks => 'Retour aux tâches';

  @override
  String tasksDueToday(int count, int dueToday) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tâches · $dueToday à rendre aujourd\'hui',
      one: '1 tâche · 1 à rendre aujourd\'hui',
    );
    return '$_temp0';
  }

  @override
  String tasksSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tâches sélectionnées',
      one: '1 tâche sélectionnée',
    );
    return '$_temp0';
  }

  @override
  String get tasksNoResultsFilters => 'Aucun résultat pour ces filtres';

  @override
  String get tasksBulkPartialFailure =>
      'Certaines tâches sélectionnées n\'ont pas pu être traitées.';

  @override
  String get tasksBulkActionFailed =>
      'Les tâches sélectionnées n\'ont pas pu être traitées.';

  @override
  String get tasksClearFilters => 'Effacer les filtres';

  @override
  String get tasksSwipeHint =>
      'Balayez une tâche vers la gauche ou la droite pour la modifier ou la supprimer.';

  @override
  String get tasksDismissSwipeHint => 'Masquer le conseil de balayage';

  @override
  String get tasksFilterTitle => 'Filtrer les tâches';

  @override
  String get tasksFilterStatus => 'Statut';

  @override
  String get tasksFilterPriority => 'Priorité';

  @override
  String get tasksFilterSort => 'Tri';

  @override
  String get tasksFilterAll => 'Tout';

  @override
  String get tasksLoadMore => 'Charger plus';

  @override
  String get tasksSortBy => 'Trier par';

  @override
  String get tasksSortDueDate => 'Date d\'échéance';

  @override
  String get tasksSortCreated => 'Date de création';

  @override
  String get tasksSortTitle => 'Titre';

  @override
  String get btnApply => 'Appliquer';

  @override
  String get tasksAddSubtask => '+ Ajouter une sous-tâche';

  @override
  String get tasksAddSubtaskHint => '+ Ajouter une sous-tâche...';

  @override
  String tasksSubtasksLabel(int done, int total) {
    return 'Sous-tâches $done/$total';
  }

  @override
  String get tasksSubtasksTitle => 'Sous-tâches';

  @override
  String get tasksDetailTitle => 'Détails de la tâche';

  @override
  String get tasksSwipeEdit => 'Modifier';

  @override
  String get confirmDeleteSubtaskTitle => 'Supprimer cette sous-tâche ?';

  @override
  String get taskMoveToWorkspace => 'Déplacer vers un autre espace de travail';

  @override
  String taskMoveConfirmation(Object workspace) {
    return 'Déplacer cette tâche vers $workspace ?';
  }

  @override
  String get btnMove => 'Déplacer';

  @override
  String get tasksNewTitle => 'Nouvelle tâche';

  @override
  String get tasksDescriptionLabel => 'Description';

  @override
  String get tasksNoDescription => 'Aucune description.';

  @override
  String get tasksComments => 'Commentaires';

  @override
  String get tasksCommentJustNow => 'À l’instant';

  @override
  String tasksCommentMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count minutes',
      one: 'il y a 1 minute',
    );
    return '$_temp0';
  }

  @override
  String tasksCommentHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count heures',
      one: 'il y a 1 heure',
    );
    return '$_temp0';
  }

  @override
  String tasksCommentDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count jours',
      one: 'il y a 1 jour',
    );
    return '$_temp0';
  }

  @override
  String get tasksAttachments => 'Pièces jointes';

  @override
  String get taskNoAttachments => 'Aucune pièce jointe pour le moment.';

  @override
  String get taskAttachmentOffline =>
      'Une connexion internet est nécessaire pour envoyer ou ouvrir les pièces jointes.';

  @override
  String get taskAttachmentOpenFailed =>
      'Impossible d\'ouvrir cette pièce jointe. Veuillez réessayer.';

  @override
  String get taskAttachFile => 'Joindre un fichier';

  @override
  String get taskAttachmentUploadFailed =>
      'Impossible d\'envoyer ou de joindre ce fichier. Veuillez réessayer.';

  @override
  String get tasksAssigneeLabel => 'Assigné et étiquette';

  @override
  String get tasksUnassigned => 'Non assigné';

  @override
  String tasksDoneDate(String date) {
    return 'Fait le $date';
  }

  @override
  String get calendarTitle => 'Calendrier';

  @override
  String get calendarToday => 'Aujourd\'hui';

  @override
  String get calendarTodaySchedule => 'Programme d\'aujourd\'hui';

  @override
  String calendarScheduleFor(String date) {
    return 'Programme · $date';
  }

  @override
  String get calendarWeek => 'Semaine';

  @override
  String get calendarMonth => 'Mois';

  @override
  String get calendarDay => 'Jour';

  @override
  String calendarEventsFor(String date) {
    return 'Événements : $date';
  }

  @override
  String calendarMoreEvents(int count) {
    return '+$count de plus';
  }

  @override
  String get calendarTeam => 'Équipe';

  @override
  String get calendarDueTasks => 'Tâches à échéance';

  @override
  String get calendarQueuedOffline =>
      'L’événement est enregistré sur cet appareil et sera synchronisé dès que vous serez de nouveau en ligne.';

  @override
  String get calendarAttendees => 'Participants';

  @override
  String get calendarNoMembers =>
      'Aucun membre disponible dans cet espace de travail.';

  @override
  String get calendarInvalidRange =>
      'L’heure de fin doit être postérieure à l’heure de début.';

  @override
  String get scheduleEventTitle => 'Planifier un événement';

  @override
  String get reminderNone => 'Aucun rappel';

  @override
  String get reminderFiveMin => '5 minutes avant';

  @override
  String get reminderFifteenMin => '15 minutes avant';

  @override
  String get reminderThirtyMin => '30 minutes avant';

  @override
  String get reminderOneHour => '1 heure avant';

  @override
  String get documentsTitle => 'Documents';

  @override
  String get documentSaving => 'Enregistrement...';

  @override
  String get documentSaved => 'Enregistré';

  @override
  String get documentSavedLocally => 'Enregistré sur cet appareil';

  @override
  String get documentWaitingToSync => 'En attente de synchronisation';

  @override
  String get documentsRecent => 'Récents';

  @override
  String get documentsRecentTitle => 'Documents récents';

  @override
  String get documentEditorSave => 'Enregistrer';

  @override
  String get documentEditorStartWriting => 'Commencez à écrire...';

  @override
  String get documentNewFolderTitle => 'Nouveau dossier';

  @override
  String get documentNewTitle => 'Nouveau document';

  @override
  String get documentUploadFile => 'Télécharger un fichier';

  @override
  String get documentDropHint => 'Déposez les fichiers ici pour les importer';

  @override
  String get documentDropFilesOnly =>
      'Déposez des fichiers ici, pas des dossiers.';

  @override
  String get documentNewFolder => 'Nouveau dossier';

  @override
  String get chatTitle => 'Messages';

  @override
  String get chatNewChannel => 'Nouveau canal';

  @override
  String get chatChannels => 'Canaux';

  @override
  String get chatDirectMessages => 'Messages directs';

  @override
  String get chatNewDm => 'Nouveau message direct';

  @override
  String get chatPrivateChannel => 'Canal privé';

  @override
  String get chatManageMembers => 'Gérer les membres du canal';

  @override
  String get chatUnnamedChannel => 'Canal sans nom';

  @override
  String get chatDirectMessageFallback => 'Message direct';

  @override
  String get chatYou => 'Vous';

  @override
  String get chatUnknownSender => 'Expéditeur inconnu';

  @override
  String chatMessageHeader(String sender, String time) {
    return '$sender · $time';
  }

  @override
  String chatTyping(String names) {
    return '$names écrit...';
  }

  @override
  String get chatTapToRetry => 'Touchez pour réessayer';

  @override
  String get chatConfirmDeleteMessage => 'Supprimer ce message ?';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsAll => 'Toutes';

  @override
  String get notificationsUnread => 'Non lues';

  @override
  String get notificationsTasks => 'Tâches';

  @override
  String get notificationsMentions => 'Mentions';

  @override
  String get notificationsMarkRead => 'Marquer comme lu';

  @override
  String get notificationsMarkUnread => 'Marquer comme non lu';

  @override
  String get notificationTaskAssigned => 'Tâche attribuée';

  @override
  String get notificationTaskUpdated => 'Tâche mise à jour';

  @override
  String get notificationTaskComment => 'Nouveau commentaire sur la tâche';

  @override
  String get notificationMention => 'Vous avez été mentionné';

  @override
  String get notificationDeadline => 'Échéance proche';

  @override
  String get notificationOverdue => 'Tâche en retard';

  @override
  String get notificationEventReminder => 'Rappel d’événement';

  @override
  String get notificationChatMessage => 'Nouveau message de chat';

  @override
  String get notificationMemberJoined => 'Un membre a rejoint l’espace';

  @override
  String get notificationJustNow => 'À l’instant';

  @override
  String notificationMinutesAgo(int count) {
    return 'Il y a $count min';
  }

  @override
  String notificationHoursAgo(int count) {
    return 'Il y a $count h';
  }

  @override
  String notificationDaysAgo(int count) {
    return 'Il y a $count j';
  }

  @override
  String get analyticsTitle => 'Analytique';

  @override
  String get analyticsExportCSV => 'Exporter CSV';

  @override
  String get analyticsLastSevenDays => '7 derniers jours';

  @override
  String get analyticsLastThirtyDays => '30 derniers jours';

  @override
  String get analyticsLastNinetyDays => '90 derniers jours';

  @override
  String get analyticsTasksCompleted => 'Tâches terminées';

  @override
  String get analyticsAvgTime => 'Temps moyen d\'achèvement';

  @override
  String get analyticsVelocity => 'Vélocité de l\'équipe';

  @override
  String get analyticsStreak => 'Séquence productive';

  @override
  String get analyticsWeeklyOutput => 'Production hebdomadaire';

  @override
  String get analyticsCategoryMix => 'Répartition par catégorie';

  @override
  String get homeYourTasksToday => 'Vos tâches du jour';

  @override
  String get homeQuickActions => 'Actions rapides';

  @override
  String get homeOverview => 'Vue d\'ensemble';

  @override
  String get homeUpcoming => 'À venir';

  @override
  String get homeStats => 'Statistiques';

  @override
  String get homeDocs => 'Docs';

  @override
  String get homeSevenDays => '7 jours';

  @override
  String get homeThirtyDays => '30 jours';

  @override
  String get homeTasksCompleted => 'Tâches terminées';

  @override
  String get homeCompleted => 'Terminé';

  @override
  String get homeInProgress => 'En cours';

  @override
  String get homeOverdue => 'En retard';

  @override
  String get homeProductivity => 'Productivité';

  @override
  String get homeGreetingFallback => 'bonjour';

  @override
  String get homeWorkspaceFallback => 'Espace de travail';

  @override
  String get teamDirectoryTitle => 'Annuaire de l\'équipe';

  @override
  String get teamLatestUpdates => 'Dernières mises à jour';

  @override
  String get teamNoActivity => 'Aucune activité récente';

  @override
  String get teamUpdatedTask => 'Tâche mise à jour';

  @override
  String get teamUpdateTask => 'Tâche mise à jour';

  @override
  String get teamUpdateDocument => 'Document mis à jour';

  @override
  String get teamUpdateFile => 'Fichier mis à jour';

  @override
  String get teamUpdateMemberJoined => 'Un membre a rejoint l’équipe';

  @override
  String get teamMemberProfile => 'Profil du membre';

  @override
  String get teamMessageMember => 'Message';

  @override
  String get teamRemoveMember => 'Supprimer le membre';

  @override
  String get teamChangeRole => 'Modifier le rôle';

  @override
  String get teamConfirmRemoveMember =>
      'Retirer cette personne de l’espace de travail ?';

  @override
  String get teamPresenceOnline => 'Actif maintenant';

  @override
  String get teamPresenceAway => 'Absent';

  @override
  String get teamPresenceOffline => 'Hors ligne';

  @override
  String get settingsProfile => 'Profil';

  @override
  String get settingsAccount => 'Compte';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsTimezone => 'Fuseau horaire';

  @override
  String get settingsPushNotifications => 'Notifications push';

  @override
  String get settingsInAppNotifications => 'Notifications dans l’application';

  @override
  String get settingsNotifyAssignments => 'Attributions de tâches';

  @override
  String get settingsNotifyComments => 'Commentaires';

  @override
  String get settingsNotifyMentions => 'Mentions';

  @override
  String get settingsNotifyDeadlines => 'Échéances et rappels';

  @override
  String get settingsNotifyChat => 'Messages de chat';

  @override
  String get settingsChangePassword => 'Changer le mot de passe';

  @override
  String get settingsCurrentPassword => 'Mot de passe actuel';

  @override
  String get settingsPasswordChanged => 'Mot de passe modifié.';

  @override
  String get settingsSignOutEverywhere =>
      'Se déconnecter de tous les appareils';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsAppearanceSaved =>
      'Les paramètres d’apparence ont été enregistrés sur votre compte.';

  @override
  String get settingsAppearanceQueued =>
      'Enregistré sur cet appareil. La synchronisation aura lieu lorsque le serveur sera disponible.';

  @override
  String get settingsAppearanceSaveFailed =>
      'L’apparence a changé sur cet appareil, mais n’a pas pu être enregistrée sur votre compte.';

  @override
  String get settingsSecurity => 'Sécurité';

  @override
  String get settingsWorkspace => 'Espace de travail';

  @override
  String get settingsSyncStatus => 'État de synchronisation';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsAvatarUpdated => 'Avatar mis à jour !';

  @override
  String get settingsDeleteAccountTitle => 'Supprimer le compte';

  @override
  String get settingsDeleteAccountDesc =>
      'Cela supprime définitivement votre compte et toutes les données.';

  @override
  String settingsComingSoon(String section) {
    return 'Paramètres $section bientôt disponibles.';
  }

  @override
  String analyticsLastUpdated(String time) {
    return 'Dernière mise à jour : $time';
  }

  @override
  String get syncStatusTitle => 'État de synchronisation';

  @override
  String get syncConnection => 'Connexion';

  @override
  String get syncOnline => 'En ligne';

  @override
  String get syncOffline => 'Hors ligne';

  @override
  String get syncServerWaking => 'Démarrage du serveur...';

  @override
  String get syncServerUnreachable => 'Serveur inaccessible';

  @override
  String syncLastSynced(String time) {
    return 'Dernière synchronisation : $time';
  }

  @override
  String get syncPendingChanges => 'Modifications en attente';

  @override
  String get syncNoPending => 'Aucune modification en attente.';

  @override
  String get syncFailedChanges => 'Modifications échouées';

  @override
  String get syncNoFailed => 'Aucune modification échouée.';

  @override
  String get syncRetryAll => 'Tout réessayer';

  @override
  String get syncCouldNotSave =>
      'Impossible d\'enregistrer. Vous n\'avez peut-être plus accès.';

  @override
  String get syncJustNow => 'À l\'instant';

  @override
  String get avatarCropTitle => 'Recadrer votre photo';

  @override
  String get codeCopied => 'Code copié';

  @override
  String get goodMorning => 'Bonjour';

  @override
  String get goodAfternoon => 'Bon après-midi';

  @override
  String get goodEvening => 'Bonsoir';

  @override
  String get letsGetStarted => 'Rendons cette journée productive.';
}
