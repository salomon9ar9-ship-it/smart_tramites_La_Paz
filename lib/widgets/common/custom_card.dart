import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double elevation;
  final double borderRadius;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Border? border;
  final double? width;
  final double? height;
  final bool clipContent;

  const CustomCard({
    super.key,
    required this.child,
    this.elevation = 2,
    this.borderRadius = 16,
    this.color,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.border,
    this.width,
    this.height,
    this.clipContent = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4))
              ]
            : null,
        border: border,
      ),
      clipBehavior: clipContent ? Clip.antiAlias : Clip.none,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
