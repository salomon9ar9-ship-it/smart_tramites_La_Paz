import 'package:flutter/material.dart';
import '../../models/tramites.dart';
import 'tramite_status_badge.dart';

class TramiteCard extends StatelessWidget {
  final Tramite tramite;
  final VoidCallback? onTap;
  final String? status; // Opcional: 'pendiente', 'completado', etc.

  const TramiteCard({
    super.key,
    required this.tramite,
    this.onTap,
    this.status,
  });

  /// Mapeo de iconos basado en el nombre del icono (String) guardado en el modelo
  IconData _getIconData(String iconString) {
    switch (iconString) {
      case 'directions_car':
        return Icons.directions_car;
      case 'verified_user':
        return Icons.verified_user;
      case 'account_balance':
        return Icons.account_balance;
      case 'home':
        return Icons.home;
      case 'work':
        return Icons.work;
      case 'person':
        return Icons.person;
      default:
        return Icons.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              // Icono con fondo de color
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(tramite.colorEntidad).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconData(tramite.iconoEntidad),
                  color: Color(tramite.colorEntidad),
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),

              // Información del trámite
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tramite.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.business,
                            size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          tramite.entidad,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Badge de estado (si existe)
                    if (status != null)
                      TramiteStatusBadge(status: status!)
                    else
                      Text(
                        tramite.costo,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                  ],
                ),
              ),

              // Flecha indicadora
              Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
