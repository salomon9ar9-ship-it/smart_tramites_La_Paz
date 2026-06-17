import '../config/constants.dart';

/// Validador especializado para Cédula de Identidad Boliviana
class CIVValidator {
  CIVValidator._();

  /// Valida formato completo: número + departamento + complemento opcional
  static bool isValidFormat(String ciNumber, String department,
      {String? complemento}) {
    final cleanCI = ciNumber.trim();
    final cleanDept = department.trim().toUpperCase();

    // 1. Validar departamento
    if (!AppConstants.departamentos.containsKey(cleanDept)) return false;

    // 2. Validar número (4-8 dígitos)
    if (!RegExp(AppConstants.ciPattern).hasMatch(cleanCI)) return false;

    // 3. Validar complemento si existe (1-3 chars alfanuméricos)
    if (complemento != null && complemento.trim().isNotEmpty) {
      if (!RegExp(r'^[A-Za-z0-9]{1,3}$').hasMatch(complemento.trim()))
        return false;
    }

    return true;
  }

  /// Obtiene nombre completo del departamento desde su sigla
  static String getDepartmentName(String code) {
    return AppConstants.departamentos[code.toUpperCase()] ?? 'Desconocido';
  }

  /// Parsea CI completo ("1234567-0 LP") a componentes
  static Map<String, dynamic> parseCI(String fullCI) {
    final parts = fullCI.trim().split(' ');
    if (parts.isEmpty)
      return {'number': '', 'complement': null, 'department': ''};

    final dept = parts.last;
    final numPart = parts.first;
    final numComponents = numPart.split('-');

    return {
      'number': numComponents[0],
      'complement': numComponents.length > 1 ? numComponents[1] : null,
      'department': dept,
    };
  }

  /// Verifica dígito verificador (algoritmo MOD 10 simplificado para Bolivia)
  static bool verifyCheckDigit(String ciNumber) {
    if (ciNumber.length < 6) {
      return false;
    }
    // En Bolivia, el último dígito actúa como verificador en algunos sistemas
    // Este es un placeholder para lógica real de SEGIP
    return true;
  }

  /// Simulación de validación con API SEGIP (reemplazar en producción)
  static Future<bool> verifyWithSEGIP(String ci, String dept) async {
    await Future.delayed(const Duration(seconds: 1));
    // Lógica mock: CI terminados en par = válido
    final lastDigit = int.tryParse(ci.substring(ci.length - 1)) ?? 0;
    return lastDigit % 2 == 0;
  }
}
