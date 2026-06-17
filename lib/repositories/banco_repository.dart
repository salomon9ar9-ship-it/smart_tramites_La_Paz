import '../models/banco_model.dart';
import '../services/qr_service.dart';

class BancoRepository {
  static final BancoRepository _instance = BancoRepository._internal();
  factory BancoRepository() => _instance;
  BancoRepository._internal();

  final _qrService = QRService();

  /// 🏦 Obtener lista completa de bancos bolivianos
  /// (Datos estáticos definidos en el modelo)
  List<Banco> getAllBancos() {
    return bancosBolivianos.where((b) => b.activo).toList();
  }

  /// 🔍 Buscar banco por código
  Banco? getBancoByCode(String code) {
    try {
      return bancosBolivianos.firstWhere(
        (b) => b.codigo == code,
        orElse: () => throw Exception('Banco no encontrado'),
      );
    } catch (_) {
      return null;
    }
  }

  /// 📱 Generar estructura de pago QR para un banco específico
  /// Devuelve los datos necesarios para renderizar el QR y el comprobante
  Future<Map<String, dynamic>> prepararPagoQR({
    required String bancoCodigo,
    required String monto,
    required String concepto,
    required String usuarioId,
  }) async {
    final banco = getBancoByCode(bancoCodigo);
    if (banco == null) throw Exception('Banco no válido');

    // Generar referencia única de pago
    final referencia = 'PAY-${DateTime.now().millisecondsSinceEpoch}';

    // Generar string de datos para el QR (Estándar ABCE)
    final qrDataString = _qrService.generateQRData(
      bancoCodigo: banco.codigo,
      monto: monto,
      concepto: concepto,
      referencia: referencia,
      telefono: null, // Opcional
      email: null, // Opcional
    );

    return {
      'banco': banco,
      'qrData': qrDataString,
      'referencia': referencia,
      'monto': monto,
      'concepto': concepto,
    };
  }
}
