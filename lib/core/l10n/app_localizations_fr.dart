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
  String get notificationTitleTaskAssigned => 'Tâche Assignée';

  @override
  String get notificationTitleTaskCompleted => 'Tâche Terminée';

  @override
  String get notificationTitleTaskOverdue => 'Tâche En Retard';

  @override
  String get notificationTitleTaskDueSoon => 'Tâche Bientôt Due';

  @override
  String get notificationTitleTaskCommented => 'Nouveau Commentaire';

  @override
  String get notificationTitleTaskStatusChanged => 'Statut de Tâche Modifié';

  @override
  String get notificationTitleProjectInvite => 'Invitation au Projet';

  @override
  String get notificationTitleProjectUpdated => 'Projet Mis à Jour';

  @override
  String get notificationTitleProjectDeadline => 'Échéance du Projet';

  @override
  String get notificationTitleEventReminder => 'Rappel d\'Événement';

  @override
  String get notificationTitleEventStartingSoon => 'Événement Bientôt';

  @override
  String get notificationTitleEventUpdated => 'Événement Mis à Jour';

  @override
  String get notificationTitleEventCancelled => 'Événement Annulé';

  @override
  String get notificationTitleChatMessage => 'Nouveau Message';

  @override
  String get notificationTitleChatMention => 'Vous Avez Été Mentionné';

  @override
  String get notificationTitleWorkspaceInvite =>
      'Invitation à l\'Espace de Travail';

  @override
  String get notificationTitleWorkspaceRoleChanged => 'Rôle Modifié';

  @override
  String get notificationTitleSystem => 'Notification Système';

  @override
  String get notificationTitleDefault => 'Notification';

  @override
  String notificationBodyTaskAssigned(String actor, String task) {
    return '$actor vous a assigné à \"$task\"';
  }

  @override
  String get notificationBodyTaskAssignedGeneric =>
      'Une nouvelle tâche vous a été assignée';

  @override
  String notificationBodyTaskCompleted(String actor, String task) {
    return '$actor a terminé \"$task\"';
  }

  @override
  String get notificationBodyTaskCompletedGeneric => 'Une tâche a été terminée';

  @override
  String notificationBodyTaskOverdue(String task) {
    return '\"$task\" est en retard';
  }

  @override
  String get notificationBodyTaskOverdueGeneric =>
      'Vous avez des tâches en retard';

  @override
  String notificationBodyTaskDueSoon(String task, String time) {
    return '\"$task\" est due $time';
  }

  @override
  String get notificationBodyTaskDueSoonGeneric =>
      'Vous avez des tâches bientôt dues';

  @override
  String notificationBodyTaskCommented(String actor, String task) {
    return '$actor a commenté sur \"$task\"';
  }

  @override
  String get notificationBodyTaskCommentedGeneric =>
      'Nouveau commentaire sur une tâche';

  @override
  String notificationBodyTaskStatusChanged(String task, String status) {
    return 'Le statut de \"$task\" a changé en $status';
  }

  @override
  String get notificationBodyTaskStatusChangedGeneric =>
      'Le statut d\'une tâche a changé';

  @override
  String notificationBodyProjectInvite(String actor, String project) {
    return '$actor vous a invité à rejoindre \"$project\"';
  }

  @override
  String get notificationBodyProjectInviteGeneric =>
      'Vous avez été invité à un projet';

  @override
  String notificationBodyProjectUpdated(String project) {
    return '\"$project\" a été mis à jour';
  }

  @override
  String get notificationBodyProjectUpdatedGeneric =>
      'Un projet a été mis à jour';

  @override
  String notificationBodyProjectDeadline(String project, String time) {
    return 'L\'échéance de \"$project\" est $time';
  }

  @override
  String get notificationBodyProjectDeadlineGeneric =>
      'Échéance du projet approche';

  @override
  String notificationBodyEventReminder(String event, String time) {
    return 'Rappel: \"$event\" commence $time';
  }

  @override
  String get notificationBodyEventReminderGeneric =>
      'Vous avez un événement à venir';

  @override
  String notificationBodyEventStartingSoon(String event, String time) {
    return '\"$event\" commence $time';
  }

  @override
  String get notificationBodyEventStartingSoonGeneric =>
      'Un événement commence bientôt';

  @override
  String notificationBodyEventUpdated(String event) {
    return '\"$event\" a été mis à jour';
  }

  @override
  String get notificationBodyEventUpdatedGeneric =>
      'Un événement a été mis à jour';

  @override
  String notificationBodyEventCancelled(String event) {
    return '\"$event\" a été annulé';
  }

  @override
  String get notificationBodyEventCancelledGeneric =>
      'Un événement a été annulé';

  @override
  String notificationBodyChatMessage(String actor) {
    return '$actor vous a envoyé un message';
  }

  @override
  String get notificationBodyChatMessageGeneric =>
      'Vous avez un nouveau message';

  @override
  String notificationBodyChatMention(String actor) {
    return '$actor vous a mentionné dans un chat';
  }

  @override
  String get notificationBodyChatMentionGeneric =>
      'Vous avez été mentionné dans un chat';

  @override
  String notificationBodyWorkspaceInvite(String actor, String workspace) {
    return '$actor vous a invité à rejoindre \"$workspace\"';
  }

  @override
  String get notificationBodyWorkspaceInviteGeneric =>
      'Vous avez été invité à un espace de travail';

  @override
  String notificationBodyWorkspaceRoleChanged(String workspace, String role) {
    return 'Votre rôle dans \"$workspace\" a changé en $role';
  }

  @override
  String get notificationBodyWorkspaceRoleChangedGeneric =>
      'Votre rôle dans l\'espace de travail a changé';

  @override
  String get notificationBodySystemGeneric => 'Notification système';

  @override
  String get notificationBodyDefault => 'Vous avez une nouvelle notification';

  @override
  String timeRemainingDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'jours',
      one: 'jour',
    );
    return 'dans $days $_temp0';
  }

  @override
  String timeRemainingHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'heures',
      one: 'heure',
    );
    return 'dans $hours $_temp0';
  }

  @override
  String timeRemainingMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'minutes',
      one: 'minute',
    );
    return 'dans $minutes $_temp0';
  }

  @override
  String timeOverdueDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'jours',
      one: 'jour',
    );
    return '$days $_temp0 de retard';
  }

  @override
  String timeOverdueHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'heures',
      one: 'heure',
    );
    return '$hours $_temp0 de retard';
  }

  @override
  String timeOverdueMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'minutes',
      one: 'minute',
    );
    return '$minutes $_temp0 de retard';
  }

  @override
  String get errorNoNetwork =>
      'Pas de connexion réseau. Veuillez vérifier les paramètres réseau de votre appareil.';

  @override
  String get errorNoInternet =>
      'Pas de connexion internet. Veuillez vérifier votre Wi-Fi ou vos données mobiles.';

  @override
  String get errorServerUnreachable =>
      'Serveur inaccessible. Il démarre peut-être, veuillez patienter un moment.';

  @override
  String get errorTimeout => 'Délai d\'attente dépassé. Veuillez réessayer.';

  @override
  String get errorAuthRequired => 'Vous devez être connecté pour faire cela.';

  @override
  String get errorAuthExpired =>
      'Votre session a expiré. Veuillez vous reconnecter.';

  @override
  String get errorInvalidCredentials =>
      'Email ou mot de passe invalide. Veuillez réessayer.';

  @override
  String get errorEmailNotConfirmed =>
      'Veuillez confirmer votre adresse email avant de vous connecter.';

  @override
  String get errorUserAlreadyExists => 'Un compte avec cet email existe déjà.';

  @override
  String get errorEmailAlreadyInUse => 'Cet email est déjà utilisé.';

  @override
  String get errorWeakPassword =>
      'Le mot de passe doit contenir au moins 8 caractères.';

  @override
  String get errorAuthCancelled => 'Connexion annulée.';

  @override
  String get errorNotAMember =>
      'Vous n\'êtes pas membre de cet espace de travail.';

  @override
  String get errorForbidden => 'Vous n\'avez pas la permission de faire cela.';

  @override
  String get errorLastAdmin =>
      'Impossible de supprimer le dernier administrateur. Promouvez d\'abord un autre membre.';

  @override
  String get errorInvalidCode =>
      'Code d\'invitation invalide. Veuillez vérifier et réessayer.';

  @override
  String get errorCodeExpired => 'Ce code d\'invitation a expiré.';

  @override
  String get errorCodeRevoked => 'Ce code d\'invitation a été révoqué.';

  @override
  String get errorCodeUsedUp =>
      'Ce code d\'invitation a atteint son nombre maximum d\'utilisations.';

  @override
  String get errorAlreadyMember =>
      'Vous êtes déjà membre de cet espace de travail.';

  @override
  String get errorFileTooLarge =>
      'Le fichier est trop volumineux. La taille maximale est de 20 Mo.';

  @override
  String get errorFileTypeNotAllowed =>
      'Ce type de fichier n\'est pas autorisé.';

  @override
  String get errorNotFound => 'Élément introuvable.';

  @override
  String errorNotFoundWithResource(String resource) {
    return '$resource introuvable.';
  }

  @override
  String get errorTaskNotFound => 'Tâche introuvable.';

  @override
  String get errorWorkspaceNotFound => 'Espace de travail introuvable.';

  @override
  String get errorValidationFailed =>
      'Veuillez vérifier le formulaire et réessayer.';

  @override
  String get errorSyncConflict =>
      'Cet élément a été modifié ailleurs. Veuillez actualiser et réessayer.';

  @override
  String get errorWorkspaceNameTaken =>
      'Un espace de travail avec ce nom existe déjà.';

  @override
  String get errorChatNotAvailableInPersonal =>
      'Le chat n\'est pas disponible dans les espaces de travail personnels. Créez ou rejoignez un espace d\'équipe pour utiliser le chat.';

  @override
  String get chatNotAvailable => 'Chat Non Disponible';

  @override
  String get errorChannelNotFound => 'Canal introuvable.';

  @override
  String get errorMessageNotFound => 'Message introuvable.';

  @override
  String get errorUnknown => 'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get errorServerError =>
      'Erreur du serveur. Veuillez réessayer plus tard.';

  @override
  String get errorTitleNetwork => 'Erreur de Connexion';

  @override
  String get errorTitleServer => 'Erreur du Serveur';

  @override
  String get errorTitleTimeout => 'Délai Dépassé';

  @override
  String get errorTitleAuth => 'Erreur d\'Authentification';

  @override
  String get errorTitlePermission => 'Permission Refusée';

  @override
  String get errorTitleInviteCode => 'Code d\'Invitation Invalide';

  @override
  String get errorTitleFile => 'Erreur de Fichier';

  @override
  String get errorTitleNotFound => 'Introuvable';

  @override
  String get errorTitleValidation => 'Erreur de Validation';

  @override
  String get errorTitleSync => 'Erreur de Synchronisation';

  @override
  String get errorTitleChat => 'Erreur de Chat';

  @override
  String get errorDetails => 'Détails de l\'Erreur';

  @override
  String get technicalDetails => 'Détails Techniques';

  @override
  String get copyToClipboard => 'Copier dans le Presse-papiers';

  @override
  String get copiedToClipboard =>
      'Détails de l\'erreur copiés dans le presse-papiers';

  @override
  String get validationEmailRequired => 'L\'e-mail est requis';

  @override
  String get validationEmailInvalid =>
      'Veuillez entrer une adresse e-mail valide';

  @override
  String get validationPasswordRequired => 'Le mot de passe est requis';

  @override
  String validationPasswordMinLength(int minLength) {
    return 'Le mot de passe doit contenir au moins $minLength caractères';
  }

  @override
  String get validationPasswordMatch =>
      'Les mots de passe doivent correspondre';

  @override
  String get validationNameRequired => 'Le nom est requis';

  @override
  String get validationTermsRequired =>
      'Vous devez accepter les Conditions d\'Utilisation et la Politique de Confidentialité';

  @override
  String get authWelcomeBack => 'Bienvenue';

  @override
  String get authSignInToContinue =>
      'Connectez-vous pour continuer sur PlanPal';

  @override
  String get authCreateAccount => 'Créer un Compte';

  @override
  String get authSignUpToGetStarted =>
      'Inscrivez-vous pour commencer avec PlanPal';

  @override
  String get authFullName => 'Nom Complet';

  @override
  String get authEnterYourName => 'Entrez votre nom complet';

  @override
  String get authEnterYourEmail => 'Entrez votre e-mail';

  @override
  String get authEnterYourPassword => 'Entrez votre mot de passe';

  @override
  String get authConfirmYourPassword => 'Confirmez votre mot de passe';

  @override
  String authAgreeToTerms(String terms, String privacy) {
    return 'J\'accepte les $terms et la $privacy';
  }

  @override
  String get authTermsOfService => 'Conditions d\'Utilisation';

  @override
  String get authPrivacyPolicy => 'Politique de Confidentialité';

  @override
  String get authContinueWithGoogle => 'Continuer avec Google';

  @override
  String get authVerifyEmail => 'Vérifiez votre E-mail';

  @override
  String authVerifyEmailDesc(String email) {
    return 'Entrez le code à 6 chiffres envoyé à $email';
  }

  @override
  String get authResendCode => 'Renvoyer le Code';

  @override
  String authResendCodeIn(int seconds) {
    return 'Renvoyer le code dans ${seconds}s';
  }

  @override
  String get authVerifyButton => 'Vérifier';

  @override
  String get authResetPassword => 'Réinitialiser le Mot de Passe';

  @override
  String get authResetPasswordDesc =>
      'Entrez votre e-mail pour recevoir un code de réinitialisation';

  @override
  String get authSendResetCode => 'Envoyer le Code de Réinitialisation';

  @override
  String get authEnterResetCode => 'Entrer le Code de Réinitialisation';

  @override
  String get authEnterResetCodeDesc =>
      'Entrez le code à 6 chiffres envoyé à votre e-mail';

  @override
  String get authEnterNewPassword => 'Entrer un Nouveau Mot de Passe';

  @override
  String get authEnterNewPasswordDesc =>
      'Choisissez un nouveau mot de passe pour votre compte';

  @override
  String get authNewPassword => 'Nouveau Mot de Passe';

  @override
  String get authResetPasswordSuccess =>
      'Mot de passe réinitialisé avec succès';

  @override
  String get authSigningIn => 'Connexion en cours...';

  @override
  String get authSigningUp => 'Création du compte...';

  @override
  String get authVerifying => 'Vérification en cours...';

  @override
  String get authResetting => 'Réinitialisation du mot de passe...';

  @override
  String get authLoginSuccess => 'Connexion réussie';

  @override
  String get authSignupSuccess => 'Compte créé avec succès';

  @override
  String get authVerificationSuccess => 'E-mail vérifié avec succès';

  @override
  String get authPasswordResetSuccess =>
      'Mot de passe réinitialisé avec succès';

  @override
  String get authCodeSent => 'Code de vérification envoyé à votre e-mail';

  @override
  String get sessionExpired =>
      'Votre session a expiré. Veuillez vous reconnecter.';

  @override
  String get sessionExpiredTitle => 'Session Expirée';

  @override
  String get sessionRestoring => 'Restauration de votre session...';

  @override
  String get sessionCheckingAuth => 'Vérification de l\'authentification...';

  @override
  String get workspaceCreateTitle => 'Créer un Espace de Travail';

  @override
  String get workspaceCreateDescription =>
      'Créez un nouvel espace de travail pour votre équipe';

  @override
  String get workspaceCreateButton => 'Créer un Espace de Travail';

  @override
  String get workspaceName => 'Nom de l\'Espace de Travail';

  @override
  String get workspaceNameHint => 'par ex., Équipe Produit';

  @override
  String get workspaceDescription => 'Description';

  @override
  String get workspaceDescriptionHint => 'À quoi sert cet espace de travail?';

  @override
  String get workspaceCreateSuccess => 'Espace de travail créé avec succès';

  @override
  String get workspaceCreateError =>
      'Échec de la création de l\'espace de travail';

  @override
  String get workspaceJoinTitle => 'Rejoindre l\'espace de travail';

  @override
  String get workspaceJoinDescription =>
      'Entrez un code d\'invitation pour rejoindre un espace de travail existant';

  @override
  String get workspaceJoinButton => 'Rejoindre l\'espace de travail';

  @override
  String get workspaceInviteCode => 'Code d\'invitation';

  @override
  String get workspaceCodeHelper =>
      'Demandez un code d\'invitation à votre administrateur';

  @override
  String get workspaceCodeLength =>
      'Le code d\'invitation doit comporter 6 caractères';

  @override
  String get workspaceCodeFormat => 'Le code doit être alphanumérique';

  @override
  String get workspaceCodeInvalid => 'Code d\'invitation invalide';

  @override
  String get workspaceCodeExpired => 'Ce code d\'invitation a expiré';

  @override
  String get workspaceAlreadyMember =>
      'Vous êtes déjà membre de cet espace de travail';

  @override
  String get workspaceJoinSuccess =>
      'Vous avez rejoint l\'espace de travail avec succès';

  @override
  String get workspaceJoinError =>
      'Échec de la jonction à l\'espace de travail';

  @override
  String get workspaceCreateNew =>
      'Créer un nouvel espace de travail à la place';

  @override
  String get workspaceMembers => 'Membres';

  @override
  String get noMembersYet => 'Pas encore de membres';

  @override
  String get memberRoleChanged => 'Rôle du membre modifié avec succès';

  @override
  String get memberRoleChangeError =>
      'Échec de la modification du rôle du membre';

  @override
  String get memberRemoveConfirmTitle => 'Retirer le Membre';

  @override
  String memberRemoveConfirmMessage(String name) {
    return 'Êtes-vous sûr de vouloir retirer $name de cet espace de travail?';
  }

  @override
  String get memberRemoved => 'Membre retiré avec succès';

  @override
  String get memberRemoveError => 'Échec du retrait du membre';

  @override
  String get workspaceLeaveConfirmTitle => 'Quitter l\'Espace de Travail';

  @override
  String get workspaceLeaveConfirmMessage =>
      'Êtes-vous sûr de vouloir quitter cet espace de travail?';

  @override
  String get workspaceLeft => 'Vous avez quitté l\'espace de travail';

  @override
  String get workspaceLeaveError =>
      'Échec de la sortie de l\'espace de travail';

  @override
  String get workspaceLeave => 'Quitter l\'Espace de Travail';

  @override
  String get changeRole => 'Changer le Rôle';

  @override
  String get removeMember => 'Retirer le Membre';

  @override
  String get roleAdmin => 'Administrateur';

  @override
  String get roleAdminDescription =>
      'Peut gérer l\'espace de travail et les membres';

  @override
  String get roleMember => 'Membre';

  @override
  String get roleMemberDescription => 'Peut voir et créer du contenu';

  @override
  String get you => 'Vous';

  @override
  String get errorLoadingMembers => 'Échec du chargement des membres';

  @override
  String get inviteCodes => 'Codes d\'Invitation';

  @override
  String get noInviteCodesYet => 'Pas encore de codes d\'invitation';

  @override
  String get createInviteCode => 'Créer un Code d\'Invitation';

  @override
  String get inviteCodeCreated => 'Code d\'invitation créé avec succès';

  @override
  String get inviteCodeCreateError =>
      'Échec de la création du code d\'invitation';

  @override
  String get inviteCodeRevokeConfirmTitle => 'Révoquer le Code d\'Invitation';

  @override
  String get inviteCodeRevokeConfirmMessage =>
      'Êtes-vous sûr de vouloir révoquer ce code d\'invitation? Il ne fonctionnera plus.';

  @override
  String get inviteCodeRevoked => 'Code d\'invitation révoqué avec succès';

  @override
  String get inviteCodeRevokeError =>
      'Échec de la révocation du code d\'invitation';

  @override
  String get inviteCodeCopied =>
      'Code d\'invitation copié dans le presse-papiers';

  @override
  String get copyCode => 'Copier le Code';

  @override
  String get revokeCode => 'Révoquer le Code';

  @override
  String get statusActive => 'Actif';

  @override
  String get statusRevoked => 'Révoqué';

  @override
  String get statusExpired => 'Expiré';

  @override
  String get statusMaxedOut => 'Utilisations Maximales Atteintes';

  @override
  String get uses => 'Utilisations';

  @override
  String get expires => 'Expire';

  @override
  String get inviteCodeMaxUses => 'Utilisations Maximales';

  @override
  String get inviteCodeExpiry => 'Expire Dans';

  @override
  String get unlimited => 'Illimité';

  @override
  String get never => 'Jamais';

  @override
  String daysCount(int count) {
    return '$count jours';
  }

  @override
  String get errorLoadingInviteCodes =>
      'Échec du chargement des codes d\'invitation';

  @override
  String get workspaceSettings => 'Paramètres de l\'Espace de Travail';

  @override
  String get workspaceUpdated => 'Espace de travail mis à jour';

  @override
  String get workspaceUpdateError =>
      'Échec de la mise à jour de l\'espace de travail';

  @override
  String get workspaceNameTooShort =>
      'Le nom doit comporter au moins 3 caractères';

  @override
  String get workspaceNameTooLong =>
      'Le nom doit comporter moins de 50 caractères';

  @override
  String get workspaceType => 'Type';

  @override
  String get workspaceTypePersonal => 'Personnel';

  @override
  String get workspaceTypeTeam => 'Équipe';

  @override
  String get createdAt => 'Créé';

  @override
  String get adminOnlySettings =>
      'Seuls les administrateurs peuvent modifier les paramètres';

  @override
  String get dangerZone => 'Zone Dangereuse';

  @override
  String get deleteWorkspace => 'Supprimer l\'Espace de Travail';

  @override
  String get workspaceDeleteConfirmTitle => 'Supprimer l\'Espace de Travail?';

  @override
  String get workspaceDeleteConfirmMessage =>
      'Êtes-vous sûr de vouloir supprimer cet espace de travail? Cette action est irréversible.';

  @override
  String get workspaceDeleteWarning =>
      'Toutes les tâches, projets et données de cet espace de travail seront définitivement supprimés.';

  @override
  String get workspaceDeleted => 'Espace de travail supprimé';

  @override
  String get workspaceDeleteError =>
      'Échec de la suppression de l\'espace de travail';

  @override
  String get workspaceNotFound => 'Espace de travail introuvable';

  @override
  String get errorLoadingWorkspace =>
      'Échec du chargement de l\'espace de travail';

  @override
  String get syncStatus => 'État de Synchronisation';

  @override
  String get lastSync => 'Dernière synchronisation';

  @override
  String get pendingChanges => 'En attente';

  @override
  String get failedChanges => 'Échoué';

  @override
  String get failedItems => 'Éléments Échoués';

  @override
  String get retryAll => 'Tout Réessayer';

  @override
  String get discardAll => 'Tout Rejeter';

  @override
  String get discardChange => 'Rejeter le Changement?';

  @override
  String get discardAllChanges => 'Rejeter Tous les Changements?';

  @override
  String get discardAllWarning =>
      'Cela rejettera définitivement tous les changements échoués. Cela ne peut pas être annulé.';

  @override
  String get uploadFile => 'Téléverser le fichier';

  @override
  String get uploads => 'Téléversements';

  @override
  String get noUploads => 'Aucun téléversement';

  @override
  String get uploading => 'Téléversement en cours';

  @override
  String get uploadCompleted => 'Téléversement terminé';

  @override
  String get uploadFailed => 'Échec du téléversement';

  @override
  String get uploadCancelled => 'Téléversement annulé';

  @override
  String uploadStarted(int count) {
    return 'Téléversement démarré pour $count fichier(s)';
  }

  @override
  String get clearCompleted => 'Effacer les terminés';

  @override
  String get clearFailed => 'Effacer les échecs';

  @override
  String get waiting => 'En attente';

  @override
  String get recent => 'Récent';

  @override
  String get noRecentDocuments => 'Aucun document récent';

  @override
  String get noDocuments => 'Aucun document';

  @override
  String get uploadFileToGetStarted => 'Téléversez un fichier pour commencer';

  @override
  String get errorLoadingData => 'Erreur lors du chargement des données';

  @override
  String get createFolder => 'Créer un dossier';

  @override
  String get folderName => 'Nom du dossier';

  @override
  String get enterFolderName => 'Entrez le nom du dossier';

  @override
  String get folderNameRequired => 'Le nom du dossier est obligatoire';

  @override
  String get folderNameTooLong =>
      'Le nom du dossier est trop long (200 caractères max)';

  @override
  String get folderCreated => 'Dossier créé avec succès';

  @override
  String get selectFilesToUpload => 'Sélectionner les fichiers à téléverser';

  @override
  String get browseFiles => 'Parcourir les fichiers';

  @override
  String get dragAndDropFiles => 'Glissez et déposez des fichiers ici';

  @override
  String get dropFilesHere => 'Déposez les fichiers ici';

  @override
  String get orClickToBrowse => 'ou cliquez pour parcourir';

  @override
  String get rename => 'Renommer';

  @override
  String get move => 'Déplacer';

  @override
  String get download => 'Télécharger';

  @override
  String get downloadStarted => 'Téléchargement démarré';

  @override
  String get confirmDeleteDocument =>
      'Êtes-vous sûr de vouloir supprimer ce document ?';

  @override
  String get confirmDeleteFolder =>
      'Êtes-vous sûr de vouloir supprimer ce dossier ? Il doit être vide.';

  @override
  String get documentDeleted => 'Document supprimé avec succès';

  @override
  String get folderDeleted => 'Dossier supprimé avec succès';

  @override
  String get documentName => 'Nom du document';

  @override
  String get documentNameRequired => 'Le nom du document est obligatoire';

  @override
  String get folderRenamed => 'Dossier renommé avec succès';

  @override
  String get documentRenamed => 'Document renommé avec succès';

  @override
  String get moveToFolder => 'Déplacer vers le dossier';

  @override
  String get rootFolder => 'Dossier racine';

  @override
  String get noFoldersAvailable => 'Aucun dossier disponible';

  @override
  String get folderMoved => 'Dossier déplacé avec succès';

  @override
  String get documentMoved => 'Document déplacé avec succès';

  @override
  String get nameTooLong => 'Le nom est trop long (200 caractères max)';

  @override
  String get noWorkspaceSelected => 'Aucun espace de travail sélectionné';

  @override
  String get close => 'Fermer';

  @override
  String get documentSaved => 'Document enregistré';

  @override
  String savedAt(String time) {
    return 'Enregistré à $time';
  }

  @override
  String get openWithSystemApp => 'Ouvrir avec l\'application système';

  @override
  String get errorLoadingFile => 'Erreur lors du chargement du fichier';

  @override
  String get downloading => 'Téléchargement en cours...';

  @override
  String get errorLoadingImage => 'Erreur lors du chargement de l\'image';

  @override
  String get pdfDocument => 'Document PDF';

  @override
  String get fileDocument => 'Fichier';

  @override
  String get attachFile => 'Joindre un fichier';

  @override
  String get attachments => 'Pièces jointes';

  @override
  String get noAttachments => 'Aucune pièce jointe';

  @override
  String get attachmentAdded => 'Pièce jointe ajoutée';

  @override
  String get attachmentRemoved => 'Pièce jointe supprimée';

  @override
  String get offlineUploadsDisabled =>
      'Les téléversements sont désactivés hors ligne';

  @override
  String get notificationTaskAssigned => 'Tâche assignée';

  @override
  String get notificationTaskUpdated => 'Tâche mise à jour';

  @override
  String get notificationTaskComment => 'Nouveau commentaire';

  @override
  String get notificationDeadlineApproaching => 'Échéance proche';

  @override
  String get notificationTaskOverdue => 'Tâche en retard';

  @override
  String get notificationMention => 'Vous avez été mentionné';

  @override
  String get notificationChatMessage => 'Nouveau message';

  @override
  String get notificationEventReminder => 'Rappel d\'événement';

  @override
  String get notificationWorkspaceInvite => 'Invitation à l\'espace de travail';

  @override
  String get notificationTaskAssignedBody => 'Une tâche vous a été assignée';

  @override
  String get notificationTaskUpdatedBody => 'Une tâche a été mise à jour';

  @override
  String get notificationTaskCommentBody => 'Quelqu\'un a commenté une tâche';

  @override
  String get notificationDeadlineApproachingBody =>
      'La date limite d\'une tâche approche';

  @override
  String get notificationTaskOverdueBody => 'Une tâche est en retard';

  @override
  String get notificationMentionBody => 'Quelqu\'un vous a mentionné';

  @override
  String get notificationChatMessageBody => 'Vous avez un nouveau message';

  @override
  String get notificationEventReminderBody => 'Vous avez un événement à venir';

  @override
  String get fieldRequired => 'Ce champ est obligatoire';

  @override
  String get workspaceInviteCodeHint => 'ex. ABC123';

  @override
  String get or => 'ou';

  @override
  String get workspaceNameTaken => 'Nom de l\'espace de travail déjà pris';
}
