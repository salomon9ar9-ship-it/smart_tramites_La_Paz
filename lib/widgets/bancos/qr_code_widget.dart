import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../config/app_config.dart';

/// Widget puramente visual para mostrar QR de pago
/// Recibe estado de tiempo/expiración del padre para evitar conflictos de timers
class QRCodeWidget extends StatelessWidget {
  final Uint8List qrImage;
  final String? reference;
  final String? monto;
  final String? concepto;
  final int timeLeftSeconds;
  final bool isExpired;
  final VoidCallback? onRefresh;
  final double qrSize;

  const QRCodeWidget({
    super.key,
    required this.qrImage,
    this.reference,
    this.monto,
    this.concepto,
    this.timeLeftSeconds = 0,
    this.isExpired = false,
    this.onRefresh,
    this.qrSize = 220,
  });

  String get _formattedTime {
    final minutes = timeLeftSeconds ~/ 60;
    final seconds = timeLeftSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ⏱️ Timer & Estado
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: isExpired ? Colors.red.shade50 : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isExpired ? Icons.error_outline : Icons.timer,
                  size: 18,
                  color: isExpired ? Colors.red : Colors.blue,
                ),
                const SizedBox(width: 6),
                Text(
                  isExpired ? 'Código expirado' : 'Válido por: $_formattedTime',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isExpired ? Colors.red : Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          //  Imagen QR
          Container(
            width: qrSize,
            height: qrSize,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Image.memory(qrImage, fit: BoxFit.contain),
          ),
          const SizedBox(height: 16),

          // 📋 Información de pago
          if (monto != null || reference != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  if (monto != null)
                    _InfoRow('Monto',
                        AppConfig.formatCurrency(double.tryParse(monto!) ?? 0)),
                  if (reference != null) _InfoRow('Referencia', reference!),
                  if (concepto != null) _InfoRow('Concepto', concepto!),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // 🔄 Botón regenerar (solo si expiró)
          if (isExpired && onRefresh != null)
            OutlinedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Generar nuevo código'),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _InfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
