import 'package:flutter/material.dart';

/// Widget para mostrar el estado de un trámite con colores dinámicos
class TramiteStatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;

  const TramiteStatusBadge({
    super.key,
    required this.status,
    this.fontSize = 12,
  });

  Color _getColor() {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return Colors.orange.shade700;
      case 'en_proceso':
        return Colors.blue.shade700;
      case 'completado':
        return Colors.green.shade700;
      case 'cancelado':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  Color _getBackgroundColor() {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return Colors.orange.shade50;
      case 'en_proceso':
        return Colors.blue.shade50;
      case 'completado':
        return Colors.green.shade50;
      case 'cancelado':
        return Colors.red.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  String _getLabel() {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return 'Pendiente';
      case 'en_proceso':
        return 'En Proceso';
      case 'completado':
        return 'Completado';
      case 'cancelado':
        return 'Cancelado';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _getColor().withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: _getColor()),
          const SizedBox(width: 4),
          Text(
            _getLabel(),
            style: TextStyle(
              color: _getColor(),
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
