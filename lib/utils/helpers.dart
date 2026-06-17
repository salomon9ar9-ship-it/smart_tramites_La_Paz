import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

/// Funciones auxiliares para UI, seguridad y flujo de app
class Helpers {
  Helpers._();

  /// Muestra SnackBar flotante con estilo unificado
  static void showSnackBar(BuildContext context, String message,
      {bool isError = false, Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  /// Genera ID aleatorio seguro (letras + números)
  static String generateId({int length = 12}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)])
        .join();
  }

  /// Formatea tamaño de archivo: "2.5 MB"
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  /// Ejecuta operación asíncrona con manejo seguro de errores
  static Future<T?> safeAsync<T>(Future<T> Function() operation,
      {Function(dynamic error)? onError}) async {
    try {
      return await operation();
    } catch (e) {
      onError?.call(e);
      return null;
    }
  }

  /// Obtiene extensión de archivo desde ruta
  static String getFileExtension(String filePath) {
    final parts = filePath.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  /// Debounce para búsquedas o inputs frecuentes
  static VoidCallback debounce(VoidCallback action, Duration duration) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(duration, action);
    };
  }

  /// Verifica si es hora laboral (Lun-Vie 08:00-18:00)
  static bool isBusinessHour() {
    final now = DateTime.now();
    return now.weekday >= DateTime.monday &&
        now.weekday <= DateTime.friday &&
        now.hour >= 8 &&
        now.hour < 18;
  }
}
