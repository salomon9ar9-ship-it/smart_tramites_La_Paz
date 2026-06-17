import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Configuración de la API para SmartTrámites La Paz
/// Contiene URLs, endpoints y constantes de conexión con el backend
class ApiConfig {
  ApiConfig._();

  // ==================== CONFIGURACIÓN DEL SERVIDOR ====================

  /// 🔥 URL base del backend (cambia según tu entorno)
  /// Para desarrollo local: 'http://localhost:8080/api'
  /// Para emulador Android: 'http://10.0.2.2:8080/api'
  /// Para dispositivo físico: 'http://TU_IP_LOCAL:8080/api'
  static const String baseUrl = 'http://localhost:8080/api';

  /// URL base del servidor (sin /api)
  static const String serverUrl = 'http://localhost:8080';

  /// Puerto del backend
  static const int serverPort = 8080;

  // ==================== TIMEOUTS ====================

  /// Tiempo máximo de espera para conexión (milisegundos)
  static const int connectionTimeout = 15000;

  /// Tiempo máximo de espera para recibir respuesta (milisegundos)
  static const int receiveTimeout = 15000;

  /// Tiempo máximo de espera para envío de datos (milisegundos)
  static const int sendTimeout = 15000;

  // ==================== ENDPOINTS DE AUTENTICACIÓN ====================

  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authLogout = '/auth/logout';
  static const String authRefreshToken = '/auth/refresh';
  static const String authForgotPassword = '/auth/forgot-password';
  static const String authResetPassword = '/auth/reset-password';
  static const String authVerifyEmail = '/auth/verify-email';

  // ==================== ENDPOINTS DE USUARIOS ====================

  static const String usersBase = '/users';
  static String userById(String id) => '/users/$id';
  static String userByEmail(String email) => '/users/email/$email';
  static String userByCI(String ci, String expedicion) =>
      '/users/ci/$ci/$expedicion';
  static const String usersProfile = '/users/profile';
  static const String usersUpdatePassword = '/users/password';
  static const String usersUploadPhoto = '/users/photo';

  // ==================== ENDPOINTS DE TRÁMITES ====================

  static const String tramitesBase = '/tramites';
  static String tramitesByUser(String userId) => '/tramites/user/$userId';
  static String tramiteById(String id) => '/tramites/$id';
  static String tramiteStatus(String id) => '/tramites/$id/status';
  static String tramiteDocuments(String id) => '/tramites/$id/documents';
  static const String tramitesByEntity = '/tramites/entity';
  static const String tramitesByCategory = '/tramites/category';

  // ==================== ENDPOINTS DE PAGOS ====================

  static const String pagosBase = '/pagos';
  static String pagosByUser(String userId) => '/pagos/user/$userId';
  static String pagoById(String id) => '/pagos/$id';
  static String pagoByTramite(String tramiteId) => '/pagos/tramite/$tramiteId';
  static String pagoGenerateQR(String pagoId) => '/pagos/$pagoId/qr';
  static String pagoVerify(String id) => '/pagos/$id/verify';

  // ==================== ENDPOINTS DE LICENCIAS ====================

  static const String licenciasBase = '/licencias';
  static String licenciasByUser(String userId) => '/licencias/user/$userId';
  static String licenciaById(String id) => '/licencias/$id';
  static const String licenciasCategorias = '/licencias/categorias';
  static String licenciaRenovar(String id) => '/licencias/$id/renovar';

  // ==================== ENDPOINTS DE RECORDATORIOS ====================

  static const String recordatoriosBase = '/recordatorios';
  static String recordatoriosByUser(String userId) =>
      '/recordatorios/user/$userId';
  static String recordatorioById(String id) => '/recordatorios/$id';
  static String recordatorioToggle(String id) => '/recordatorios/$id/toggle';

  // ==================== ENDPOINTS DE ENTIDADES ====================

  static const String entidadesBase = '/entidades';
  static String entidadById(String id) => '/entidades/$id';
  static const String entidadesActivas = '/entidades/activas';

  // ==================== ENDPOINTS DE BANCOS ====================

  static const String bancosBase = '/bancos';
  static String bancoById(String id) => '/bancos/$id';
  static const String bancosActivos = '/bancos/activos';
  static const String bancosAceptaQR = '/bancos/qr';

  // ==================== ENDPOINTS DE NOTIFICACIONES ====================

  static const String notificacionesBase = '/notificaciones';
  static String notificacionesByUser(String userId) =>
      '/notificaciones/user/$userId';
  static String notificacionRead(String id) => '/notificaciones/$id/read';
  static String notificacionesNoLeidas(String userId) =>
      '/notificaciones/user/$userId/no-leidas';
  static const String notificacionesMarkAllRead = '/notificaciones/read-all';

