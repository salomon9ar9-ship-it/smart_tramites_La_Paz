import 'package:flutter/material.dart';
import 'colors.dart';

/// Sistema tipográfico consistente
class AppTextStyles {
  AppTextStyles._();

  // Cambia 'Inter' por tu fuente personalizada si la agregas a pubspec.yaml
  static const String _fontFamily = 'Inter';

  // 📐 Encabezados
  static const TextStyle h1 = TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      height: 1.2,
      letterSpacing: -0.5,
      color: AppColors.textPrimary,
      fontFamily: _fontFamily);
  static const TextStyle h2 = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      height: 1.2,
      letterSpacing: -0.3,
      color: AppColors.textPrimary,
      fontFamily: _fontFamily);
  static const TextStyle h3 = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: AppColors.textPrimary,
      fontFamily: _fontFamily);
  static const TextStyle h4 = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: AppColors.textPrimary,
      fontFamily: _fontFamily);
  static const TextStyle h5 = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: AppColors.textPrimary,
      fontFamily: _fontFamily);
  static const TextStyle h6 = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: AppColors.textPrimary,
      fontFamily: _fontFamily);

  // 📖 Cuerpo
  static const TextStyle bodyLarge = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      height: 1.5,
      color: AppColors.textPrimary,
      fontFamily: _fontFamily);
  static const TextStyle bodyMedium = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      height: 1.5,
      color: AppColors.textSecondary,
      fontFamily: _fontFamily);
  static const TextStyle bodySmall = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      height: 1.4,
      color: AppColors.textSecondary,
      fontFamily: _fontFamily);

  // 🏷️ Etiquetas & Botones
  static const TextStyle button = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: 0.2,
      color: Colors.white,
      fontFamily: _fontFamily);
  static const TextStyle labelLarge = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.4,
      color: AppColors.textPrimary,
      fontFamily: _fontFamily);
  static const TextStyle labelMedium = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.4,
      color: AppColors.textSecondary,
      fontFamily: _fontFamily);
  static const TextStyle labelSmall = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 1.3,
      color: AppColors.textSecondary,
      fontFamily: _fontFamily);

  // 🔗 Interactivos
  static const TextStyle caption = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      height: 1.4,
      color: AppColors.textSecondary,
      fontFamily: _fontFamily);
  static const TextStyle overline = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      height: 1.5,
      letterSpacing: 1.0,
      color: AppColors.textSecondary,
      fontFamily: _fontFamily);
  static const TextStyle link = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.4,
      color: AppColors.primary,
      decoration: TextDecoration.underline,
      fontFamily: _fontFamily);
}
