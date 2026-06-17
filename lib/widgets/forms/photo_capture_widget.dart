import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/camera_service.dart';

/// Widget para capturar o seleccionar imágenes con vista previa
class PhotoCaptureWidget extends FormField<File?> {
  PhotoCaptureWidget({
    super.key,
    super.initialValue,
    super.validator,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    required String title,
    IconData? icon,
    double height = 140,
    bool allowGallery = true,
    bool allowCamera = true,
  }) : super(
          builder: (FormFieldState<File?> state) {
            return _PhotoCaptureContent(
              state: state as _PhotoCaptureState,
              title: title,
              icon: icon ?? Icons.image,
              height: height,
              allowGallery: allowGallery,
              allowCamera: allowCamera,
            );
          },
        );

  @override
  FormFieldState<File?> createState() => _PhotoCaptureState();
}

class _PhotoCaptureState extends FormFieldState<File?> {
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _isLoading = true);
    try {
      final file = await CameraService().takePhoto(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        quality: 0.8,
      );
      if (file != null) didChange(file);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.purple),
              title: const Text('Galería'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void clearImage() {
    didChange(null);
  }
}

class _PhotoCaptureContent extends StatelessWidget {
  final _PhotoCaptureState state;
  final String title;
  final IconData icon;
  final double height;
  final bool allowGallery;
  final bool allowCamera;

  const _PhotoCaptureContent({
    required this.state,
    required this.title,
    required this.icon,
    required this.height,
    required this.allowGallery,
    required this.allowCamera,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = state.value != null;
    final isError = state.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => state._showSourceDialog(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              border: Border.all(
                  color: isError
                      ? Colors.red
                      : theme.colorScheme.primary.withValues(alpha: 0.3),
                  width: isError ? 2 : 1),
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade50,
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(state.value!, fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Colors.transparent,
                                Colors.black54,
                              ])),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: state.clearImage,
                            style: IconButton.styleFrom(
                                backgroundColor: Colors.black38),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: state._isLoading
                        ? const CircularProgressIndicator()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(icon, size: 40, color: Colors.grey.shade400),
                              const SizedBox(height: 8),
                              Text('Toca para agregar',
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 13)),
                            ],
                          ),
                  ),
          ),
        ),
        if (isError)
          Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(state.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12))),
      ],
    );
  }
}
