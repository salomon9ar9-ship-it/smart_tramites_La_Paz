import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../services/camera_service.dart';
import '../services/validation_service.dart';

/// 🟦 Gestiona el perfil, documentos y validación de identidad
class UserProvider extends ChangeNotifier {
  final _repo = UserRepository();
  final _camera = CameraService();
  final _validation = ValidationService();

  UserModel? _profile;
  bool _isVerifying = false;
  String? _validationError;
  Map<String, File?> _documentPhotos = {}; // frente, atras, selfie

  // Getters
  UserModel? get profile => _profile;
  bool get isVerifying => _isVerifying;
  String? get validationError => _validationError;
  Map<String, File?> get documentPhotos => _documentPhotos;
  bool get isVerified => _profile?.estaVerificado ?? false;

  /// 📥 Cargar perfil del usuario
  Future<void> loadProfile(String userId) async {
    _profile = await _repo.getUserProfile(userId);
    notifyListeners();
  }

  /// 🔄 Actualizar datos del perfil
  Future<bool> updateProfile(UserModel updatedData) async {
    final success = await _repo.updateProfile(updatedData);
    if (success) _profile = updatedData;
    notifyListeners();
    return success;
  }

  /// 📸 Capturar fotos de validación (Carnet + Selfie)
  Future<void> captureValidationPhotos() async {
    _documentPhotos = await _camera.captureDocumentPhotos();
    notifyListeners();
  }

  /// ✅ Validar y enviar documentos para verificación
  Future<bool> validateAndSubmitDocuments(String userId) async {
    _isVerifying = true;
    _validationError = null;
    notifyListeners();

    try {
      // 1. Validar imágenes
      final imgErrors = _validation.validateDocumentImages(
        frente: _documentPhotos['frente'],
        atras: _documentPhotos['atras'],
        selfie: _documentPhotos['selfie'],
      );

      if (imgErrors.isNotEmpty) {
        _validationError = imgErrors.values.first;
        return false;
      }

      // 2. Validar datos con SEGIP (Simulado)
      if (_profile != null) {
        final segipValid = await _validation.validateWithSEGIP(
          ci: _profile!.numeroDocumento,
          expedicion: _profile!.lugarExpedicion,
          nombres: _profile!.nombres,
          apellidos: _profile!.apellidos,
          fechaNacimiento: _profile!.fechaNacimiento,
        );

        if (!segipValid) {
          _validationError =
              'Datos no coinciden con SEGIP. Verifica tu información.';
          return false;
        }
      }

      // 3. Marcar como verificado
      final verified = await _repo.verifyUser(userId);
      if (verified && _profile != null) {
        _profile = _profile!.copyWith(estaVerificado: true);
      }

      return verified;
    } catch (e) {
      _validationError = 'Error en validación: $e';
      return false;
    } finally {
      _isVerifying = false;
      notifyListeners();
    }
  }

  /// 🧹 Limpiar estado de validación
  void resetValidationState() {
    _documentPhotos.clear();
    _validationError = null;
    _isVerifying = false;
    notifyListeners();
  }
}
