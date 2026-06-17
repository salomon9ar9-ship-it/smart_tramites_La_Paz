import 'package:flutter/material.dart';

/// Paleta de colores semántica para la aplicación
class AppColors {
  AppColors._();

  // 🟦 Primarios & Acentos
  static const Color primary = Color(0xFF1565C0); // Azul institucional
  static const Color primaryLight = Color(0xFF42A5F5);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color secondary = Color(0xFF00897B); // Verde/Azul complementario
  static const Color secondaryLight = Color(0xFF4DB6AC);
  static const Color secondaryDark = Color(0xFF00695C);

  // 🌫️ Fondos & Superficies
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color backgroundDark = Color(0xFF121212);

  // 📝 Textos
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textDarkPrimary = Color(0xFFE0E0E0);
  static const Color textDarkSecondary = Color(0xFFA0A0A0);

  //  Estados & Feedback
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF2563EB);
  static const Color infoLight = Color(0xFFDBEAFE);

  // 🧱 Elementos UI
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);
  static const Color disabled = Color(0xFF9CA3AF);
  static const Color shadow = Color(0x1A000000); // 10% opacidad
}
