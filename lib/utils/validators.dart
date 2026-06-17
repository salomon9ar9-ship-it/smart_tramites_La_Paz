
/// Validadores genéricos reutilizables para TextFormField.validator
class Validators {
  Validators._();

  /// Campo obligatorio
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName es requerido';
    return null;
  }

  /// Correo electrónico válido
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(value) ? null : 'Correo electrónico inválido';
  }

  /// Teléfono boliviano (8 dígitos, inicia con 6 o 7)
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final regex = RegExp(r'^[67]\d{7}$');
    return regex.hasMatch(value)
        ? null
        : 'Teléfono inválido (8 dígitos, inicia con 6 o 7)';
  }

  /// Contraseña segura (min 8 chars, 1 número, 1 mayúscula)
  static String? passwordStrength(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length < 8) {
      return 'Mínimo 8 caracteres';
    }
    if (!RegExp(r'[0-9]').hasMatch(value))
      return 'Debe contener al menos un número';
    if (!RegExp(r'[A-Z]').hasMatch(value))
      return 'Debe contener al menos una mayúscula';
    return null;
  }

  /// Longitud mínima
  static String? minLength(String? value, int min, String fieldName) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return value.length >= min
        ? null
        : '$fieldName debe tener al menos $min caracteres';
  }

  /// Valor numérico
  static String? numeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return double.tryParse(value.trim()) != null
        ? null
        : '$fieldName debe ser numérico';
  }

  /// Confirmación de campo (ej: contraseña)
  static String? matchField(
      String? value, String? matchValue, String fieldName) {
    if (value == null || matchValue == null) {
      return null;
    }
    return value.trim() == matchValue.trim() ? null : '$fieldName no coinciden';
  }
}
