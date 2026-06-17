import 'package:flutter/material.dart';

/// Chip reutilizable para entidades (bancos, instituciones, categorías)
/// Soporta selección, iconos, estados deshabilitados y animación suave
class EntidadChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isEnabled;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool showCheckOnSelect;

  const EntidadChip({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.isSelected = false,
    this.onTap,
    this.isEnabled = true,
    this.fontSize = 13,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    this.borderRadius = 24,
    this.showCheckOnSelect = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColor = color ?? theme.colorScheme.primary;
    final isInteractive = onTap != null && isEnabled;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isInteractive ? onTap : null,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: chipColor.withValues(alpha: 0.12),
        highlightColor: chipColor.withValues(alpha: 0.06),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: padding,
          decoration: BoxDecoration(
            color: isSelected
                ? chipColor.withValues(alpha: 0.12)
                : (isEnabled ? Colors.grey.shade50 : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isSelected ? chipColor : Colors.grey.shade200,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected && isInteractive
                ? [
                    BoxShadow(
                        color: chipColor.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2))
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: fontSize + 2,
                  color: isSelected ? chipColor : Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? chipColor
                      : (isEnabled ? Colors.black87 : Colors.grey.shade500),
                ),
              ),
              if (isSelected && showCheckOnSelect) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.check_circle,
                  size: fontSize + 2,
                  color: chipColor,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
