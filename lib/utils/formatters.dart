import 'package:intl/intl.dart';

/// Formateadores para visualización y normalización de datos
class Formatters {
  Formatters._();

  /// Formato CI Boliviano: "1234567-0 LP"
  static String ci(String number, String department, {String? complemento}) {
    final cleanNum = number.trim();
    final cleanDept = department.trim().toUpperCase();
    final cleanComp = complemento?.trim();

    if (cleanComp != null && cleanComp.isNotEmpty) {
      return '$cleanNum-$cleanComp $cleanDept';
    }
    return '$cleanNum $cleanDept';
  }

  /// Teléfono con espacio: "7123 4567"
  static String phone(String value) {
    final clean = value.trim();
    if (clean.length != 8) return clean;
    return '${clean.substring(0, 4)} ${clean.substring(4)}';
  }

  /// Moneda Boliviana: "Bs. 150,00"
  static String currency(double amount) {
    return NumberFormat.currency(
            locale: 'es_BO', symbol: 'Bs.', decimalDigits: 2)
        .format(amount);
  }

  /// Fecha corta: "28/05/2026"
  static String date(DateTime date, {String format = 'dd/MM/yyyy'}) {
    return DateFormat(format, 'es_BO').format(date);
  }

  /// Fecha y hora: "28/05/2026 14:30"
  static String dateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm', 'es_BO').format(date);
  }

  /// Capitaliza primera letra de cada palabra
  static String titleCase(String value) {
    if (value.isEmpty) return value;
    return value
        .split(' ')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  /// Elimina caracteres especiales, deja solo letras y números
  static String sanitize(String value) {
    return value.trim().replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
  }
}
