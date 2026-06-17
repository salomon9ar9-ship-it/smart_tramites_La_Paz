import 'package:flutter/material.dart';
import '../../models/banco_model.dart';

/// Tile seleccionable para listas de bancos
/// Muestra icono, nombre, código y estado de selección con animación suave
class BancoTile extends StatelessWidget {
  final Banco banco;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showCode;
  final double borderRadius;

  const BancoTile({
    super.key,
    required this.banco,
    this.isSelected = false,
    this.onTap,
    this.showCode = true,
    this.borderRadius = 16,
  });

  /// Icono fallback basado en código de banco
  /// Tip: En producción, reemplaza por Image.network(banco.logoUrl) si tienes URLs reales
  IconData _getBankIcon() {
    final code = banco.codigo.toUpperCase();
    if (code.contains('UNION') || code.contains('BNB')) {
      return Icons.account_balance;
    }
    if (code.contains('SOL')) return Icons.sunny;
    if (code.contains('FIE')) return Icons.handshake;
    if (code.contains('BCP')) return Icons.language;
    if (code.contains('BISA')) return Icons.shield;
    if (code.contains('GANADERO')) return Icons.agriculture;
    if (code.contains('CRECER')) return Icons.trending_up;
    return Icons.business;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: primaryColor.withValues(alpha: 0.1),
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withValues(alpha: 0.08)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: primaryColor.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getBankIcon(),
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        banco.nombre,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected ? primaryColor : Colors.black87,
                        ),
                      ),
                      if (showCode)
                        Text(
                          'Código: ${banco.codigo}',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade500),
                        ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.check, size: 14, color: Colors.white),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
