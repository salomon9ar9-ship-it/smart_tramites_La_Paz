import 'dart:convert'; // Para jsonEncode/jsonDecode
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../config/app_config.dart';
import 'package:flutter/foundation.dart';

class ValidationService {
  static final ValidationService _instance = ValidationService._internal();
  factory ValidationService() => _instance;
  ValidationService._internal();

  /// Validar formato de CI boliviano
  bool validateCIFormat(String ci, String expedicion, {String? complemento}) {
    // Validar número de CI (6-7 dígitos)
    if (!RegExp(AppConstants.ciPattern).hasMatch(ci)) {
      return false;
    }

    // Validar lugar de expedición
    if (!AppConstants.departamentos.containsKey(expedicion)) {
      return false;
    }

    // Validar complemento si existe (alfanumérico, opcional)
    if (complemento != null && complemento.isNotEmpty) {
      if (!RegExp(r'^[A-Za-z0-9]{1,3}$').hasMatch(complemento)) {
        return false;
      }
    }

    return true;
  }

  /// Validar datos personales del usuario
  Map<String, String?> validateUserData({
    required String tipoDocumento,
    required String numeroDocumento,
    String? complemento,
    required String lugarExpedicion,
    required String nombres,
    required String apellidos,
    required DateTime fechaNacimiento,
    required String telefono,
    required String email,
    required String password,
  }) {
    final errors = <String, String?>{};

    // Validar tipo de documento
    if (![AppConstants.tipoDocumentoCI, AppConstants.tipoDocumentoCE]
        .contains(tipoDocumento)) {
      errors['tipoDocumento'] = 'Tipo de documento inválido';
    }

    // Validar CI/CE
    if (!validateCIFormat(numeroDocumento, lugarExpedicion,
        complemento: complemento)) {
      errors['numeroDocumento'] = 'Número de documento inválido';
    }

    // Validar nombres
    if (nombres.trim().length < 3) {
      errors['nombres'] = 'Ingrese sus nombres completos';
    }

    // Validar apellidos
    if (apellidos.trim().length < 3) {
      errors['apellidos'] = 'Ingrese sus apellidos completos';
    }

    // Validar fecha de nacimiento (mayor de 18 años)
    final hoy = DateTime.now();
    final edad = hoy.year - fechaNacimiento.year;
    if (edad < 18) {
      errors['fechaNacimiento'] = 'Debe ser mayor de 18 años';
    }

    // Validar teléfono boliviano
    if (!AppConfig.validateTelefono(telefono)) {
      errors['telefono'] = 'Teléfono inválido (8 dígitos, inicia con 6 o 7)';
    }

    // Validar email
    if (!AppConfig.validateEmail(email)) {
      errors['email'] = 'Correo electrónico inválido';
    }

    // Validar contraseña (mínimo 8 caracteres, 1 número, 1 letra)
    if (password.length < 8 ||
        !RegExp(r'(?=.*[0-9])').hasMatch(password) ||
        !RegExp(r'(?=.*[a-zA-Z])').hasMatch(password)) {
      errors['password'] = 'Mínimo 8 caracteres, con letras y números';
    }

    return errors;
  }

  /// Validar imágenes de carnet (tamaño, formato)
  Map<String, String?> validateDocumentImages({
    File? frente,
    File? atras,
    File? selfie,
  }) {
    final errors = <String, String?>{};
    const maxSize = 5 * 1024 * 1024; // 5MB
    const allowedExtensions = ['.jpg', '.jpeg', '.png'];

    void validateImage(File? image, String fieldName, String label) {
      if (image == null) {
        errors[fieldName] = '$label es requerida';
        return;
      }

      if (!image.existsSync()) {
        errors[fieldName] = 'Error al cargar $label';
        return;
      }

      final extension =
          image.path.substring(image.path.lastIndexOf('.')).toLowerCase();
      if (!allowedExtensions.contains(extension)) {
        errors[fieldName] = 'Formato no permitido (JPG, PNG)';
        return;
      }

      if (image.lengthSync() > maxSize) {
        errors[fieldName] = 'La imagen no debe superar 5MB';
        return;
      }
    }

    validateImage(frente, 'frente', 'Foto del carnet (frente)');
    validateImage(atras, 'atras', 'Foto del carnet (atrás)');
    validateImage(selfie, 'selfie', 'Selfie de validación');

    return errors;
  }

  /// Simular validación con API SEGIP
  /// En producción, reemplazar con llamada real a https://api.segip.gob.bo
  Future<bool> validateWithSEGIP({
    required String ci,
    required String expedicion,
    required String nombres,
    required String apellidos,
    required DateTime fechaNacimiento,
  }) async {
    try {
      // ⚠️ SIMULACIÓN - Reemplazar con API real de SEGIP
      await Future.delayed(const Duration(seconds: 2));

      // Lógica simulada de validación
      // En producción: hacer POST a AppConstants.segipApiUrl
      final response = await http
          .post(
            Uri.parse(AppConstants.segipApiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'ci': ci,
              'expedicion': expedicion,
              'nombres': nombres,
              'apellidos': apellidos,
              'fechaNacimiento': fechaNacimiento.toIso8601String(),
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['valido'] == true;
      }

      // Fallback para desarrollo: validar formato básico
      return _mockSEGIPValidation(ci, expedicion, nombres, apellidos);
    } catch (e) {
      debugPrint('❌ Error validando con SEGIP: $e');
      // En desarrollo, permitir validación mock
      return _mockSEGIPValidation(ci, expedicion, nombres, apellidos);
    }
  }

  /// Validación mock para desarrollo (eliminar en producción)
  bool _mockSEGIPValidation(
      String ci, String expedicion, String nombres, String apellidos) {
    // Simular que CI terminados en números pares son válidos
    final lastDigit = int.tryParse(ci.substring(ci.length - 1)) ?? 0;
    return lastDigit % 2 == 0 && nombres.length > 3 && apellidos.length > 3;
  }

  /// Validar categoría de licencia
  bool validateLicenciaCategoria(String categoria) {
    return ['P', 'A', 'B', 'C', 'E'].contains(categoria.toUpperCase());
  }

  /// Validar monto de pago
  bool validateMonto(String monto) {
    final value = double.tryParse(monto.replaceAll(',', '.'));
    return value != null && value > 0 && value <= 10000;
  }

  /// Validar archivo PDF generado
  Future<bool> validatePDF(Uint8List pdfBytes) async {
    // Verificar que sea un PDF válido (firma %PDF)
    if (pdfBytes.length < 4) return false;
    final signature = String.fromCharCodes(pdfBytes.sublist(0, 4));
    return signature == '%PDF';
  }
}
