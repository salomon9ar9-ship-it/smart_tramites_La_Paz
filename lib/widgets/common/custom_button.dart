import 'package:flutter/material.dart';

/// Tipos de botón disponibles
enum ButtonType { primary, secondary, outline, danger, ghost }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;
  final BorderRadius borderRadius;
  final bool fullWidth;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 52.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null && !isLoading;

    Color getBackgroundColor() {
      switch (type) {
        case ButtonType.primary:
          return theme.colorScheme.primary;
        case ButtonType.secondary:
          return theme.colorScheme.secondary;
        case ButtonType.outline:
          return Colors.transparent;
        case ButtonType.danger:
          return Colors.red.shade600;
        case ButtonType.ghost:
          return Colors.transparent;
      }
    }

    Color getTextColor() {
      switch (type) {
        case ButtonType.primary:
        case ButtonType.danger:
          return Colors.white;
        case ButtonType.secondary:
          return theme.colorScheme.onSecondary;
        case ButtonType.outline:
        case ButtonType.ghost:
          return theme.colorScheme.primary;
      }
    }

    BorderSide? getBorder() {
      return (type == ButtonType.outline || type == ButtonType.ghost)
          ? BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.3))
          : null;
    }

    return SizedBox(
      width: fullWidth ? (width ?? double.infinity) : width,
      height: height,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: getBackgroundColor(),
          foregroundColor: getTextColor(),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: getBorder() ?? BorderSide.none,
          ),
          elevation:
              type == ButtonType.outline || type == ButtonType.ghost ? 0 : 2,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          disabledBackgroundColor: getBackgroundColor().withValues(alpha: 0.5),
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(getTextColor()),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8)
                  ],
                  Text(
                    text,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: getTextColor()),
                  ),
                ],
              ),
      ),
    );
  }
}
