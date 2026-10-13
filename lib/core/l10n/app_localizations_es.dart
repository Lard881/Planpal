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
  String get emptyStateNoTasks => 'Sin tareas';

  @override
  String get emptyStateNoTasksDesc => 'Crea tu primera tarea para comenzar.';

  @override
  String get emptyStateNoEvents => 'Sin eventos esta semana';

  @override
  String get emptyStateNoMessages => 'Sin mensajes aún';

  @override
  String get emptyStateNoDocuments => 'Sin documentos aún';

  @override
  String get emptyStateNoNotifications => 'Estás al día';

  @override
  String get emptyStateNoResults => 'Sin resultados';

  @override
  String get errorGeneric => 'Algo salió mal. Por favor intenta de nuevo.';

  @override
  String get errorNetwork => 'Sin conexión a internet. Verifica tu red.';

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
      'Sin conexión. Tus cambios están guardados y se sincronizarán cuando vuelvas.';

  @override
  String get bannerServerUnreachable => 'No se puede conectar al servidor.';

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
  String get today => 'Hoy';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get overdue => 'Vencido';

  @override
  String get all => 'Todos';

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
  String get logIn => 'Iniciar sesión';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get signUp => 'Crear cuenta';

  @override
  String get forgotPassword => 'Olvidé mi contraseña';

  @override
  String get goodMorning => 'Buenos días';

  @override
  String get goodAfternoon => 'Buenas tardes';

  @override
  String get goodEvening => 'Buenas noches';

  @override
  String get letsGetStarted => 'Hagamos el día productivo.';
}
