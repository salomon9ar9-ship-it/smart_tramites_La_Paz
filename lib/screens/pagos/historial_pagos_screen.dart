import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tramite_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/comprobante_model.dart';
import '../../config/app_config.dart';

// FIX: Correct State class name must match StatefulWidget name
class HistorialPagosScreen extends StatefulWidget {
  const HistorialPagosScreen({super.key});

  @override
  State<HistorialPagosScreen> createState() => _HistorialPagosScreenState();
}

class _HistorialPagosScreenState extends State<HistorialPagosScreen> {
  String _filter = 'todos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Pagos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Consumer2<AuthProvider, TramiteProvider>(
        builder: (context, auth, tramiteProv, _) {
          final userId = auth.currentUser?.id;
          if (userId == null) {
            return const Center(child: Text('Inicia sesión para ver tu historial'));
          }

          final allComprobantes = tramiteProv.comprobantes;
          final filtered = _filter == 'todos'
              ? allComprobantes
              : allComprobantes.where((c) => c.estado == _filter).toList();

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(_filter == 'todos'
                      ? 'No hay pagos registrados'
                      : 'No hay pagos con estado "$_filter"'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => tramiteProv.loadTramites(userId),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                return _ComprobanteCard(comprobante: filtered[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Filtrar por estado',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...['todos', 'pagado', 'pendiente', 'cancelado'].map((estado) {
              return ListTile(
                title: Text(AppConfig.formatEstado(estado)
                    .replaceAll(RegExp(r'[^\w\s]'), '')
                    .trim()),
                trailing: _filter == estado
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() => _filter = estado);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ComprobanteCard extends StatelessWidget {
  final Comprobante comprobante;
  const _ComprobanteCard({required this.comprobante});

  @override
  Widget build(BuildContext context) {
    final statusColor = comprobante.estado == 'pagado'
        ? Colors.green
        : comprobante.estado == 'pendiente'
            ? Colors.orange
            : Colors.red;
    final statusIcon = comprobante.estado == 'pagado'
        ? Icons.check_circle
        : comprobante.estado == 'pendiente'
            ? Icons.pending
            : Icons.cancel;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _verComprobante(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(comprobante.entidad,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(AppConfig.formatEstado(comprobante.estado),
                        style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comprobante.concepto,
                            style: TextStyle(color: Colors.grey[700])),
                        Text('Ref: ${comprobante.referenciaBancaria ?? 'N/A'}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                      ]),
                  Text(
                    '${comprobante.monto} ${comprobante.moneda}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppConfig.formatDateTime(comprobante.fechaEmision),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  TextButton.icon(
                    onPressed: () => _verComprobante(context),
                    icon: const Icon(Icons.picture_as_pdf, size: 16),
                    label: const Text('PDF'),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verComprobante(BuildContext context) async {
    final tramiteProv = context.read<TramiteProvider>();
    final auth = context.read<AuthProvider>();

    if (auth.currentUser == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Debes iniciar sesión')));
      return;
    }

    try {
      final pdfBytes = await tramiteProv.generateComprobantePDF(
          comprobante, auth.currentUser!);
      if (context.mounted) {
        await tramiteProv.previewPDF(pdfBytes);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error al abrir PDF: $e')));
      }
    }
  }
}
