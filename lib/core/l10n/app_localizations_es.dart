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
  String get navHome => 'Inicio';

  @override
  String get navTasks => 'Tareas';

  @override
  String get navCalendar => 'Calendario';

  @override
  String get navChat => 'Chat';

  @override
  String get navDocuments => 'Documentos';

  @override
  String get navAnalytics => 'Analíticas';

  @override
  String get navTeam => 'Equipo';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get navProfile => 'Perfil';

  @override
  String get searchPlaceholder => 'Buscar tareas, docs, personas...';

  @override
  String get searchCtrlK => 'Ctrl K';

  @override
  String get searchChats => 'Buscar chats...';

  @override
  String get searchFiles => 'Buscar archivos...';

  @override
  String get searchTasks => 'Buscar tareas...';

  @override
  String get btnSave => 'Guardar';

  @override
  String get btnCancel => 'Cancelar';

  @override
  String get btnDelete => 'Eliminar';

  @override
  String get btnCreate => 'Crear';

  @override
  String get btnConfirm => 'Confirmar';

  @override
  String get btnRetry => 'Intentar de nuevo';

  @override
  String get btnViewAll => 'Ver todo';

  @override
  String get btnViewAllTasks => 'Ver todas las tareas';

  @override
  String get btnDetails => 'Detalles';

  @override
  String get btnCopy => 'Copiar';

  @override
  String get btnCopied => 'Copiado';

  @override
  String get btnAddTask => '+ Añadir tarea';

  @override
  String get btnCreateTask => 'Crear tarea';

  @override
  String get btnUpload => 'Subir archivo';

  @override
  String get btnNewDocument => '+ Nuevo documento';

  @override
  String get btnScheduleEvent => '+ Programar evento';

  @override
  String get btnSaveEvent => 'Guardar evento';

  @override
  String get btnSaveSettings => 'Guardar ajustes';

  @override
  String get btnSignOut => 'Cerrar sesión';

  @override
  String get btnDeleteAccount => 'Eliminar cuenta';

  @override
  String get btnMarkAllRead => 'Marcar todo como leído';

  @override
  String get btnMarkComplete => 'Marcar como completado';

  @override
  String get btnDeleteSelected => 'Eliminar seleccionados';

  @override
  String get btnInviteWithCode => 'Invitar con código';

  @override
  String get btnNewCode => '+ Nuevo código';

  @override
  String get btnJoin => 'Unirse';

  @override
  String get btnCreateWorkspace => '+ Crear espacio';

  @override
  String get btnJoinWithCode => 'Unirse con código';

  @override
  String get btnUploadNew => 'Subir nuevo';

  @override
  String get btnRemove => 'Eliminar';

  @override
  String get btnRevoke => 'Revocar';

  @override
  String get btnAdd => 'Añadir';

  @override
  String get btnOpen => 'Abrir';

  @override
  String get btnDiscard => 'Descartar';

  @override
  String get btnSkipForNow => 'Omitir por ahora';

  @override
  String get btnContinueWith => 'Continuar ->';

  @override
  String get btnGetStarted => 'Comenzar ->';

  @override
  String get btnCreateCode => 'Crear código';

  @override
  String get emptyStateNoTasks => 'Sin tareas aún';

  @override
  String get emptyStateNoTasksDesc => 'Crea tu primera tarea para comenzar.';

  @override
  String get emptyStateNoTasksToday => 'Nada pendiente hoy.';

  @override
  String get emptyStateNoEvents => 'Sin eventos esta semana';

  @override
  String get emptyStateNoEventsDay => 'Sin eventos este día.';

  @override
  String get emptyStateNoMessages => 'Sin mensajes aún.';

  @override
  String get emptyStateNoDocuments => 'Sin documentos aún';

  @override
  String get emptyStateNoNotifications => 'Estás al día';

  @override
  String get emptyStateNoResults => 'Sin resultados';

  @override
  String emptyStateNoResultsFor(String query) {
    return 'Sin resultados para \"$query\"';
  }

  @override
  String get emptyStateNoInviteCodes => 'Sin códigos de invitación';

  @override
  String get emptyStateNoInviteCodesDesc => 'Crea uno para invitar compañeros.';

  @override
  String get emptyStateNoMembers => 'Sin miembros encontrados';

  @override
  String get emptyStateNoAnalytics => 'Sin analíticas aún';

  @override
  String get emptyStateNoAnalyticsDesc =>
      'Completa tareas para ver tus estadísticas.';

  @override
  String get emptyStateNoChannels => 'Sin canales aún';

  @override
  String get emptyStateNoChannelsDesc => 'Crea un canal para comenzar.';

  @override
  String get emptyStateSelectChannel => 'Selecciona un canal';

  @override
  String get emptyStateSelectChannelDesc =>
      'Elige un canal para comenzar a chatear.';

  @override
  String get emptyStateChatTeamOnly => 'El chat es para equipos';

  @override
  String get emptyStateChatTeamOnlyDesc =>
      'El chat solo está disponible en espacios de equipo.';

  @override
  String get emptyStateTeamOnly =>
      'El equipo es para espacios de trabajo en equipo';

  @override
  String get emptyStateTeamOnlyDesc =>
      'Crea o únete a un espacio de equipo para ver miembros.';

  @override
  String get emptyStateTaskNotFound => 'Tarea no encontrada';

  @override
  String get emptyStateDocNotFound => 'Documento no encontrado';

  @override
  String get emptyStateNothingUpcoming => 'Nada próximo.';

  @override
  String get errorGeneric => 'Algo salió mal. Por favor intenta de nuevo.';

  @override
  String get errorNetwork =>
      'Sin conexión a internet. Verifica tu red e intenta de nuevo.';

  @override
  String get errorServer => 'Error del servidor. Intenta en un momento.';

  @override
  String get errorPermission => 'No tienes permiso para hacer esto.';

  @override
  String get errorNotFound => 'Este elemento ya no existe.';

  @override
  String get errorSessionExpired =>
      'Tu sesión expiró. Por favor inicia sesión de nuevo.';

  @override
  String get bannerOffline =>
      'Sin conexión. Tus cambios están guardados y se sincronizarán cuando vuelvas en línea.';

  @override
  String get bannerServerUnreachable =>
      'No se puede conectar al servidor. Verifica tu conexión.';

  @override
  String get bannerWakingUp =>
      'Iniciando el servidor, puede tardar hasta un minuto.';

  @override
  String get bannerBackOnline => 'De vuelta en línea. Sincronizando...';

  @override
  String syncWaiting(int count) {
    return 'Esperando sincronizar $count';
  }

  @override
  String get syncSaved => 'Guardado';

  @override
  String get syncSaving => 'Guardando...';

  @override
  String get syncWaitingShort => 'Esperando sincronizar';

  @override
  String get priorityHigh => 'Alta';

  @override
  String get priorityMedium => 'Media';

  @override
  String get priorityLow => 'Baja';

  @override
  String get statusTodo => 'Pendiente';

  @override
  String get statusInProgress => 'En progreso';

  @override
  String get statusCompleted => 'Completado';

  @override
  String get statusOverdue => 'Vencido';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleMember => 'Miembro';

  @override
  String get roleGuest => 'Invitado';

  @override
  String get workspacePersonal => 'Personal';

  @override
  String get workspaceTeam => 'Equipo';

  @override
  String workspaceMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros',
      one: '1 miembro',
    );
    return '$_temp0';
  }

  @override
  String get workspaceNameLabel => 'Nombre del espacio';

  @override
  String get workspaceNameHint => 'Mi equipo';

  @override
  String get workspaceSwitchTitle => 'Cambiar espacio';

  @override
  String get workspaceCreateTitle => 'Crear espacio';

  @override
  String get workspaceCreateSubtitle =>
      'Dale un nombre amigable a tu nuevo espacio.';

  @override
  String get workspaceCreateTip =>
      'Sugerencia: puedes invitar compañeros justo después de crearlo.';

  @override
  String get workspaceJoinTitle => 'Unirse con código';

  @override
  String get workspaceJoinSubtitle =>
      'Pide a tu compañero el código de invitación de 8 caracteres.';

  @override
  String workspaceJoinedSuccess(String name) {
    return '¡Te uniste a $name!';
  }

  @override
  String get workspaceSettings => 'Ajustes del espacio';

  @override
  String workspaceSettingsSubtitle(String name) {
    return '$name · Gestionar personas y acceso';
  }

  @override
  String get tabMembers => 'Miembros';

  @override
  String get tabInviteCodes => 'Códigos de invitación';

  @override
  String get today => 'Hoy';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get overdue => 'Vencido';

  @override
  String get all => 'Todos';

  @override
  String get yesterday => 'Ayer';

  @override
  String get tomorrow => 'Mañana';

  @override
  String get pageLoading => 'Cargando...';

  @override
  String errorCode(String code) {
    return 'Código de error: $code';
  }

  @override
  String requestId(String id) {
    return 'ID de solicitud: $id';
  }

  @override
  String get confirmDeleteTitle => '¿Eliminar este elemento?';

  @override
  String get confirmDeleteBody => 'Esta acción no se puede deshacer.';

  @override
  String get confirmDeleteTasksTitle => '¿Eliminar tareas seleccionadas?';

  @override
  String get confirmRemoveMemberTitle => '¿Eliminar miembro?';

  @override
  String confirmRemoveMemberBody(String name) {
    return '¿Eliminar a $name de este espacio?';
  }

  @override
  String get confirmDiscardTitle => '¿Descartar cambio?';

  @override
  String get confirmDiscardBody => 'Este cambio se eliminará permanentemente.';

  @override
  String get logIn => 'Iniciar sesión';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get signUp => 'Crear cuenta';

  @override
  String get forgotPassword => 'Olvidé mi contraseña';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get createOrJoinTeam => 'Crear o unirse a un equipo';

  @override
  String get loginTitle => 'Bienvenido de nuevo';

  @override
  String get loginSubtitleMobile => 'Inicia sesión para seguir el día.';

  @override
  String get loginSubtitleDesktop => 'Inicia sesión donde lo dejaste.';

  @override
  String get loginForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get loginNewHere => '¿Nuevo aquí?';

  @override
  String get loginCreateAccount => 'Crear cuenta';

  @override
  String get loginCalm => 'Días tranquilos, tareas hechas.';

  @override
  String get loginCalmDesc =>
      'PlanPal reúne tareas, calendario y chat en un lugar amigable.';

  @override
  String get signupTitle => 'Crea tu cuenta';

  @override
  String get signupTeamworkTitle => 'Trabajo en equipo, sin el caos.';

  @override
  String get signupTeamworkDesc =>
      'Tareas, calendario, chat, docs e insights — diseñados para sentirse tranquilos.';

  @override
  String get signupHaveAccount => '¿Tienes una cuenta?';

  @override
  String get signupTermsPrefix => 'Acepto los';

  @override
  String get signupTerms => 'Términos';

  @override
  String get signupTermsAnd => 'y la';

  @override
  String get signupPrivacy => 'Política de privacidad';

  @override
  String get fieldFullName => 'Nombre completo';

  @override
  String get fieldFullNameHint => 'Nombre Apellido';

  @override
  String get fieldEmail => 'Correo electrónico';

  @override
  String get fieldEmailHint => 'name@example.com';

  @override
  String get fieldPassword => 'Contraseña';

  @override
  String get fieldPasswordHint => '••••••••••';

  @override
  String get fieldConfirmPassword => 'Confirmar contraseña';

  @override
  String get fieldNewPassword => 'Nueva contraseña';

  @override
  String get fieldConfirmNewPassword => 'Confirmar nueva contraseña';

  @override
  String get fieldTaskName => 'Nombre de la tarea';

  @override
  String get fieldTaskNameHint => 'Planear reunión de equipo';

  @override
  String get fieldDescription => 'Descripción';

  @override
  String get fieldDescriptionHint => 'Lugar, fecha, agenda...';

  @override
  String get fieldDueDate => 'Fecha límite';

  @override
  String get fieldTime => 'Hora';

  @override
  String get fieldPriority => 'Prioridad';

  @override
  String get fieldAssignee => 'Asignado';

  @override
  String get fieldAssigneeOptional => 'Asignado (opcional)';

  @override
  String get fieldLabel => 'Etiqueta';

  @override
  String get fieldLabelOptional => 'Etiqueta (opcional)';

  @override
  String get fieldTitle => 'Título';

  @override
  String get fieldTitleHint => 'Revisión de diseño';

  @override
  String get fieldStarts => 'Inicio';

  @override
  String get fieldEnds => 'Fin';

  @override
  String get fieldAllDay => 'Todo el día';

  @override
  String get fieldReminder => 'Recordatorio';

  @override
  String get fieldChannelName => 'Nombre del canal';

  @override
  String get fieldDocTitle => 'Título del documento';

  @override
  String get fieldUntitled => 'Sin título';

  @override
  String get fieldStartWriting => 'Empieza a escribir...';

  @override
  String get fieldAddDetailsHint => 'Añadir detalles...';

  @override
  String get fieldWriteComment => 'Escribe un comentario...';

  @override
  String get fieldMessageHint => 'Mensaje...';

  @override
  String get fieldSubtaskHint => 'Título de la subtarea';

  @override
  String fieldMessageChannelHint(String channel) {
    return 'Mensaje #$channel...';
  }

  @override
  String get validationEmailRequired => 'El correo es obligatorio.';

  @override
  String get validationEmailInvalid => 'Ingresa un correo válido.';

  @override
  String get validationPasswordRequired => 'La contraseña es obligatoria.';

  @override
  String get validationPasswordTooShort =>
      'La contraseña debe tener al menos 8 caracteres.';

  @override
  String get validationPasswordsNoMatch => 'Las contraseñas no coinciden.';

  @override
  String get validationNameRequired => 'El nombre completo es obligatorio.';

  @override
  String get validationTermsRequired =>
      'Por favor acepta los Términos y la Política de privacidad.';

  @override
  String get validationTaskNameRequired =>
      'El nombre de la tarea es obligatorio.';

  @override
  String get validationWorkspaceNameRequired =>
      'El nombre del espacio es obligatorio.';

  @override
  String get forgotPasswordTitle => 'Restablecer contraseña';

  @override
  String get forgotPasswordSubtitle =>
      'Ingresa el correo vinculado a tu cuenta.';

  @override
  String forgotPasswordStep(int current) {
    return 'Paso $current de 3';
  }

  @override
  String get forgotPasswordSendCode => 'Enviar código';

  @override
  String get forgotPasswordBackToLogin => 'Volver al inicio de sesión';

  @override
  String get forgotPasswordEnterCode => 'Ingresar código';

  @override
  String get forgotPasswordCodeSent =>
      'Código de 6 dígitos enviado a tu correo.';

  @override
  String get forgotPasswordContinue => 'Continuar';

  @override
  String get forgotPasswordSetNew => 'Establecer nueva contraseña';

  @override
  String get forgotPasswordSaveNew => 'Guardar nueva contraseña';

  @override
  String get verifyEmailTitle => 'Revisa tu bandeja';

  @override
  String verifyEmailSentDesktop(String email) {
    return 'Enviamos un código de 6 dígitos a $email';
  }

  @override
  String verifyEmailSentMobile(String email) {
    return 'Código enviado a $email';
  }

  @override
  String get verifyEmailVerify => 'Verificar';

  @override
  String get verifyEmailResend => '¿No llegó? Reenviar código';

  @override
  String verifyEmailResendCooldown(int seconds) {
    return '¿No llegó? Reenviar en ${seconds}s';
  }

  @override
  String get onboardingTitle => '¿Dónde quieres empezar?';

  @override
  String get onboardingSubtitle =>
      'Siempre puedes cambiar o crear más después.';

  @override
  String get onboardingPersonalTitle => 'Mi espacio personal';

  @override
  String get onboardingPersonalSubtitle => 'Tareas y notas privadas.';

  @override
  String get onboardingPersonalTitleDesktop =>
      'Continuar con mi espacio personal';

  @override
  String get onboardingPersonalSubtitleDesktop =>
      'Un espacio privado y tranquilo para tus tareas y notas.';

  @override
  String get onboardingTeamTitle => 'Crear o unirse a un equipo';

  @override
  String get onboardingTeamSubtitle => 'Comparte trabajo con otros.';

  @override
  String get onboardingTeamSubtitleDesktop =>
      'Invita compañeros, comparte tareas y chatea juntos.';

  @override
  String get tasksTitle => 'Tareas';

  @override
  String tasksDueToday(int count, int dueToday) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tareas · $dueToday vencen hoy',
      one: '1 tarea · 1 vence hoy',
    );
    return '$_temp0';
  }

  @override
  String tasksSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tareas seleccionadas',
      one: '1 tarea seleccionada',
    );
    return '$_temp0';
  }

  @override
  String get tasksNoResultsFilters => 'Sin resultados para estos filtros';

  @override
  String get tasksClearFilters => 'Borrar filtros';

  @override
  String get tasksAddSubtask => '+ Añadir subtarea';

  @override
  String get tasksAddSubtaskHint => '+ Añadir subtarea...';

  @override
  String tasksSubtasksLabel(int done, int total) {
    return 'Subtareas $done/$total';
  }

  @override
  String get tasksDetailTitle => 'Detalles de la tarea';

  @override
  String get tasksNewTitle => 'Nueva tarea';

  @override
  String get tasksDescriptionLabel => 'Descripción';

  @override
  String get tasksNoDescription => 'Sin descripción.';

  @override
  String get tasksComments => 'Comentarios';

  @override
  String get tasksAttachments => 'Adjuntos';

  @override
  String get tasksAssigneeLabel => 'Asignado y etiqueta';

  @override
  String get tasksUnassigned => 'Sin asignar';

  @override
  String tasksDoneDate(String date) {
    return 'Hecho el $date';
  }

  @override
  String get calendarTitle => 'Calendario';

  @override
  String get calendarToday => 'Hoy';

  @override
  String get calendarTodaySchedule => 'Agenda de hoy';

  @override
  String calendarScheduleFor(String date) {
    return 'Agenda · $date';
  }

  @override
  String get scheduleEventTitle => 'Programar evento';

  @override
  String get reminderNone => 'Sin recordatorio';

  @override
  String get reminderFiveMin => '5 minutos antes';

  @override
  String get reminderFifteenMin => '15 minutos antes';

  @override
  String get reminderThirtyMin => '30 minutos antes';

  @override
  String get reminderOneHour => '1 hora antes';

  @override
  String get documentsTitle => 'Documentos';

  @override
  String get documentsRecent => 'Recientes';

  @override
  String get documentsRecentTitle => 'Documentos recientes';

  @override
  String get documentEditorSave => 'Guardar';

  @override
  String get documentEditorStartWriting => 'Empieza a escribir...';

  @override
  String get documentNewFolderTitle => 'Nueva carpeta';

  @override
  String get documentNewTitle => 'Nuevo documento';

  @override
  String get documentUploadFile => 'Subir archivo';

  @override
  String get documentNewFolder => 'Nueva carpeta';

  @override
  String get chatTitle => 'Mensajes';

  @override
  String get chatNewChannel => 'Nuevo canal';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get notificationsAll => 'Todas';

  @override
  String get notificationsUnread => 'No leídas';

  @override
  String get notificationsTasks => 'Tareas';

  @override
  String get notificationsMentions => 'Menciones';

  @override
  String get notificationsMarkRead => 'Marcar como leído';

  @override
  String get notificationsMarkUnread => 'Marcar como no leído';

  @override
  String get analyticsTitle => 'Analíticas';

  @override
  String get analyticsExportCSV => 'Exportar CSV';

  @override
  String get analyticsLastSevenDays => 'Últimos 7 días';

  @override
  String get analyticsLastThirtyDays => 'Últimos 30 días';

  @override
  String get analyticsLastNinetyDays => 'Últimos 90 días';

  @override
  String get analyticsTasksCompleted => 'Tareas completadas';

  @override
  String get analyticsAvgTime => 'Tiempo promedio de finalización';

  @override
  String get analyticsVelocity => 'Velocidad del equipo';

  @override
  String get analyticsStreak => 'Racha productiva';

  @override
  String get analyticsWeeklyOutput => 'Producción semanal';

  @override
  String get analyticsCategoryMix => 'Mezcla de categorías';

  @override
  String get homeYourTasksToday => 'Tus tareas de hoy';

  @override
  String get homeQuickActions => 'Acciones rápidas';

  @override
  String get homeOverview => 'Resumen';

  @override
  String get homeUpcoming => 'Próximos';

  @override
  String get homeStats => 'Estadísticas';

  @override
  String get homeDocs => 'Docs';

  @override
  String get homeSevenDays => '7 días';

  @override
  String get homeThirtyDays => '30 días';

  @override
  String get homeTasksCompleted => 'Tareas completadas';

  @override
  String get homeCompleted => 'Completado';

  @override
  String get homeInProgress => 'En progreso';

  @override
  String get homeOverdue => 'Vencido';

  @override
  String get homeProductivity => 'Productividad';

  @override
  String get teamDirectoryTitle => 'Directorio del equipo';

  @override
  String get teamLatestUpdates => 'Últimas actualizaciones';

  @override
  String get teamNoActivity => 'Sin actividad reciente';

  @override
  String get teamPresenceOnline => 'Activo ahora';

  @override
  String get teamPresenceAway => 'Ausente';

  @override
  String get teamPresenceOffline => 'Desconectado';

  @override
  String get settingsProfile => 'Perfil';

  @override
  String get settingsAccount => 'Cuenta';

  @override
  String get settingsNotifications => 'Notificaciones';

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get settingsSecurity => 'Seguridad';

  @override
  String get settingsWorkspace => 'Espacio de trabajo';

  @override
  String get settingsSyncStatus => 'Estado de sincronización';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsAvatarUpdated => '¡Avatar actualizado!';

  @override
  String get settingsDeleteAccountTitle => 'Eliminar cuenta';

  @override
  String get settingsDeleteAccountDesc =>
      'Esto elimina permanentemente tu cuenta y todos los datos.';

  @override
  String settingsComingSoon(String section) {
    return 'Ajustes de $section próximamente.';
  }

  @override
  String get syncStatusTitle => 'Estado de sincronización';

  @override
  String get syncConnection => 'Conexión';

  @override
  String get syncOnline => 'En línea';

  @override
  String get syncOffline => 'Sin conexión';

  @override
  String get syncServerWaking => 'Iniciando servidor...';

  @override
  String get syncServerUnreachable => 'Servidor inaccesible';

  @override
  String syncLastSynced(String time) {
    return 'Última sincronización: $time';
  }

  @override
  String get syncPendingChanges => 'Cambios pendientes';

  @override
  String get syncNoPending => 'Sin cambios pendientes.';

  @override
  String get syncFailedChanges => 'Cambios fallidos';

  @override
  String get syncNoFailed => 'Sin cambios fallidos.';

  @override
  String get syncRetryAll => 'Reintentar todo';

  @override
  String get syncCouldNotSave =>
      'No se pudo guardar. Es posible que ya no tengas acceso.';

  @override
  String get syncJustNow => 'Ahora mismo';

  @override
  String get avatarCropTitle => 'Recortar foto';

  @override
  String get codeCopied => 'Código copiado';

  @override
  String get goodMorning => 'Buenos días';

  @override
  String get goodAfternoon => 'Buenas tardes';

  @override
  String get goodEvening => 'Buenas noches';

  @override
  String get letsGetStarted => 'Hagamos el día productivo.';
}
