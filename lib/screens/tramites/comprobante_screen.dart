import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/comprobante_model.dart';
import '../../providers/tramite_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/pdf_service.dart';
import '../../config/app_config.dart';

class ComprobanteScreen extends StatefulWidget {
  final Comprobante comprobante;
  const ComprobanteScreen({super.key, required this.comprobante});

  @override
  State<ComprobanteScreen> createState() => _ComprobanteScreenState();
}

class _ComprobanteScreenState extends State<ComprobanteScreen> {
  bool _loadingPdf = false;

  Future<void> _verPDF() async {
    setState(() => _loadingPdf = true);
    try {
      final auth = context.read<AuthProvider>();
      final tramiteProv = context.read<TramiteProvider>();

      final pdfBytes = await tramiteProv.generateComprobantePDF(
          widget.comprobante, auth.currentUser!);

      if (mounted) {
        await PDFService.instance.previewPDF(pdfBytes);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error al generar PDF: $e')));
      }
    } finally {
      if (mounted) setState(() => _loadingPdf = false);
    }
  }

  Future<void> _compartirPDF() async {
    setState(() => _loadingPdf = true);
    try {
      final auth = context.read<AuthProvider>();
      final tramiteProv = context.read<TramiteProvider>();

      final pdfBytes = await tramiteProv.generateComprobantePDF(
          widget.comprobante, auth.currentUser!);

      if (mounted) {
        await PDFService.instance.sharePDF(
          pdfBytes: pdfBytes,
          filename: 'comprobante_${widget.comprobante.id}',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error al compartir: $e')));
      }
    } finally {
      if (mounted) setState(() => _loadingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final comp = widget.comprobante;
    final statusColor = comp.estado == 'pagado'
        ? Colors.green
        : (comp.estado == 'pendiente' ? Colors.orange : Colors.red);

    return Scaffold(
      appBar: AppBar(title: const Text('Comprobante de Pago')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header con estado
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor),
              ),
              child: Column(
                children: [
                  Icon(
                    comp.estado == 'pagado'
                        ? Icons.check_circle
                        : Icons.pending,
                    size: 48,
                    color: statusColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppConfig.formatEstado(comp.estado).toUpperCase(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: statusColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Detalles
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RowInfo('Entidad', comp.entidad),
                    _RowInfo('Concepto', comp.concepto),
                    _RowInfo('Monto', '${comp.monto} ${comp.moneda}'),
                    _RowInfo('Método', comp.metodoPago),
                    if (comp.referenciaBancaria != null)
                      _RowInfo('Referencia', comp.referenciaBancaria!),
                    _RowInfo(
                        'Fecha', AppConfig.formatDateTime(comp.fechaEmision)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // QR (si existe)
            Consumer<TramiteProvider>(
              builder: (context, tramiteProv, _) {
                if (tramiteProv.qrImage != null) {
                  return Column(
                    children: [
                      const Text('Código QR de Pago',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Image.memory(tramiteProv.qrImage!,
                          width: 200, height: 200),
                      const SizedBox(height: 24),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Botones de acción
            if (_loadingPdf)
              const Center(child: CircularProgressIndicator())
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _verPDF,
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('Ver PDF'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _compartirPDF,
                      icon: const Icon(Icons.share),
                      label: const Text('Compartir'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _RowInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Flexible(
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
