// lib/widgets/tramite_card.dart

import 'package:flutter/material.dart';
import '../models/tramite.dart';
import '../theme/app_theme.dart';

class TramiteCard extends StatelessWidget {
  final Tramite tramite;
  final VoidCallback onTap;
  final bool compact;

  const TramiteCard({
    super.key,
    required this.tramite,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(tramite.colorEntidad);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: compact ? 4 : 6,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            // Ícono
            Container(
              width: compact ? 42 : 52,
              height: compact ? 42 : 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Center(
                child: Text(
                  tramite.iconoEntidad,
                  style: TextStyle(fontSize: compact ? 20 : 24),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tramite.nombre,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: compact ? 14 : 15,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Badge entidad
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: color.withOpacity(0.25)),
                        ),
                        child: Text(
                          tramite.entidad,
                          style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (!compact) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.timer_outlined,
                            color: AppTheme.textSecondary, size: 12),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            tramite.duracionEstimada,
                            style: const TextStyle(
                                color: AppTheme.textSecondary, fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (!compact) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.payments_outlined,
                            color: AppTheme.textSecondary, size: 12),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            tramite.costo,
                            style: const TextStyle(
                                color: AppTheme.textSecondary, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Flecha
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.chevron_right_rounded,
                  color: color.withOpacity(0.8), size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
