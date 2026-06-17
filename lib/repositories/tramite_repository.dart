import '../models/tramites.dart';
import '../models/comprobante_model.dart';
import '../services/database_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

class TramiteRepository {
  static final TramiteRepository _instance = TramiteRepository._internal();
  factory TramiteRepository() => _instance;
  TramiteRepository._internal();

  final _db = DatabaseService.instance;
  final _uuid = const Uuid();

  /// 📚 Catálogo estático de trámites disponibles (Plantillas)
  static final List<Tramite> catalogoTramites = [
    const Tramite(
      id: 'cat_001',
      nombre: 'Licencia de Conducir',
      entidad: 'Tránsito',
      categoria: 'Licencia',
      descripcion:
          'Emisión y renovación de licencias de conducir P, A, B, C, E.',
      requisitos: [
        'CI original y fotocopia',
        'Carnet de Salud',
        'Formulario 100'
      ],
      costo: 'Bs. 100 - 300',
      pasos: ['Pago', 'Examen Médico', 'Examen Teórico', 'Fotografía'],
      duracionEstimada: '30 min',
      iconoEntidad: 'directions_car',
      colorEntidad: 0xFF2196F3,
    ),
    const Tramite(
      id: 'cat_002',
      nombre: 'Certificado de Antecedentes',
      entidad: 'SEGIP',
      categoria: 'Identificación',
      descripcion: 'Certificado de antecedentes penales vigente.',
      requisitos: ['CI original', 'Comprobante de pago'],
      costo: 'Bs. 40',
      pasos: ['Pago en línea', 'Solicitud web', 'Retiro'],
      duracionEstimada: '24 horas',
      iconoEntidad: 'verified_user',
      colorEntidad: 0xFF9C27B0,
    ),
    const Tramite(
      id: 'cat_003',
      nombre: 'Impuestos al Día',
      entidad: 'Impuestos Nacionales',
      categoria: 'Tributario',
      descripcion: 'Consulta y pago de impuestos.',
      requisitos: ['NIT', 'Cédula de Identidad'],
      costo: 'Variable',
      pasos: ['Consulta', 'Pago'],
      duracionEstimada: '15 min',
      iconoEntidad: 'account_balance',
      colorEntidad: 0xFF4CAF50,
    ),
  ];

  /// 📥 Guardar un nuevo trámite iniciado por el usuario
  Future<bool> iniciarTramite(String userId, String tramiteTemplateId) async {
    try {
      final template = catalogoTramites.firstWhere(
        (t) => t.id == tramiteTemplateId,
        orElse: () => throw Exception('Trámite no encontrado'),
      );

      final userTramite = Tramite(
        id: _uuid.v4(),
        nombre: template.nombre,
        entidad: template.entidad,
        categoria: template.categoria,
        descripcion: template.descripcion,
        requisitos: template.requisitos,
        costo: template.costo,
        pasos: template.pasos,
        duracionEstimada: template.duracionEstimada,
        iconoEntidad: template.iconoEntidad,
        colorEntidad: template.colorEntidad,
        usuarioId: userId,
        estado: 'iniciado',
        fechaCreacion: DateTime.now(),
      );

      // Convertir a Map antes de insertar (un solo argumento)
      return await _db.insertTramite(userTramite.toMap());
    } catch (e) {
      debugPrint('Error al iniciar trámite: $e');
      return false;
    }
  }

  /// 📋 Obtener historial de trámites del usuario
  Future<List<Tramite>> getHistorial(String userId) async {
    try {
      final List<dynamic> data = await _db.getTramitesByUser(userId);
      return data
          .map((item) => Tramite.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error en getHistorial: $e');
      return [];
    }
  }

  /// ⏰ Guardar un recordatorio
  Future<bool> crearRecordatorio(
      String userId, Recordatorio recordatorio) async {
    try {
      final newRecordatorio = Recordatorio(
        id: _uuid.v4(),
        titulo: recordatorio.titulo,
        tramiteNombre: recordatorio.tramiteNombre,
        fecha: recordatorio.fecha,
      );

      // Agregar usuarioId al map
      final recordatorioMap = newRecordatorio.toMap();
      recordatorioMap['usuarioId'] = userId;

      await _db.insertRecordatorio(recordatorioMap);
      return true;
    } catch (e) {
      debugPrint('Error en crearRecordatorio: $e');
      return false;
    }
  }

  /// ⏰ Obtener recordatorios
  Future<List<Recordatorio>> getRecordatorios(String userId,
      {bool? completado}) async {
    try {
      final List<Map<String, dynamic>> maps =
          await _db.getRecordatoriosByUser(userId, completado: completado);
      return maps.map((map) => Recordatorio.fromMap(map)).toList();
    } catch (e) {
      debugPrint('Error en getRecordatorios: $e');
      return [];
    }
  }

  /// 🧾 Generar y guardar Comprobante
  Future<Comprobante> crearComprobante({
    required String userId,
    required String tramiteId,
    required String entidad,
    required String concepto,
    required String monto,
    required String metodoPago,
    String? qrData,
    String? referencia,
  }) async {
    final comprobante = Comprobante(
      id: _uuid.v4(),
      tramiteId: tramiteId,
      usuarioId: userId,
      entidad: entidad,
      concepto: concepto,
      monto: monto,
      metodoPago: metodoPago,
      qrCodeData: qrData,
      referenciaBancaria: referencia,
      estado: 'pagado',
    );

    // Convertir a Map antes de insertar
    await _db.insertComprobante(comprobante.toMap());
    return comprobante;
  }

  /// 📋 Historial de comprobantes
  Future<List<Comprobante>> getComprobantes(String userId) async {
    try {
      final List<dynamic> data = await _db.getComprobantesByUser(userId);
      return data
          .map((item) => Comprobante.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error en getComprobantes: $e');
      return [];
    }
  }
}
