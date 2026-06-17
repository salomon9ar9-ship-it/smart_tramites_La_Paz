import 'package:flutter/material.dart';
import '../../models/tramites.dart';
import '../../config/routes.dart';

class DetalleTramiteScreen extends StatelessWidget {
  final Tramite tramite;

  const DetalleTramiteScreen({super.key, required this.tramite});

  IconData _getIconData() {
    // iconoEntidad stores icon name string; map to IconData
    switch (tramite.iconoEntidad) {
      case 'directions_car': return Icons.directions_car;
      case 'verified_user': return Icons.verified_user;
      case 'account_balance': return Icons.account_balance;
      case 'receipt_long': return Icons.receipt_long;
      case 'credit_card': return Icons.credit_card;
      default:
        // Try parsing as codepoint for backward compat
        final code = int.tryParse(tramite.iconoEntidad);
        if (code != null) return IconData(code, fontFamily: 'MaterialIcons');
        return Icons.folder;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Color(tramite.colorEntidad),
                child: Center(
                  child: Icon(_getIconData(), size: 60, color: Colors.white),
                ),
              ),
              title: Text(tramite.entidad),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tramite.nombre,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle('Descripción'),
                  Text(tramite.descripcion,
                      style: const TextStyle(fontSize: 15, color: Colors.black87)),
                  const SizedBox(height: 20),
                  _InfoRow(Icons.attach_money, 'Costo Aproximado', tramite.costo),
                  _InfoRow(Icons.schedule, 'Duración Estimada', tramite.duracionEstimada),
                  const SizedBox(height: 20),
                  _SectionTitle('Requisitos'),
                  ...tramite.requisitos.map((req) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle, size: 20, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(child: Text(req, style: const TextStyle(fontSize: 14))),
                          ],
                        ),
                      )),
                  const SizedBox(height: 20),
                  _SectionTitle('Pasos a Seguir'),
                  ...tramite.pasos.asMap().entries.map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text('${entry.key + 1}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Text(entry.value,
                                    style: const TextStyle(fontSize: 15))),
                          ],
                        ),
                      )),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, Routes.seleccionarBanco,
                    arguments: {'tramite': tramite}),
                icon: const Icon(Icons.credit_card),
                label: const Text('Pagar con QR'),
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, Routes.nuevoTramite,
                    arguments: {'tramite': tramite}),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Iniciar Trámite'),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _SectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
    );
  }

  Widget _InfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
