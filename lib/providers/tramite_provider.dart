import '../models/user_model.dart';
import '../models/tramites.dart';
import 'package:flutter/foundation.dart';
import '../models/comprobante_model.dart';
import '../models/banco_model.dart';
import '../repositories/tramite_repository.dart';
import '../repositories/banco_repository.dart';
import '../services/qr_service.dart';
import '../services/pdf_service.dart';

/// Gestiona trámites, recordatorios, comprobantes y pagos QR
class TramiteProvider extends ChangeNotifier {
  final _tramiteRepo = TramiteRepository();
  final _bancoRepo = BancoRepository();
  final _qrService = QRService();
  final _pdfService = PDFService();

  List<Tramite> _tramites = [];
  List<Recordatorio> _recordatorios = [];
  final List<Comprobante> _comprobantes = [];
  bool _isLoading = false;
  String? _error;
  Uint8List? _generatedQRImage;
  Map<String, dynamic>? _paymentData;

  List<Tramite> get tramites => _tramites;
  List<Tramite> get catalogoTramites => TramiteRepository.catalogoTramites;
  List<Recordatorio> get recordatorios => _recordatorios;
  List<Comprobante> get comprobantes => _comprobantes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Uint8List? get qrImage => _generatedQRImage;
  Map<String, dynamic>? get paymentData => _paymentData;

  Future<void> loadTramites(String userId) async {
    _setLoading(true);
    try {
      _tramites = await _tramiteRepo.getHistorial(userId);
      _clearError();
    } catch (e) {
      _setError('Error cargando trámites: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> startNewTramite(String userId, String templateId) async {
    _setLoading(true);
    try {
      final success = await _tramiteRepo.iniciarTramite(userId, templateId);
      if (success) await loadTramites(userId);
      return success;
    } catch (e) {
      _setError('No se pudo iniciar el trámite: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadRecordatorios(String userId, {bool? completado}) async {
    _setLoading(true);
    try {
      _recordatorios =
          await _tramiteRepo.getRecordatorios(userId, completado: completado);
      _clearError();
    } catch (e) {
      _setError('Error cargando recordatorios: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addRecordatorio(String userId, Recordatorio recordatorio) async {
    _setLoading(true);
    try {
      final success =
          await _tramiteRepo.crearRecordatorio(userId, recordatorio);
      if (success) await loadRecordatorios(userId);
      return success;
    } catch (e) {
      _setError('Error creando recordatorio: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> prepareQRPayment({
    required String bancoCodigo,
    required String monto,
    required String concepto,
    required String userId,
  }) async {
    _setLoading(true);
    try {
      _paymentData = await _bancoRepo.prepararPagoQR(
        bancoCodigo: bancoCodigo,
        monto: monto,
        concepto: concepto,
        usuarioId: userId,
      );

      _generatedQRImage = await _qrService.generateQRImage(
        data: _paymentData!['qrData'],
        size: 250,
      );

      _clearError();
      return true;
    } catch (e) {
      _setError('Error generando QR: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<Comprobante?> saveComprobante({
    required String userId,
    required String tramiteId,
    required String concepto,
    required String monto,
    required String metodoPago,
  }) async {
    if (_paymentData == null) return null;

    final comprobante = await _tramiteRepo.crearComprobante(
      userId: userId,
      tramiteId: tramiteId,
      entidad: (_paymentData!['banco'] as Banco).nombre,
      concepto: concepto,
      monto: monto,
      metodoPago: metodoPago,
      qrData: _paymentData!['qrData'],
      referencia: _paymentData!['referencia'],
    );

    _comprobantes.insert(0, comprobante);
    notifyListeners();
    return comprobante;
  }

  Future<Uint8List> generateComprobantePDF(
      Comprobante comprobante, UserModel usuario) async {
    return await _pdfService.generateComprobantePDF(
      comprobante: comprobante,
      usuario: usuario,
      qrImage: _generatedQRImage,
    );
  }

  /// Preview PDF using PDFService
  Future<void> previewPDF(Uint8List pdfBytes) async {
    await _pdfService.previewPDF(pdfBytes);
  }

  void clearPaymentState() {
    _generatedQRImage = null;
    _paymentData = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String msg) {
    _error = msg;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
