import 'package:intl/intl.dart';

/// Utilidades para manejo, cálculo y formateo de fechas
/// Note: Named AppDateUtils to avoid conflict with Flutter's DateUtils
class AppDateUtils {
  AppDateUtils._();

  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  static bool isAdult(DateTime birthDate, {int minAge = 18}) {
    return calculateAge(birthDate) >= minAge;
  }

  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 365) {
      final y = (diff.inDays / 365).floor();
      return 'hace $y año${y > 1 ? 's' : ''}';
    }
    if (diff.inDays > 30) {
      final m = (diff.inDays / 30).floor();
      return 'hace $m mes${m > 1 ? 'es' : ''}';
    }
    if (diff.inDays > 0) return 'hace ${diff.inDays} día${diff.inDays > 1 ? 's' : ''}';
    if (diff.inHours > 0) return 'hace ${diff.inHours} hora${diff.inHours > 1 ? 's' : ''}';
    if (diff.inMinutes > 0) return 'hace ${diff.inMinutes} minuto${diff.inMinutes > 1 ? 's' : ''}';
    return 'ahora mismo';
  }

  static DateTime addBusinessDays(DateTime date, int days) {
    var result = date;
    var added = 0;
    while (added < days) {
      result = result.add(const Duration(days: 1));
      if (result.weekday >= DateTime.monday && result.weekday <= DateTime.friday) {
        added++;
      }
    }
    return result;
  }

  static bool isWithinRange(DateTime date, DateTime start, DateTime end) {
    return date.isAfter(start.subtract(const Duration(days: 1))) &&
        date.isBefore(end.add(const Duration(days: 1)));
  }

  static DateTime parseDate(String dateString, {String format = 'dd/MM/yyyy'}) {
    return DateFormat(format, 'es_BO').parse(dateString);
  }

  static (DateTime, DateTime) getMonthRange({DateTime? date}) {
    final target = date ?? DateTime.now();
    final first = DateTime(target.year, target.month, 1);
    final last = DateTime(target.year, target.month + 1, 0);
    return (first, last);
  }
}
