import 'package:flutter/material.dart';
import '../../config/routes.dart';

class ImpuestosScreen extends StatefulWidget {
  const ImpuestosScreen({super.key});

  @override
  State<ImpuestosScreen> createState() => _ImpuestosScreenState();
}

class _ImpuestosScreenState extends State<ImpuestosScreen> {
  final TextEditingController _montoCtrl = TextEditingController();
  double _it = 0.0;
  double _iva = 0.0;

  @override
  void dispose() {
    _montoCtrl.dispose();
    super.dispose();
  }

  void _calcular() {
    final monto = double.tryParse(_montoCtrl.text.replaceAll(',', '.')) ?? 0;
    setState(() {
      _it = monto * 0.03;
      _iva = monto * 0.13;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impuestos Nacionales'),
        backgroundColor: const Color(0xFF006633),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 20),
            const Text('Servicios Tributarios',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildServiceTile(Icons.assignment, 'Obtención de NIT',
                'Registro único de contribuyentes.', () {}),
            _buildServiceTile(Icons.receipt_long, 'Declaración Jurada (SIAT)',
                'Presentación mensual/anual de impuestos.', () {}),
            _buildServiceTile(Icons.print, 'Facturación en Línea',
                'Emisión de facturas y notas fiscales.', () {}),
            _buildServiceTile(
                Icons.payment,
                'Pago de Impuestos',
                'Generación de planillas y QR de pago.',
                () => Navigator.pushNamed(context, Routes.seleccionarBanco)),
            const SizedBox(height: 24),
            const Text('Calculadora Rápida (Referencial)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _montoCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Monto de Venta (Bs)',
                        prefixIcon: const Icon(Icons.calculate),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onChanged: (_) => _calcular(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('IT (3%):',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Text('Bs. ${_it.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('IVA (13%):',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Text('Bs. ${_iva.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Calculadora completa disponible próximamente')),
                      ),
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Calcular Impuestos'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.verified, color: Colors.green.shade700),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Todos los pagos generados en esta app incluyen código QR compatible con Impuestos Nacionales.',
                      style: TextStyle(color: Colors.green.shade900, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 2,
      color: const Color(0xFF006633),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.account_balance_wallet,
                  color: Color(0xFF006633), size: 32),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Impuestos Nacionales',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  SizedBox(height: 4),
                  Text(
                      'Administración tributaria y recaudación fiscal en Bolivia.',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTile(
      IconData icon, String title, String desc, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: Colors.green.shade50,
            child: Icon(icon, color: Colors.green.shade700)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(desc, maxLines: 2),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
