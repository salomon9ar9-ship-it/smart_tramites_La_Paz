import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tramite_provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/routes.dart';
import '../../config/app_config.dart';

class PagoQRScreen extends StatefulWidget {
  const PagoQRScreen({super.key});

  @override
  State<PagoQRScreen> createState() => _PagoQRScreenState();
}

class _PagoQRScreenState extends State<PagoQRScreen> {
  Timer? _countdownTimer;
  int _secondsRemaining = 300; // 5 minutos de validez QR
  bool _isExpired = false;
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _isExpired = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _confirmarPago() async {
    setState(() => _isConfirming = true);

    final auth = context.read<AuthProvider>();
    final tramiteProv = context.read<TramiteProvider>();
    final messenger = ScaffoldMessenger.of(context);

    // Simular validación de pago exitoso
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isConfirming = false);

    final comprobante = await tramiteProv.saveComprobante(
      userId: auth.currentUser!.id,
      tramiteId: 'SIMULADO', // En producción: ID real del trámite
      concepto: tramiteProv.paymentData?['concepto'] ?? 'Pago QR',
      monto: tramiteProv.paymentData?['monto'] ?? '0.00',
      metodoPago: 'QR',
    );

    if (!mounted) return;

    if (comprobante != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Row(children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('¡Pago Exitoso!')
          ]),
          content: const Text(
              'Tu pago ha sido registrado correctamente. Puedes descargar tu comprobante.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, Routes.comprobante,
                    arguments: {'comprobante': comprobante});
              },
              child: const Text('VER COMPROBANTE'),
            ),
          ],
        ),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(content: Text('Error al guardar el comprobante.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TramiteProvider>(
      builder: (context, tramiteProv, _) {
        final data = tramiteProv.paymentData;
        if (data == null || tramiteProv.qrImage == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Pago QR')),
            body: const Center(
                child: Text(
                    'No hay datos de pago. Regresa e intenta nuevamente.')),
          );
        }

        final banco = data['banco'];
        final monto = data['monto'];
        final concepto = data['concepto'];
        final referencia = data['referencia'];
        final minutes = _secondsRemaining ~/ 60;
        final seconds = _secondsRemaining % 60;

        return PopScope(
          canPop: false, // Evitar retroceso accidental durante pago
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Escanea o Paga'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Regenerar QR',
                  onPressed: _isExpired ? () => Navigator.pop(context) : null,
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Timer
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: _isExpired
                          ? Colors.red.shade100
                          : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.timer,
                            size: 20,
                            color: _isExpired ? Colors.red : Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          _isExpired
                              ? 'QR Expirado'
                              : 'Válido por: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _isExpired ? Colors.red : Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // QR Image
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: Image.memory(tramiteProv.qrImage!,
                          width: 220, height: 220),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Payment Details
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DetailRow('Banco', banco.nombre),
                          _DetailRow('Concepto', concepto),
                          _DetailRow('Monto',
                              '${AppConfig.formatCurrency(double.tryParse(monto) ?? 0)}'),
                          _DetailRow('Referencia', referencia),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Instructions
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.amber),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Abre tu app bancaria, selecciona "Pagar con QR" y escanea este código. Luego confirma aquí.',
                            style:
                                TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Confirm Button
                  ElevatedButton.icon(
                    onPressed:
                        _isExpired || _isConfirming ? null : _confirmarPago,
                    icon: _isConfirming
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.check_circle),
                    label: const Text('YA REALICÉ EL PAGO'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: _isExpired ? Colors.grey : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar pago'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _DetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Flexible(
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14))),
        ],
      ),
    );
  }
}
