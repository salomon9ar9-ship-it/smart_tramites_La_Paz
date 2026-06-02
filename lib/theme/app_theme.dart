// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colores principales
  static const Color primaryColor = Color(0xFF0D47A1);
  static const Color secondaryColor = Color(0xFF00B0FF);
  static const Color accentColor = Color(0xFF00E5FF);
  
  // Colores de fondo y superficies
  static const Color darkBg = Color(0xFF0A0E1A);
  static const Color cardDark = Color(0xFF111827);
  static const Color cardMedium = Color(0xFF1E293B);
  
  // Colores de texto
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  
  // Colores de estado
  static const Color successColor = Color(0xFF00C853);
  static const Color warningColor = Color(0xFFFFD600);
  static const Color errorColor = Color(0xFFFF1744);

  // ✅ Getters con nombres ALTERNATIVOS para acceso fácil (sin duplicar)
  static Color get primary => primaryColor;
  static Color get secondary => secondaryColor;
  static Color get accent => accentColor;
  static Color get background => darkBg;
  static Color get surface => cardDark;
  static Color get text => textPrimary;              // ← Nombre alternativo
  static Color get textSec => textSecondary;         // ← Nombre alternativo
  static Color get success => successColor;
  static Color get warning => warningColor;
  static Color get error => errorColor;
  static Color get divider => Colors.white10;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardDark,
        background: darkBg,
        error: errorColor,
      ),
      
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme.copyWith(
          titleLarge: const TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
          titleMedium: const TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
          bodyLarge: const TextStyle(color: textSecondary),
          bodyMedium: const TextStyle(color: textSecondary),
        ),
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBg,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      
      // ✅ CORREGIDO: CardThemeData en lugar de CardTheme
      cardTheme: const CardThemeData(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        margin: EdgeInsets.all(8),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: secondaryColor, width: 2),
        ),
        hintStyle: const TextStyle(color: textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardDark,
        selectedItemColor: secondaryColor,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
      ),
      
      chipTheme: ChipThemeData(
        backgroundColor: cardMedium,
        disabledColor: cardMedium.withOpacity(0.5),
        selectedColor: secondaryColor,
        secondarySelectedColor: secondaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: const TextStyle(color: textPrimary, fontSize: 12),
        secondaryLabelStyle: const TextStyle(color: textPrimary, fontSize: 12),
        brightness: Brightness.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}