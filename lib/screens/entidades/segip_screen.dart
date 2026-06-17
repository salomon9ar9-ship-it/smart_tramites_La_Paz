import 'package:flutter/material.dart';
import '../../config/routes.dart';

class SegipScreen extends StatelessWidget {
  const SegipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SEGIP'),
        backgroundColor: const Color(0xFF004D99),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HeaderCard(),
            const SizedBox(height: 20),
            const Text('Trámites Disponibles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _ServiceCard(
              icon: Icons.credit_card,
              title: 'Cédula de Identidad',
              description: 'Emisión, duplicado y renovación de CI.',
              onTap: () => Navigator.pushNamed(context, Routes.documentValidation),
            ),
            const SizedBox(height: 10),
            _ServiceCard(
              icon: Icons.verified_user,
              title: 'Certificado de Antecedentes',
              description: 'Generación y consulta de antecedentes penales.',
              onTap: () => Navigator.pushNamed(context, Routes.listaTramites),
            ),
            const SizedBox(height: 10),
            _ServiceCard(
              icon: Icons.health_and_safety,
              title: 'Certificado de Fe de Vida',
              description: 'Constancia de existencia legal para pensiones.',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Este trámite requiere atención presencial en oficinas SEGIP.')),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Oficinas de Atención',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Card(
              child: ListTile(
                leading: Icon(Icons.location_on, color: Colors.red),
                title: Text('Oficina Central La Paz'),
                subtitle: Text('Av. Mariscal Santa Cruz N° 1450'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Puedes validar tu identidad digitalmente desde esta app para trámites en línea.',
                      style: TextStyle(color: Colors.blue.shade900, fontSize: 13),
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

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 2,
      color: Color(0xFF004D99),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.badge, color: Color(0xFF004D99), size: 28),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Servicio General de Identificación Personal',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  SizedBox(height: 4),
                  Text(
                      'Entidad encargada de la identificación y registro civil en Bolivia.',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: Icon(icon, color: Colors.blue.shade700)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description, maxLines: 2),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
