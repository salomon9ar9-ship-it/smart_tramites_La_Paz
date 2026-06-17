import 'package:flutter/material.dart';
import '../../models/licencia_model.dart';

class RequisitosScreen extends StatelessWidget {
  final LicenciaCategoria categoria;

  const RequisitosScreen({super.key, required this.categoria});

  // Requisitos estáticos por normativa boliviana vigente
  List<String> _getRequisitos() {
    final base = [
      'Cédula de Identidad vigente (original y fotocopia)',
      'Formulario 100 llenado y firmado',
      'Certificado médico oficial (oftalmológico y psicológico)',
      'Curso de manejo aprobado (SENADIR)',
      'Fotografía 3x3 fondo blanco (2 unidades)',
      'Comprobante de pago de derechos de emisión',
    ];

    switch (categoria.codigo) {
      case 'P':
        return [...base, 'Examen teórico y práctico de manejo vehicular'];
      case 'A':
        return [
          ...base,
          'Certificado de antecedentes penales vigente',
          'Examen práctico en vehículo de transporte'
        ];
      case 'B':
        return [
          ...base,
          'Certificado de antecedentes penales vigente',
          'Examen práctico en bus/micro',
          'Constancia de experiencia en transporte'
        ];
      case 'C':
        return [
          ...base,
          'Certificado de antecedentes penales vigente',
          'Examen práctico en camión/bus pesado',
          'Constancia de experiencia mínima 2 años'
        ];
      case 'E':
        return [
          ...base,
          'Licencia categoría B o C vigente',
          'Examen especializado en maquinaria pesada',
          'Certificado de seguridad industrial'
        ];
      default:
        return base;
    }
  }

  @override
  Widget build(BuildContext context) {
    final requisitos = _getRequisitos();
    final color = _getColorByCategoria();

    return Scaffold(
      appBar: AppBar(
        title: Text('Requisitos - Categoría ${categoria.codigo}'),
        backgroundColor: color,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoCard(categoria),
            const SizedBox(height: 20),
            const Text(
              'Documentación Requerida',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...requisitos.asMap().entries.map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, size: 16, color: color),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(e.value,
                            style: const TextStyle(fontSize: 14))),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.amber.shade800),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Los requisitos pueden variar según la oficina de tránsito municipal. Verifica con tu alcaldía local.',
                      style:
                          TextStyle(fontSize: 12, color: Colors.amber.shade900),
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

  Color _getColorByCategoria() {
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

class _InfoCard extends StatelessWidget {
  final LicenciaCategoria cat;
  const _InfoCard(this.cat);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(cat.descripcion,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))),
              ],
            ),
            const Divider(height: 24),
            _Row('Tipo de Vehículo', cat.tipoVehiculo),
            _Row('Capacidad Máx.', '${cat.capacidadMaxima} personas'),
            _Row('Costo Aprox.', cat.costo),
            _Row('Validez', cat.duracionValidez),
          ],
        ),
      ),
    );
  }

  Widget _Row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}
