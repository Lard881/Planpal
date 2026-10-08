// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'PlanPal';

  @override
  String get welcome => 'Bienvenido';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get signup => 'Registrarse';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar Contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu Contraseña?';

  @override
  String get createAccount => 'Crear Cuenta';

  @override
  String get orContinueWith => 'o continuar con';

  @override
  String get google => 'Google';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get home => 'Inicio';

  @override
  String get tasks => 'Tareas';

  @override
  String get calendar => 'Calendario';

  @override
  String get chat => 'Chat';

  @override
  String get documents => 'Documentos';

  @override
  String get analytics => 'Analíticas';

  @override
  String get team => 'Equipo';

  @override
  String get settings => 'Configuración';

  @override
  String get profile => 'Perfil';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get create => 'Crear';

  @override
  String get search => 'Buscar';

  @override
  String get filter => 'Filtrar';

  @override
  String get sort => 'Ordenar';

  @override
  String get loading => 'Cargando...';

  @override
  String get retry => 'Reintentar';

  @override
  String get error => 'Error';

  @override
  String get success => 'Éxito';

  @override
  String get offline => 'Sin Conexión';

  @override
  String get online => 'En Línea';

  @override
  String get syncing => 'Sincronizando...';

  @override
  String get noData => 'No hay datos disponibles';

  @override
  String get noResults => 'No se encontraron resultados';

  @override
  String get notificationTitleTaskAssigned => 'Tarea Asignada';

  @override
  String get notificationTitleTaskCompleted => 'Tarea Completada';

  @override
  String get notificationTitleTaskOverdue => 'Tarea Atrasada';

  @override
  String get notificationTitleTaskDueSoon => 'Tarea Próxima a Vencer';

  @override
  String get notificationTitleTaskCommented => 'Nuevo Comentario';

  @override
  String get notificationTitleTaskStatusChanged => 'Estado de Tarea Cambiado';

  @override
  String get notificationTitleProjectInvite => 'Invitación a Proyecto';

  @override
  String get notificationTitleProjectUpdated => 'Proyecto Actualizado';

  @override
  String get notificationTitleProjectDeadline => 'Fecha Límite del Proyecto';

  @override
  String get notificationTitleEventReminder => 'Recordatorio de Evento';

  @override
  String get notificationTitleEventStartingSoon => 'Evento Próximo a Comenzar';

  @override
  String get notificationTitleEventUpdated => 'Evento Actualizado';

  @override
  String get notificationTitleEventCancelled => 'Evento Cancelado';

  @override
  String get notificationTitleChatMessage => 'Nuevo Mensaje';

  @override
  String get notificationTitleChatMention => 'Te Mencionaron';

  @override
  String get notificationTitleWorkspaceInvite =>
      'Invitación al Espacio de Trabajo';

  @override
  String get notificationTitleWorkspaceRoleChanged => 'Rol Cambiado';

  @override
  String get notificationTitleSystem => 'Notificación del Sistema';

  @override
  String get notificationTitleDefault => 'Notificación';

  @override
  String notificationBodyTaskAssigned(String actor, String task) {
    return '$actor te asignó a \"$task\"';
  }

  @override
  String get notificationBodyTaskAssignedGeneric =>
      'Te han asignado una nueva tarea';

  @override
  String notificationBodyTaskCompleted(String actor, String task) {
    return '$actor completó \"$task\"';
  }

  @override
  String get notificationBodyTaskCompletedGeneric =>
      'Una tarea ha sido completada';

  @override
  String notificationBodyTaskOverdue(String task) {
    return '\"$task\" está atrasada';
  }

  @override
  String get notificationBodyTaskOverdueGeneric => 'Tienes tareas atrasadas';

  @override
  String notificationBodyTaskDueSoon(String task, String time) {
    return '\"$task\" vence $time';
  }

  @override
  String get notificationBodyTaskDueSoonGeneric =>
      'Tienes tareas próximas a vencer';

  @override
  String notificationBodyTaskCommented(String actor, String task) {
    return '$actor comentó en \"$task\"';
  }

  @override
  String get notificationBodyTaskCommentedGeneric =>
      'Nuevo comentario en una tarea';

  @override
  String notificationBodyTaskStatusChanged(String task, String status) {
    return 'El estado de \"$task\" cambió a $status';
  }

  @override
  String get notificationBodyTaskStatusChangedGeneric =>
      'El estado de una tarea ha cambiado';

  @override
  String notificationBodyProjectInvite(String actor, String project) {
    return '$actor te invitó a unirte a \"$project\"';
  }

  @override
  String get notificationBodyProjectInviteGeneric =>
      'Has sido invitado a un proyecto';

  @override
  String notificationBodyProjectUpdated(String project) {
    return '\"$project\" ha sido actualizado';
  }

  @override
  String get notificationBodyProjectUpdatedGeneric =>
      'Un proyecto ha sido actualizado';

  @override
  String notificationBodyProjectDeadline(String project, String time) {
    return 'La fecha límite de \"$project\" es $time';
  }

  @override
  String get notificationBodyProjectDeadlineGeneric =>
      'Fecha límite del proyecto próxima';

  @override
  String notificationBodyEventReminder(String event, String time) {
    return 'Recordatorio: \"$event\" comienza $time';
  }

  @override
  String get notificationBodyEventReminderGeneric => 'Tienes un evento próximo';

  @override
  String notificationBodyEventStartingSoon(String event, String time) {
    return '\"$event\" comienza $time';
  }

  @override
  String get notificationBodyEventStartingSoonGeneric =>
      'Un evento está por comenzar';

  @override
  String notificationBodyEventUpdated(String event) {
    return '\"$event\" ha sido actualizado';
  }

  @override
  String get notificationBodyEventUpdatedGeneric =>
      'Un evento ha sido actualizado';

  @override
  String notificationBodyEventCancelled(String event) {
    return '\"$event\" ha sido cancelado';
  }

  @override
  String get notificationBodyEventCancelledGeneric =>
      'Un evento ha sido cancelado';

  @override
  String notificationBodyChatMessage(String actor) {
    return '$actor te envió un mensaje';
  }

  @override
  String get notificationBodyChatMessageGeneric => 'Tienes un nuevo mensaje';

  @override
  String notificationBodyChatMention(String actor) {
    return '$actor te mencionó en un chat';
  }

  @override
  String get notificationBodyChatMentionGeneric => 'Te mencionaron en un chat';

  @override
  String notificationBodyWorkspaceInvite(String actor, String workspace) {
    return '$actor te invitó a unirte a \"$workspace\"';
  }

  @override
  String get notificationBodyWorkspaceInviteGeneric =>
      'Has sido invitado a un espacio de trabajo';

  @override
  String notificationBodyWorkspaceRoleChanged(String workspace, String role) {
    return 'Tu rol en \"$workspace\" cambió a $role';
  }

  @override
  String get notificationBodyWorkspaceRoleChangedGeneric =>
      'Tu rol en el espacio de trabajo ha cambiado';

  @override
  String get notificationBodySystemGeneric => 'Notificación del sistema';

  @override
  String get notificationBodyDefault => 'Tienes una nueva notificación';

  @override
  String timeRemainingDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'días',
      one: 'día',
    );
    return 'en $days $_temp0';
  }

  @override
  String timeRemainingHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'horas',
      one: 'hora',
    );
    return 'en $hours $_temp0';
  }

  @override
  String timeRemainingMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'minutos',
      one: 'minuto',
    );
    return 'en $minutes $_temp0';
  }

  @override
  String timeOverdueDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'días',
      one: 'día',
    );
    return '$days $_temp0 de retraso';
  }

  @override
  String timeOverdueHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'horas',
      one: 'hora',
    );
    return '$hours $_temp0 de retraso';
  }

  @override
  String timeOverdueMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'minutos',
      one: 'minuto',
    );
    return '$minutes $_temp0 de retraso';
  }

  @override
  String get errorNoNetwork =>
      'Sin conexión de red. Por favor verifica la configuración de red de tu dispositivo.';

  @override
  String get errorNoInternet =>
      'Sin conexión a internet. Por favor verifica tu Wi-Fi o datos móviles.';

  @override
  String get errorServerUnreachable =>
      'Servidor inaccesible. Puede estar iniciándose, por favor espera un momento.';

  @override
  String get errorTimeout =>
      'Tiempo de espera agotado. Por favor intenta de nuevo.';

  @override
  String get errorAuthRequired => 'Necesitas iniciar sesión para hacer esto.';

  @override
  String get errorAuthExpired =>
      'Tu sesión ha expirado. Por favor inicia sesión nuevamente.';

  @override
  String get errorInvalidCredentials =>
      'Correo o contraseña inválidos. Por favor intenta de nuevo.';

  @override
  String get errorEmailNotConfirmed =>
      'Por favor confirma tu dirección de correo antes de iniciar sesión.';

  @override
  String get errorUserAlreadyExists => 'Ya existe una cuenta con este correo.';

  @override
  String get errorEmailAlreadyInUse => 'Este correo ya está en uso.';

  @override
  String get errorWeakPassword =>
      'La contraseña debe tener al menos 8 caracteres.';

  @override
  String get errorAuthCancelled => 'Inicio de sesión cancelado.';

  @override
  String get errorNotAMember => 'No eres miembro de este espacio de trabajo.';

  @override
  String get errorForbidden => 'No tienes permiso para hacer esto.';

  @override
  String get errorLastAdmin =>
      'No se puede eliminar el último administrador. Primero promueve a otro miembro.';

  @override
  String get errorInvalidCode =>
      'Código de invitación inválido. Por favor verifica e intenta de nuevo.';

  @override
  String get errorCodeExpired => 'Este código de invitación ha expirado.';

  @override
  String get errorCodeRevoked => 'Este código de invitación ha sido revocado.';

  @override
  String get errorCodeUsedUp =>
      'Este código de invitación ha alcanzado su límite de usos.';

  @override
  String get errorAlreadyMember =>
      'Ya eres miembro de este espacio de trabajo.';

  @override
  String get errorFileTooLarge =>
      'El archivo es demasiado grande. El tamaño máximo es 20 MB.';

  @override
  String get errorFileTypeNotAllowed =>
      'Este tipo de archivo no está permitido.';

  @override
  String get errorNotFound => 'Elemento no encontrado.';

  @override
  String errorNotFoundWithResource(String resource) {
    return '$resource no encontrado.';
  }

  @override
  String get errorTaskNotFound => 'Tarea no encontrada.';

  @override
  String get errorWorkspaceNotFound => 'Espacio de trabajo no encontrado.';

  @override
  String get errorValidationFailed =>
      'Por favor verifica el formulario e intenta de nuevo.';

  @override
  String get errorSyncConflict =>
      'Este elemento fue cambiado en otro lugar. Por favor actualiza e intenta de nuevo.';

  @override
  String get errorWorkspaceNameTaken =>
      'Ya existe un espacio de trabajo con este nombre.';

  @override
  String get errorChatNotAvailableInPersonal =>
      'El chat no está disponible en espacios de trabajo personales. Crea o únete a un espacio de equipo para usar el chat.';

  @override
  String get chatNotAvailable => 'Chat No Disponible';

  @override
  String get errorChannelNotFound => 'Canal no encontrado.';

  @override
  String get errorMessageNotFound => 'Mensaje no encontrado.';

  @override
  String get errorUnknown => 'Algo salió mal. Por favor intenta de nuevo.';

  @override
  String get errorServerError =>
      'Error del servidor. Por favor intenta más tarde.';

  @override
  String get errorTitleNetwork => 'Error de Conexión';

  @override
  String get errorTitleServer => 'Error del Servidor';

  @override
  String get errorTitleTimeout => 'Tiempo Agotado';

  @override
  String get errorTitleAuth => 'Error de Autenticación';

  @override
  String get errorTitlePermission => 'Permiso Denegado';

  @override
  String get errorTitleInviteCode => 'Código de Invitación Inválido';

  @override
  String get errorTitleFile => 'Error de Archivo';

  @override
  String get errorTitleNotFound => 'No Encontrado';

  @override
  String get errorTitleValidation => 'Error de Validación';

  @override
  String get errorTitleSync => 'Error de Sincronización';

  @override
  String get errorTitleChat => 'Error de Chat';

  @override
  String get errorDetails => 'Detalles del Error';

  @override
  String get technicalDetails => 'Detalles Técnicos';

  @override
  String get copyToClipboard => 'Copiar al Portapapeles';

  @override
  String get copiedToClipboard => 'Detalles del error copiados al portapapeles';

  @override
  String get validationEmailRequired => 'El correo electrónico es obligatorio';

  @override
  String get validationEmailInvalid =>
      'Por favor ingrese un correo electrónico válido';

  @override
  String get validationPasswordRequired => 'La contraseña es obligatoria';

  @override
  String validationPasswordMinLength(int minLength) {
    return 'La contraseña debe tener al menos $minLength caracteres';
  }

  @override
  String get validationPasswordMatch => 'Las contraseñas deben coincidir';

  @override
  String get validationNameRequired => 'El nombre es obligatorio';

  @override
  String get validationTermsRequired =>
      'Debe aceptar los Términos de Servicio y la Política de Privacidad';

  @override
  String get authWelcomeBack => 'Bienvenido de nuevo';

  @override
  String get authSignInToContinue => 'Inicia sesión para continuar a PlanPal';

  @override
  String get authCreateAccount => 'Crear Cuenta';

  @override
  String get authSignUpToGetStarted => 'Regístrate para comenzar con PlanPal';

  @override
  String get authFullName => 'Nombre Completo';

  @override
  String get authEnterYourName => 'Ingresa tu nombre completo';

  @override
  String get authEnterYourEmail => 'Ingresa tu correo electrónico';

  @override
  String get authEnterYourPassword => 'Ingresa tu contraseña';

  @override
  String get authConfirmYourPassword => 'Confirma tu contraseña';

  @override
  String authAgreeToTerms(String terms, String privacy) {
    return 'Acepto los $terms y la $privacy';
  }

  @override
  String get authTermsOfService => 'Términos de Servicio';

  @override
  String get authPrivacyPolicy => 'Política de Privacidad';

  @override
  String get authContinueWithGoogle => 'Continuar con Google';

  @override
  String get authVerifyEmail => 'Verifica tu Correo Electrónico';

  @override
  String authVerifyEmailDesc(String email) {
    return 'Ingresa el código de 6 dígitos enviado a $email';
  }

  @override
  String get authResendCode => 'Reenviar Código';

  @override
  String authResendCodeIn(int seconds) {
    return 'Reenviar código en ${seconds}s';
  }

  @override
  String get authVerifyButton => 'Verificar';

  @override
  String get authResetPassword => 'Restablecer Contraseña';

  @override
  String get authResetPasswordDesc =>
      'Ingresa tu correo electrónico para recibir un código de restablecimiento';

  @override
  String get authSendResetCode => 'Enviar Código de Restablecimiento';

  @override
  String get authEnterResetCode => 'Ingresar Código de Restablecimiento';

  @override
  String get authEnterResetCodeDesc =>
      'Ingresa el código de 6 dígitos enviado a tu correo electrónico';

  @override
  String get authEnterNewPassword => 'Ingresar Nueva Contraseña';

  @override
  String get authEnterNewPasswordDesc =>
      'Elige una nueva contraseña para tu cuenta';

  @override
  String get authNewPassword => 'Nueva Contraseña';

  @override
  String get authResetPasswordSuccess => 'Contraseña restablecida exitosamente';

  @override
  String get authSigningIn => 'Iniciando sesión...';

  @override
  String get authSigningUp => 'Creando cuenta...';

  @override
  String get authVerifying => 'Verificando...';

  @override
  String get authResetting => 'Restableciendo contraseña...';

  @override
  String get authLoginSuccess => 'Sesión iniciada exitosamente';

  @override
  String get authSignupSuccess => 'Cuenta creada exitosamente';

  @override
  String get authVerificationSuccess =>
      'Correo electrónico verificado exitosamente';

  @override
  String get authPasswordResetSuccess => 'Contraseña restablecida exitosamente';

  @override
  String get authCodeSent =>
      'Código de verificación enviado a tu correo electrónico';

  @override
  String get sessionExpired =>
      'Tu sesión ha expirado. Por favor inicia sesión nuevamente.';

  @override
  String get sessionExpiredTitle => 'Sesión Expirada';

  @override
  String get sessionRestoring => 'Restaurando tu sesión...';

  @override
  String get sessionCheckingAuth => 'Verificando autenticación...';

  @override
  String get workspaceCreateTitle => 'Crear Espacio de Trabajo';

  @override
  String get workspaceCreateDescription =>
      'Crea un nuevo espacio de trabajo para tu equipo';

  @override
  String get workspaceCreateButton => 'Crear Espacio de Trabajo';

  @override
  String get workspaceName => 'Nombre del Espacio de Trabajo';

  @override
  String get workspaceNameHint => 'ej., Equipo de Producto';

  @override
  String get workspaceDescription => 'Descripción';

  @override
  String get workspaceDescriptionHint =>
      '¿Para qué es este espacio de trabajo?';

  @override
  String get workspaceCreateSuccess => 'Espacio de trabajo creado exitosamente';

  @override
  String get workspaceCreateError => 'Error al crear el espacio de trabajo';

  @override
  String get workspaceJoinTitle => 'Unirse al Espacio de Trabajo';

  @override
  String get workspaceJoinDescription =>
      'Ingresa el código de invitación para unirte a un espacio de trabajo';

  @override
  String get workspaceJoinButton => 'Unirse al Espacio de Trabajo';

  @override
  String get workspaceInviteCode => 'Código de Invitación';

  @override
  String get workspaceCodeHelper =>
      'Obtén este código de un miembro del equipo';

  @override
  String get workspaceCodeLength => 'El código debe tener 6 caracteres';

  @override
  String get workspaceCodeFormat =>
      'El código debe contener solo letras y números';

  @override
  String get workspaceCodeInvalid => 'Código de invitación inválido';

  @override
  String get workspaceCodeExpired => 'Este código de invitación ha expirado';

  @override
  String get workspaceAlreadyMember =>
      'Ya eres miembro de este espacio de trabajo';

  @override
  String get workspaceJoinSuccess =>
      'Te uniste al espacio de trabajo exitosamente';

  @override
  String get workspaceJoinError => 'Error al unirse al espacio de trabajo';

  @override
  String get workspaceCreateNew => 'Crear Nuevo Espacio de Trabajo';

  @override
  String get workspaceMembers => 'Miembros';

  @override
  String get noMembersYet => 'Aún no hay miembros';

  @override
  String get memberRoleChanged => 'Rol de miembro cambiado exitosamente';

  @override
  String get memberRoleChangeError => 'Error al cambiar el rol del miembro';

  @override
  String get memberRemoveConfirmTitle => 'Eliminar Miembro';

  @override
  String memberRemoveConfirmMessage(String name) {
    return '¿Estás seguro de que quieres eliminar a $name de este espacio de trabajo?';
  }

  @override
  String get memberRemoved => 'Miembro eliminado exitosamente';

  @override
  String get memberRemoveError => 'Error al eliminar miembro';

  @override
  String get workspaceLeaveConfirmTitle => 'Salir del Espacio de Trabajo';

  @override
  String get workspaceLeaveConfirmMessage =>
      '¿Estás seguro de que quieres salir de este espacio de trabajo?';

  @override
  String get workspaceLeft => 'Has salido del espacio de trabajo';

  @override
  String get workspaceLeaveError => 'Error al salir del espacio de trabajo';

  @override
  String get workspaceLeave => 'Salir del Espacio de Trabajo';

  @override
  String get changeRole => 'Cambiar Rol';

  @override
  String get removeMember => 'Eliminar Miembro';

  @override
  String get roleAdmin => 'Administrador';

  @override
  String get roleAdminDescription =>
      'Puede gestionar el espacio de trabajo y miembros';

  @override
  String get roleMember => 'Miembro';

  @override
  String get roleMemberDescription => 'Puede ver y crear contenido';

  @override
  String get you => 'Tú';

  @override
  String get errorLoadingMembers => 'Error al cargar miembros';

  @override
  String get inviteCodes => 'Códigos de Invitación';

  @override
  String get noInviteCodesYet => 'Aún no hay códigos de invitación';

  @override
  String get createInviteCode => 'Crear Código de Invitación';

  @override
  String get inviteCodeCreated => 'Código de invitación creado exitosamente';

  @override
  String get inviteCodeCreateError => 'Error al crear código de invitación';

  @override
  String get inviteCodeRevokeConfirmTitle => 'Revocar Código de Invitación';

  @override
  String get inviteCodeRevokeConfirmMessage =>
      '¿Estás seguro de que quieres revocar este código de invitación? Ya no funcionará.';

  @override
  String get inviteCodeRevoked => 'Código de invitación revocado exitosamente';

  @override
  String get inviteCodeRevokeError => 'Error al revocar código de invitación';

  @override
  String get inviteCodeCopied => 'Código de invitación copiado al portapapeles';

  @override
  String get copyCode => 'Copiar Código';

  @override
  String get revokeCode => 'Revocar Código';

  @override
  String get statusActive => 'Activo';

  @override
  String get statusRevoked => 'Revocado';

  @override
  String get statusExpired => 'Expirado';

  @override
  String get statusMaxedOut => 'Usos Máximos Alcanzados';

  @override
  String get uses => 'Usos';

  @override
  String get expires => 'Expira';

  @override
  String get inviteCodeMaxUses => 'Usos Máximos';

  @override
  String get inviteCodeExpiry => 'Expira En';

  @override
  String get unlimited => 'Ilimitado';

  @override
  String get never => 'Nunca';

  @override
  String daysCount(int count) {
    return '$count días';
  }

  @override
  String get errorLoadingInviteCodes => 'Error al cargar códigos de invitación';

  @override
  String get workspaceSettings => 'Configuración del Espacio de Trabajo';

  @override
  String get workspaceUpdated => 'Espacio de trabajo actualizado';

  @override
  String get workspaceUpdateError =>
      'Error al actualizar el espacio de trabajo';

  @override
  String get workspaceNameTooShort =>
      'El nombre debe tener al menos 3 caracteres';

  @override
  String get workspaceNameTooLong =>
      'El nombre debe tener menos de 50 caracteres';

  @override
  String get workspaceType => 'Tipo';

  @override
  String get workspaceTypePersonal => 'Personal';

  @override
  String get workspaceTypeTeam => 'Equipo';

  @override
  String get createdAt => 'Creado';

  @override
  String get adminOnlySettings =>
      'Solo los administradores pueden editar la configuración';

  @override
  String get dangerZone => 'Zona de Peligro';

  @override
  String get deleteWorkspace => 'Eliminar Espacio de Trabajo';

  @override
  String get workspaceDeleteConfirmTitle => '¿Eliminar Espacio de Trabajo?';

  @override
  String get workspaceDeleteConfirmMessage =>
      '¿Estás seguro de que quieres eliminar este espacio de trabajo? Esta acción no se puede deshacer.';

  @override
  String get workspaceDeleteWarning =>
      'Todas las tareas, proyectos y datos en este espacio de trabajo se eliminarán permanentemente.';

  @override
  String get workspaceDeleted => 'Espacio de trabajo eliminado';

  @override
  String get workspaceDeleteError => 'Error al eliminar el espacio de trabajo';

  @override
  String get workspaceNotFound => 'Espacio de trabajo no encontrado';

  @override
  String get errorLoadingWorkspace => 'Error al cargar el espacio de trabajo';

  @override
  String get syncStatus => 'Estado de Sincronización';

  @override
  String get lastSync => 'Última sincronización';

  @override
  String get pendingChanges => 'Pendientes';

  @override
  String get failedChanges => 'Fallidos';

  @override
  String get failedItems => 'Elementos Fallidos';

  @override
  String get retryAll => 'Reintentar Todo';

  @override
  String get discardAll => 'Descartar Todo';

  @override
  String get discardChange => '¿Descartar Cambio?';

  @override
  String get discardAllChanges => '¿Descartar Todos los Cambios?';

  @override
  String get discardAllWarning =>
      'Esto descartará permanentemente todos los cambios fallidos. No se puede deshacer.';

  @override
  String get uploadFile => 'Upload File';

  @override
  String get uploads => 'Uploads';

  @override
  String get noUploads => 'No uploads';

  @override
  String get uploading => 'Uploading';

  @override
  String get uploadCompleted => 'Upload completed';

  @override
  String get uploadFailed => 'Upload failed';

  @override
  String get uploadCancelled => 'Upload cancelled';

  @override
  String uploadStarted(int count) {
    return 'Upload started for $count file(s)';
  }

  @override
  String get clearCompleted => 'Clear Completed';

  @override
  String get clearFailed => 'Clear Failed';

  @override
  String get waiting => 'Waiting';

  @override
  String get recent => 'Recent';

  @override
  String get noRecentDocuments => 'No recent documents';

  @override
  String get noDocuments => 'No documents';

  @override
  String get uploadFileToGetStarted => 'Upload a file to get started';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get createFolder => 'Create Folder';

  @override
  String get folderName => 'Folder Name';

  @override
  String get enterFolderName => 'Enter folder name';

  @override
  String get folderNameRequired => 'Folder name is required';

  @override
  String get folderNameTooLong =>
      'Folder name is too long (max 200 characters)';

  @override
  String get folderCreated => 'Folder created successfully';

  @override
  String get selectFilesToUpload => 'Select files to upload';

  @override
  String get browseFiles => 'Browse Files';

  @override
  String get dragAndDropFiles => 'Drag and drop files here';

  @override
  String get dropFilesHere => 'Drop files here';

  @override
  String get orClickToBrowse => 'or click to browse';

  @override
  String get rename => 'Rename';

  @override
  String get move => 'Move';

  @override
  String get download => 'Download';

  @override
  String get downloadStarted => 'Download started';

  @override
  String get confirmDeleteDocument =>
      'Are you sure you want to delete this document?';

  @override
  String get confirmDeleteFolder =>
      'Are you sure you want to delete this folder? It must be empty.';

  @override
  String get documentDeleted => 'Document deleted successfully';

  @override
  String get folderDeleted => 'Folder deleted successfully';

  @override
  String get documentName => 'Document Name';

  @override
  String get documentNameRequired => 'Document name is required';

  @override
  String get folderRenamed => 'Folder renamed successfully';

  @override
  String get documentRenamed => 'Document renamed successfully';

  @override
  String get moveToFolder => 'Move to Folder';

  @override
  String get rootFolder => 'Root Folder';

  @override
  String get noFoldersAvailable => 'No folders available';

  @override
  String get folderMoved => 'Folder moved successfully';

  @override
  String get documentMoved => 'Document moved successfully';

  @override
  String get nameTooLong => 'Name is too long (max 200 characters)';

  @override
  String get noWorkspaceSelected => 'No workspace selected';

  @override
  String get close => 'Close';

  @override
  String get documentSaved => 'Document saved';

  @override
  String savedAt(String time) {
    return 'Saved $time';
  }

  @override
  String get openWithSystemApp => 'Open with System App';

  @override
  String get errorLoadingFile => 'Error loading file';

  @override
  String get downloading => 'Downloading...';

  @override
  String get errorLoadingImage => 'Error loading image';

  @override
  String get pdfDocument => 'PDF Document';

  @override
  String get fileDocument => 'File';

  @override
  String get attachFile => 'Attach File';

  @override
  String get attachments => 'Attachments';

  @override
  String get noAttachments => 'No attachments';

  @override
  String get attachmentAdded => 'Attachment added';

  @override
  String get attachmentRemoved => 'Attachment removed';

  @override
  String get offlineUploadsDisabled =>
      'File uploads are disabled while offline';

  @override
  String get notificationTaskAssigned => 'Task Assigned';

  @override
  String get notificationTaskUpdated => 'Task Updated';

  @override
  String get notificationTaskComment => 'New Comment';

  @override
  String get notificationDeadlineApproaching => 'Deadline Approaching';

  @override
  String get notificationTaskOverdue => 'Task Overdue';

  @override
  String get notificationMention => 'You were mentioned';

  @override
  String get notificationChatMessage => 'New Message';

  @override
  String get notificationEventReminder => 'Event Reminder';

  @override
  String get notificationWorkspaceInvite => 'Workspace Invite';

  @override
  String get notificationTaskAssignedBody => 'A task has been assigned to you';

  @override
  String get notificationTaskUpdatedBody => 'A task has been updated';

  @override
  String get notificationTaskCommentBody => 'Someone commented on a task';

  @override
  String get notificationDeadlineApproachingBody =>
      'A task deadline is approaching';

  @override
  String get notificationTaskOverdueBody => 'A task is overdue';

  @override
  String get notificationMentionBody => 'Someone mentioned you';

  @override
  String get notificationChatMessageBody => 'You have a new message';

  @override
  String get notificationEventReminderBody => 'You have an upcoming event';
}