  // ==================== ENDPOINTS DE ESTADÍSTICAS ====================

  static const String estadisticasBase = '/estadisticas';
  static const String estadisticasTramites = '/estadisticas/tramites';
  static const String estadisticasPagos = '/estadisticas/pagos';
  static const String estadisticasUsuarios = '/estadisticas/usuarios';

  // ==================== ENDPOINTS DE AUDITORÍA ====================

  static const String auditLogsBase = '/audit-logs';
  static String auditLogsByUser(String userId) => '/audit-logs/user/$userId';

  // ==================== HEADERS ====================

  static Map<String, String> getHeaders({String? token}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // ==================== VALIDACIÓN DE CONEXIÓN ====================

  /// Verifica si la URL es válida
  static bool isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  /// Obtiene la URL completa concatenando baseUrl + endpoint
  static String getFullUrl(String endpoint) {
    if (endpoint.startsWith('http')) return endpoint;
    return '$baseUrl$endpoint';
  }

  // ==================== CONFIGURACIÓN POR ENTORNO ====================

  /// Obtiene la configuración según el entorno
  static ApiEnvironment get environment {
    // Detecta si está en producción
    const bool isProd = bool.fromEnvironment('dart.vm.product');

    if (isProd) {
      return ApiEnvironment.production;
    } else {
      return ApiEnvironment.development;
    }
  }

  /// URL según el entorno actual
  static String get currentBaseUrl {
    switch (environment) {
      case ApiEnvironment.development:
        return 'http://localhost:8080/api';
      case ApiEnvironment.staging:
        return 'https://staging.smarttramites.bo/api';
      case ApiEnvironment.production:
        return 'https://api.smarttramites.bo/api';
    }
  }
}

/// Alias para compatibilidad (AppConfig = ApiConfig)
/// Esto permite que todos los archivos que usan AppConfig funcionen sin cambios
class AppConfig extends ApiConfig {
  AppConfig._() : super._();

  // ==================== MÉTODOS DE UTILIDAD ====================

  /// Formatea una fecha a formato legible (dd/MM/yyyy)
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Formatea una fecha con hora (dd/MM/yyyy HH:mm)
  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  /// Formatea una fecha a formato largo (ej: "17 de junio de 2025")
  static String formatDateLong(DateTime date) {
    return DateFormat('dd "de" MMMM "de" yyyy', 'es_BO').format(date);
  }

  /// Formatea moneda boliviana
  static String formatCurrency(double amount) {
    return NumberFormat.currency(symbol: 'Bs. ', decimalDigits: 2)
        .format(amount);
  }

  /// Valida si una fecha es futura
  static bool isFutureDate(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  /// Obtiene los días restantes hasta una fecha
  static int daysUntil(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }

  // ==================== MÉTODOS DE VALIDACIÓN ====================

  /// Valida un CI (Cédula de Identidad) boliviano
  /// Debe tener entre 4 y 8 dígitos numéricos
  static bool isValidCI(String ci) {
    final cleanCI = ci.trim().replaceAll(RegExp(r'\D'), '');
    return cleanCI.length >= 4 && cleanCI.length <= 8;
  }

  /// Valida un número de teléfono boliviano
  /// Debe tener 8 dígitos y comenzar con 6 o 7
  static bool isValidPhone(String phone) {
    final cleanPhone = phone.trim().replaceAll(RegExp(r'\D'), '');
    return cleanPhone.length == 8 &&
        (cleanPhone.startsWith('6') || cleanPhone.startsWith('7'));
  }

  /// Valida un número de teléfono boliviano (alias para isValidPhone)
  static bool validateTelefono(String telefono) {
    return isValidPhone(telefono);
  }

  /// Valida un correo electrónico
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email.trim());
  }

  /// Valida un correo electrónico (alias para isValidEmail)
  static bool validateEmail(String email) {
    return isValidEmail(email);
  }

  /// Valida una contraseña
  /// Debe tener al menos 8 caracteres, incluyendo letras y números
  static bool isValidPassword(String password) {
    if (password.length < 8) return false;
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    return hasLetter && hasNumber;
  }

  /// Valida un NIT (Número de Identificación Tributaria)
  static bool isValidNIT(String nit) {
    final cleanNIT = nit.trim().replaceAll(RegExp(r'\D'), '');
    return cleanNIT.length >= 8 && cleanNIT.length <= 10;
  }

  /// Valida una placa de vehículo boliviana
  static bool isValidPlaca(String placa) {
    final placaRegex = RegExp(r'^[A-Z]{3}\d{3}$', caseSensitive: false);
    return placaRegex.hasMatch(placa.trim().toUpperCase());
  }

