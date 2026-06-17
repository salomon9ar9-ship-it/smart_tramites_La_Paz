/// Constantes globales de la aplicación SmartTrámites
/// No instanciar esta clase. Usar solo sus campos estáticos.
class AppConstants {
  AppConstants._();

  // ═══════════════════════════════════════════════════════
  // 📱 INFORMACIÓN DE LA APP
  // ═══════════════════════════════════════════════════════
  static const String appName = 'SmartTrámites La Paz';
  static const String appVersion = '1.0.0';
  static const int buildNumber = 1;
  static const String appPackageName = 'bo.smarttramites.app';

  // ═══════════════════════════════════════════════════════
  // ✅ VALIDACIONES Y PATRONES
  // ═══════════════════════════════════════════════════════
  static const String ciPattern = r'^\d{4,8}$';
  static const String phonePattern = r'^[67]\d{7}$';
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;

  // ═══════════════════════════════════════════════════════
  // 📄 TIPOS DE DOCUMENTO
  // ═══════════════════════════════════════════════════════
  static const String tipoDocumentoCI = 'CI';  // ✅ Agregado (faltaba)
  static const String tipoDocumentoCE = 'CE';  // ✅ Agregado (faltaba)
  static const String docCI = 'CI';
  static const String docCE = 'CE';
  static const String docPasaporte = 'PASAPORTE';

  // ═══════════════════════════════════════════════════════
  // 🇧🇴 DEPARTAMENTOS DE BOLIVIA
  // ═══════════════════════════════════════════════════════
  static const Map<String, String> departamentos = {
    'LP': 'La Paz',
    'CB': 'Cochabamba',
    'SC': 'Santa Cruz',
    'OR': 'Oruro',
    'PT': 'Potosí',
    'TJ': 'Tarija',
    'CH': 'Chuquisaca',
    'BN': 'Beni',
    'PD': 'Pando',
  };

  // ═══════════════════════════════════════════════════════
  // 🪪 CATEGORÍAS DE LICENCIA DE CONDUCIR
  // ═══════════════════════════════════════════════════════
  static const List<String> licenciaCategorias = ['P', 'A', 'B', 'C', 'E'];
  
  static const Map<String, String> licenciaDescripcion = {
    'P': 'Vehículos particulares (hasta 4 pasajeros)',
    'A': 'Transporte público ligero (hasta 10 personas)',
    'B': 'Transporte público mediano (hasta 20 personas)',
    'C': 'Transporte público pesado (hasta 40 personas)',
    'E': 'Licencia especial - Libre (cualquier vehículo)',
  };

  // ═══════════════════════════════════════════════════════
  // 📊 ESTADOS DE TRÁMITE
  // ═══════════════════════════════════════════════════════
  static const String statusPendiente = 'pendiente';
  static const String statusEnProceso = 'en_proceso';
  static const String statusCompletado = 'completado';
  static const String statusCancelado = 'cancelado';
  static const String statusRechazado = 'rechazado';

  // ═══════════════════════════════════════════════════════
  // 💳 MÉTODOS DE PAGO
  // ═══════════════════════════════════════════════════════
  static const String payQR = 'QR';
  static const String payEfectivo = 'Efectivo';
  static const String payTransferencia = 'Transferencia';
  static const String payTarjeta = 'Tarjeta';

  // ═══════════════════════════════════════════════════════
  // 🗄️ BASE DE DATOS LOCAL (SQLite)
  // ═══════════════════════════════════════════════════════
  static const String dbName = 'smarttramites.db';
  static const int dbVersion = 1;
  
  // Tablas
  static const String tableUsers = 'users';
  static const String tableTramites = 'tramites';
  static const String tableRecordatorios = 'recordatorios';
  static const String tableComprobantes = 'comprobantes';

  // ═══════════════════════════════════════════════════════
  // 📸 IMÁGENES Y ALMACENAMIENTO
  // ═══════════════════════════════════════════════════════
  static const int maxImageSizeMB = 5;
  static const double imageQuality = 0.8;
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1080;
  static const String folderTempImages = 'temp_images';
  static const String folderDocuments = 'documents';

  // ═══════════════════════════════════════════════════════
  // 🌐 API & COMUNICACIÓN REMOTA
  // ═══════════════════════════════════════════════════════
  static const String baseUrl = 'https://api.tramitesbolivia.bo/v1';
  static const String segipApiUrl = '$baseUrl/segip/validar';  // ✅ Agregado (faltaba)
  static const String segipEndpoint = '/segip/validar';
  static const Duration apiTimeout = Duration(seconds: 15);
  static const Duration qrExpiration = Duration(minutes: 5);
  static const String apiContentType = 'application/json; charset=utf-8';
  static const String apiAccept = 'application/json';

  // Endpoints de API
  static const String endpointAuth = '/auth';
  static const String endpointUsers = '/users';
  static const String endpointTramites = '/tramites';
  static const String endpointPagos = '/pagos';

  // ═══════════════════════════════════════════════════════
  // 📄 PDF & GENERACIÓN DE DOCUMENTOS
  // ═══════════════════════════════════════════════════════
  static const String pdfFilenamePrefix = 'comprobante_';  // ✅ Agregado (faltaba)
  static const String pdfExtension = '.pdf';                // ✅ Agregado (faltaba)
  static const String pdfMimeType = 'application/pdf';

  // ═══════════════════════════════════════════════════════
  // 🔐 SEGURIDAD & AUTENTICACIÓN
  // ═══════════════════════════════════════════════════════
  static const String storageToken = 'auth_token';
  static const String storageUserId = 'user_id';
  static const String storageUserEmail = 'user_email';
  static const int maxLoginAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
  static const Duration sessionTimeout = Duration(hours: 8);

  // ═══════════════════════════════════════════════════════
  // 🔔 NOTIFICACIONES & RECORDATORIOS
  // ═══════════════════════════════════════════════════════
  static const String channelRecordatorios = 'recordatorios';
  static const String channelAlertas = 'alertas';
  static const Duration recordatorioDefault = Duration(days: 1);

  // ═══════════════════════════════════════════════════════
  // 🎨 UI & THEME
  // ═══════════════════════════════════════════════════════
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;

  // ═══════════════════════════════════════════════════════
  // 📏 DIMENSIONES & ESPACIADOS
  // ═══════════════════════════════════════════════════════
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // ═══════════════════════════════════════════════════════
  // ⏱️ TIEMPOS & DURACIONES
  // ═══════════════════════════════════════════════════════
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration debounceDuration = Duration(milliseconds: 500);
  static const Duration cacheDuration = Duration(hours: 24);

  // ═══════════════════════════════════════════════════════
  // 🌍 LOCALIZACIÓN & IDIOMA
  // ═══════════════════════════════════════════════════════
  static const String defaultLocale = 'es_BO';
  static const String defaultCurrency = 'BOB';
  static const String currencySymbol = 'Bs.';

  // ═══════════════════════════════════════════════════════
  // 🧹 LIMPIEZA & MANTENIMIENTO
  // ═══════════════════════════════════════════════════════
  static const int maxCacheItems = 100;
  static const Duration cacheCleanupInterval = Duration(days: 7);
}