import 'package:flutter/material.dart';

// Datos locales de ejemplo. En producción, esto vendría de una API o base de datos.
const List<Map<String, String>> _alcaldias = [
  {
    'nombre': 'Gobierno Autónomo Municipal de La Paz',
    'depto': 'La Paz',
    'telefono': '(2) 297-2000',
    'servicios': 'Patentes, Licencias, Catastro, Multas'
  },
  {
    'nombre': 'Gobierno Autónomo Municipal de Santa Cruz',
    'depto': 'Santa Cruz',
    'telefono': '(3) 339-8000',
    'servicios': 'Impuestos municipales, Permisos, Catastro'
  },
  {
    'nombre': 'Gobierno Autónomo Municipal de Cochabamba',
    'depto': 'Cochabamba',
    'telefono': '(4) 425-3000',
    'servicios': 'Trámites vecinales, Impuestos, Registro Civil'
  },
  {
    'nombre': 'Gobierno Autónomo Municipal de El Alto',
    'depto': 'La Paz',
    'telefono': '(2) 284-2000',
    'servicios': 'Patentes, Multas, Licencias de funcionamiento'
  },
  {
    'nombre': 'Gobierno Autónomo Municipal de Sucre',
    'depto': 'Chuquisaca',
    'telefono': '(4) 645-2000',
    'servicios': 'Catastro, Impuestos, Trámites administrativos'
  },
  {
    'nombre': 'Gobierno Autónomo Municipal de Oruro',
    'depto': 'Oruro',
    'telefono': '(2) 525-2000',
    'servicios': 'Patentes, Licencias, Registro'
  },
  {
    'nombre': 'Gobierno Autónomo Municipal de Tarija',
    'depto': 'Tarija',
    'telefono': '(4) 664-2000',
    'servicios': 'Impuestos municipales, Catastro, Permisos'
  },
  {
    'nombre': 'Gobierno Autónomo Municipal de Potosí',
    'depto': 'Potosí',
    'telefono': '(2) 622-2000',
    'servicios': 'Patentes, Multas, Trámites vecinales'
  },
  {
    'nombre': 'Gobierno Autónomo Municipal de Trinidad',
    'depto': 'Beni',
    'telefono': '(3) 462-2000',
    'servicios': 'Catastro, Impuestos, Registro'
  },
  {
    'nombre': 'Gobierno Autónomo Municipal de Cobija',
    'depto': 'Pando',
    'telefono': '(3) 842-2000',
    'servicios': 'Patentes, Licencias, Administración'
  },
];

class AlcaldiasScreen extends StatefulWidget {
  const AlcaldiasScreen({super.key});

  @override
  State<AlcaldiasScreen> createState() => _AlcaldiasScreenState();
}

class _AlcaldiasScreenState extends State<AlcaldiasScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _alcaldias
        .where((a) =>
            a['nombre']!.toLowerCase().contains(_query.toLowerCase()) ||
            a['depto']!.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Alcaldías / GAM')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por ciudad o departamento...',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (val) => setState(() => _query = val.trim()),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No se encontraron alcaldías'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final alc = filtered[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ExpansionTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.orange,
                            child:
                                Icon(Icons.location_city, color: Colors.white),
                          ),
                          title: Text(alc['nombre']!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('Departamento: ${alc['depto']}'),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _InfoRow(Icons.phone, 'Teléfono',
                                      alc['telefono']!),
                                  const SizedBox(height: 6),
                                  _InfoRow(
                                      Icons.assignment,
                                      'Servicios Principales',
                                      alc['servicios']!),
                                  const SizedBox(height: 12),
                                  FilledButton.icon(
                                    onPressed: () =>
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Próximamente: Enlace a portal oficial')),
                                    ),
                                    icon: const Icon(Icons.open_in_new),
                                    label: const Text('Visitar Portal Oficial'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _InfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text('$label: ',
            style: TextStyle(
                color: Colors.grey[700], fontWeight: FontWeight.w500)),
        Flexible(
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w600))),
      ],
    );
  }
}
