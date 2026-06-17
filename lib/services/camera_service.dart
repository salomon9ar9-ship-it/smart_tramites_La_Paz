import 'dart:convert'; // Para base64Encode
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../config/constants.dart';
import 'package:flutter/foundation.dart';

class CameraService {
  static final CameraService _instance = CameraService._internal();
  factory CameraService() => _instance;
  CameraService._internal();

  final ImagePicker _picker = ImagePicker();

  /// Capturar foto con cámara
  Future<File?> takePhoto({
    required ImageSource source,
    int? maxWidth,
    int? maxHeight,
    double? quality,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth?.toDouble() ?? AppConstants.maxImageWidth.toDouble(),
        maxHeight:
            maxHeight?.toDouble() ?? AppConstants.maxImageHeight.toDouble(),
        imageQuality: (quality ?? AppConstants.imageQuality * 100).round(),
      );

      if (image == null) return null;

      // Procesar imagen (rotación, compresión)
      return await _processImage(File(image.path));
    } catch (e) {
      debugPrint('❌ Error capturando imagen: $e');
      return null;
    }
  }

  /// Capturar múltiples fotos (para carnet frente/atrás)
  Future<Map<String, File?>> captureDocumentPhotos() async {
    final result = <String, File?>{};

    // Foto frente del carnet
    result['frente'] = await takePhoto(
      source: ImageSource.camera,
      maxWidth: 1280,
      maxHeight: 720,
    );

    if (result['frente'] == null) return result;

    // Foto atrás del carnet
    result['atras'] = await takePhoto(
      source: ImageSource.camera,
      maxWidth: 1280,
      maxHeight: 720,
    );

    if (result['atras'] == null) return result;

    // Selfie de validación
    result['selfie'] = await takePhoto(
      source: ImageSource.camera,
      maxWidth: 720,
      maxHeight: 720,
    );

    return result;
  }

  /// Seleccionar imagen de galería
  Future<File?> pickFromGallery({
    int? maxWidth,
    int? maxHeight,
    double? quality,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth?.toDouble() ?? AppConstants.maxImageWidth.toDouble(),
        maxHeight:
            maxHeight?.toDouble() ?? AppConstants.maxImageHeight.toDouble(),
        imageQuality: (quality ?? AppConstants.imageQuality * 100).round(),
      );

      if (image == null) return null;

      return await _processImage(File(image.path));
    } catch (e) {
      debugPrint('❌ Error seleccionando imagen: $e');
      return null;
    }
  }

  /// Procesar imagen: corregir rotación, comprimir, guardar
  Future<File> _processImage(File imageFile) async {
    // Leer imagen
    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) return imageFile;

    // Corregir orientación (EXIF)
    image = img.bakeOrientation(image);

    // Redimensionar si es muy grande
    if (image.width > AppConstants.maxImageWidth ||
        image.height > AppConstants.maxImageHeight) {
      image = img.copyResize(
        image,
        width: AppConstants.maxImageWidth,
        height: AppConstants.maxImageHeight,
        interpolation: img.Interpolation.average,
      );
    }

    // Guardar imagen procesada
    final processedBytes = img.encodeJpg(
      image,
      quality: (AppConstants.imageQuality * 100).round(),
    );

    final directory = await getApplicationDocumentsDirectory();
    final filename = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final processedFile = File('${directory.path}/$filename');

    await processedFile.writeAsBytes(processedBytes);

    // Eliminar archivo original
    if (imageFile.path != processedFile.path) {
      await imageFile.delete().catchError((_) => imageFile);
    }

    return processedFile;
  }

  /// Convertir imagen a base64 (para enviar a API)
  Future<String?> imageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      debugPrint('❌ Error convirtiendo a base64: $e');
      return null;
    }
  }

  /// Validar que la imagen contenga un rostro (básico)
  /// En producción, usar ML Kit o API de reconocimiento facial
  Future<bool> validateHasFace(File imageFile) async {
    // Simulación: verificar dimensiones mínimas
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return false;

      // Rostro típico: relación aspecto ~1:1.3, mínimo 200x200px
      final aspectRatio = image.width / image.height;
      return image.width >= 200 &&
          image.height >= 200 &&
          aspectRatio >= 0.7 &&
          aspectRatio <= 1.5;
    } catch (e) {
      return false;
    }
  }

  /// Validar que la imagen sea de un documento (básico)
  Future<bool> validateIsDocument(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return false;

      // Documento típico: rectangular, relación aspecto ~1.6:1 (carnet)
      final aspectRatio = image.width / image.height;
      return image.width >= 400 &&
          image.height >= 250 &&
          aspectRatio >= 1.4 &&
          aspectRatio <= 2.0;
    } catch (e) {
      return false;
    }
  }

  /// Obtener información de la imagen
  Future<Map<String, dynamic>> getImageInfo(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    return {
      'width': image?.width ?? 0,
      'height': image?.height ?? 0,
      'size': await imageFile.length(),
      'path': imageFile.path,
      'extension': imageFile.path.split('.').last.toLowerCase(),
    };
  }

  /// Limpiar imágenes temporales
  Future<void> cleanupTempImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync();

      for (var file in files) {
        if (file is File &&
            file.path.contains('img_') &&
            (file.path.endsWith('.jpg') || file.path.endsWith('.png'))) {
          // Eliminar imágenes mayores a 24 horas
          final stat = await file.stat();
          final age = DateTime.now().difference(stat.modified);

          if (age.inHours > 24) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error limpiando imágenes: $e');
    }
  }
}