  /// Valida un código de verificación
  static bool isValidVerificationCode(String code) {
    final cleanCode = code.trim();
    return cleanCode.length == 6 && RegExp(r'^\d{6}$').hasMatch(cleanCode);
  }

  /// Valida que un string no esté vacío
  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }

  /// Valida que un string tenga una longitud mínima
  static bool hasMinLength(String value, int minLength) {
    return value.trim().length >= minLength;
  }

  /// Valida que un string tenga una longitud máxima
  static bool hasMaxLength(String value, int maxLength) {
    return value.trim().length <= maxLength;
  }

  // ==================== MÉTODOS DE FORMATO ====================

  /// Formatea un CI boliviano
  /// Ej: 1234567, LP, complemento: 10 → "1234567-10 LP"
  static String formatCI(String numero, String expedicion,
      {String? complemento}) {
    if (complemento != null && complemento.isNotEmpty) {
      return '$numero-$complemento $expedicion';
    }
    return '$numero $expedicion';
  }

  /// Formatea el estado de un trámite o pago
  /// Convierte estados técnicos a texto legible
  static String formatEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'pagado':
        return '✅ Pagado';
      case 'pendiente':
        return '⏳ Pendiente';
      case 'cancelado':
        return '❌ Cancelado';
      case 'iniciado':
        return '📝 Iniciado';
      case 'en_proceso':
      case 'en proceso':
        return '🔄 En Proceso';
      case 'completado':
        return '✔️ Completado';
      case 'rechazado':
        return '⛔ Rechazado';
      case 'aprobado':
        return '✅ Aprobado';
      case 'activo':
        return '🟢 Activo';
      case 'inactivo':
        return '🔴 Inactivo';
      case 'vencido':
        return '️ Vencido';
      default:
        // Capitaliza la primera letra
        return estado.isNotEmpty
            ? estado[0].toUpperCase() + estado.substring(1).toLowerCase()
            : estado;
    }
  }

  /// Obtiene el color recomendado para un estado
  static Color getColorForEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'pagado':
      case 'completado':
      case 'aprobado':
      case 'activo':
        return Colors.green;
      case 'pendiente':
      case 'en_proceso':
      case 'en proceso':
      case 'iniciado':
        return Colors.orange;
      case 'cancelado':
      case 'rechazado':
      case 'inactivo':
      case 'vencido':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Obtiene el ícono recomendado para un estado
  static IconData getIconForEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'pagado':
      case 'completado':
      case 'aprobado':
        return Icons.check_circle;
      case 'pendiente':
      case 'iniciado':
        return Icons.pending;
      case 'en_proceso':
      case 'en proceso':
        return Icons.autorenew;
      case 'cancelado':
      case 'rechazado':
        return Icons.cancel;
      case 'vencido':
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  /// Formatea categoría de trámite
  static String formatCategoria(String categoria) {
    return categoria.isNotEmpty
        ? categoria[0].toUpperCase() + categoria.substring(1).toLowerCase()
        : categoria;
  }

  /// Formatea nombre de entidad
  static String formatEntidad(String entidad) {
    return entidad.isNotEmpty
        ? entidad[0].toUpperCase() + entidad.substring(1).toLowerCase()
        : entidad;
  }

  /// Formatea número de teléfono boliviano
  static String formatPhone(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.length == 8) {
      return '${cleanPhone.substring(0, 4)}-${cleanPhone.substring(4)}';
    }
    return phone;
  }

  /// Formatea NIT
  static String formatNIT(String nit) {
    final cleanNIT = nit.replaceAll(RegExp(r'\D'), '');
    if (cleanNIT.length >= 8) {
      return '${cleanNIT.substring(0, cleanNIT.length - 1)}-${cleanNIT.substring(cleanNIT.length - 1)}';
    }
    return nit;
  }
}

/// Alias para compatibilidad (AppConfig = ApiConfig)
class AppConfigAlias extends ApiConfig {
  AppConfigAlias._() : super._();
}

/// Enumeración de entornos de la aplicación
enum ApiEnvironment {
  development,
  staging,
  production,
}

/// Clase para información de la API (útil para debugging)
class ApiInfo {
  static void printConfig() {
    print('═══════════════════════════════════════');
    print('🌐 SmartTrámites API Configuration');
    print('═══════════════════════════════════════');
    print('📍 Base URL: ${ApiConfig.baseUrl}');
    print('🔌 Port: ${ApiConfig.serverPort}');
    print('⏱️  Connection Timeout: ${ApiConfig.connectionTimeout}ms');
    print('⏱️  Receive Timeout: ${ApiConfig.receiveTimeout}ms');
    print('🌍 Environment: ${ApiConfig.environment.name}');
    print('═══════════════════════════════════════');
  }
}
