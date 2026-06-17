import 'package:flutter/material.dart';
import '../../models/licencia_model.dart';
import '../../config/routes.dart';

class CategoriasScreen extends StatelessWidget {
  const CategoriasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías de Licencia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () =>
                Navigator.pushNamed(context, Routes.costosLicencia),
            tooltip: 'Ver tabla de costos',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: categoriasLicenciaBolivia.length,
          itemBuilder: (context, index) {
            final cat = categoriasLicenciaBolivia[index];
            return _CategoriaCard(categoria: cat);
          },
        ),
      ),
    );
  }
}

class _CategoriaCard extends StatelessWidget {
  final LicenciaCategoria categoria;

  const _CategoriaCard({required this.categoria});

  IconData _getIcon() {
    switch (categoria.codigo) {
      case 'P':
        return Icons.directions_car;
      case 'A':
        return Icons.directions_bus;
      case 'B':
        return Icons.directions_bus_filled;
      case 'C':
        return Icons.local_shipping;
      case 'E':
        return Icons.construction;
      default:
        return Icons.category;
    }
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

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          Routes.requisitosLicencia,
          arguments: {'categoria': categoria},
        ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(_getIcon(), size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                'Categoría ${categoria.codigo}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                categoria.descripcion,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  categoria.costo,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
