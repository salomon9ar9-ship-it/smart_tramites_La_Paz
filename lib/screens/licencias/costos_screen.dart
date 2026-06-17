import 'package:flutter/material.dart';
import '../../models/licencia_model.dart';
import '../../config/app_config.dart';

class CostosScreen extends StatelessWidget {
  const CostosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tabla de Costos - Licencias')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Precios oficiales vigentes (2024-2025)',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: categoriasLicenciaBolivia.length,
                itemBuilder: (context, index) {
                  final cat = categoriasLicenciaBolivia[index];
                  return _CostoRow(categoria: cat);
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.attach_money, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Los costos incluyen derechos de emisión, examen médico y registro SENADIR. No incluye curso de manejo ni multas pendientes.',
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
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
}

class _CostoRow extends StatelessWidget {
  final LicenciaCategoria categoria;
  const _CostoRow({required this.categoria});

  @override
  Widget build(BuildContext context) {
    // Desglose simulado realista
    final base =
        double.tryParse(categoria.costo.replaceAll(RegExp(r'[^0-9.]'), '')) ??
            100;
    const medico = 80.0;
    const senadir = 45.0;
    final total = base + medico + senadir;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getColor().withValues(alpha: 0.15),
          child: Icon(Icons.directions_car, color: _getColor()),
        ),
        title: Text('Categoría ${categoria.codigo}'),
        subtitle: Text(categoria.descripcion),
        trailing: Text(
          AppConfig.formatCurrency(total),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                _CostoItem('Derechos de Emisión', base),
                _CostoItem('Certificado Médico', medico),
                _CostoItem('Registro SENADIR', senadir),
                const Divider(),
                _CostoItem('TOTAL ESTIMADO', total, isTotal: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (categoria.codigo) {
      case 'P':
        return Colors.blue;
      case 'A':
        return Colors.orange;
      case 'B':
        return Colors.teal;
      case 'C':
        return Colors.deepPurple;
      case 'E':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}

class _CostoItem extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;

  const _CostoItem(this.label, this.amount, {this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 15 : 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color:
                  isTotal ? Theme.of(context).primaryColor : Colors.grey[700],
            ),
          ),
          Text(
            AppConfig.formatCurrency(amount),
            style: TextStyle(
              fontSize: isTotal ? 15 : 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Theme.of(context).primaryColor : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
