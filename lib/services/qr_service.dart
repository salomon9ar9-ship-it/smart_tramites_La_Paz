import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/banco_model.dart';
import '../models/comprobante_model.dart';

class QRService {
  static final QRService _instance = QRService._internal();
  factory QRService() => _instance;
  QRService._internal();

  /// Generar datos QR para pago bancario boliviano (estándar ABCE simplificado)
  String generateQRData({
    required String bancoCodigo,
    required String monto,
    required String concepto,
    required String referencia,
    String? telefono,
    String? email,
  }) {
    // Formato simplificado compatible con lectores QR estándar
    final buffer = StringBuffer();
    buffer.write('BANCO:$bancoCodigo|');
    buffer.write('MONTO:$monto|');
    buffer.write('CONCEPTO:$concepto|');
    buffer.write('REF:$referencia|');
    buffer.write('PAIS:BO|');
    buffer.write('CIUDAD:LA PAZ');
    return buffer.toString();
  }

  /// Generar imagen QR como Uint8List
  Future<Uint8List> generateQRImage({
    required String data,
    int size = 300,
  }) async {
    final qrCode = QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.M,
    );

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder,
        Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()));

    final painter = QrPainter.withQr(
      qr: qrCode,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Color(0xFF000000),
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Color(0xFF000000),
      ),
      gapless: true,
    );

    painter.paint(canvas, Size(size.toDouble(), size.toDouble()));

    final picture = recorder.endRecording();
    final img = await picture.toImage(size, size);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  /// Guardar QR como archivo
  Future<File> saveQRToFile({
    required Uint8List qrImage,
    required String filename,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename.png');
    await file.writeAsBytes(qrImage);
    return file;
  }

  /// Generar comprobante con QR integrado
  Future<Map<String, dynamic>> generatePaymentQR({
    required Banco banco,
    required String monto,
    required String concepto,
    required String usuarioId,
    String? referencia,
  }) async {
    final ref = referencia ?? 'TRM-${DateTime.now().millisecondsSinceEpoch}';

    final qrData = generateQRData(
      bancoCodigo: banco.codigo,
      monto: monto,
      concepto: concepto,
      referencia: ref,
    );

    final qrImageBytes = await generateQRImage(data: qrData);

    final comprobante = Comprobante(
      tramiteId: 'SIMULADO',
      usuarioId: usuarioId,
      entidad: banco.nombre,
      concepto: concepto,
      monto: monto,
      metodoPago: 'QR',
      qrCodeData: qrData,
      estado: 'pendiente',
      referenciaBancaria: ref,
    );

    return {
      'comprobante': comprobante,
      'qrImage': qrImageBytes,
      'qrData': qrData,
      'referencia': ref,
    };
  }
}
