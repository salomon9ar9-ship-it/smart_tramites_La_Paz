import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../config/routes.dart';
import 'dart:io';

class DocumentValidationScreen extends StatefulWidget {
  const DocumentValidationScreen({super.key});

  @override
  State<DocumentValidationScreen> createState() =>
      _DocumentValidationScreenState();
}

class _DocumentValidationScreenState extends State<DocumentValidationScreen> {
  @override
  void initState() {
    super.initState();
    // Opcional: Precargar fotos si ya se tomaron antes
  }

  Future<void> _captureAndValidate() async {
    final userProvider = context.read<UserProvider>();

    // 1. Tomar fotos (o verificar si ya existen)
    // En un flujo real, aquí abrirías la cámara.
    // Para simplificar el código de UI, simulamos que el usuario presiona "Validar"
    // y el UserProvider se encarga de pedir las fotos internamente si es necesario,
    // o asumimos que ya se tomaron en pasos previos.

    // Vamos a simular el flujo: El usuario ya tomó las fotos en pantallas anteriores o
    // el UserProvider tiene lógica para pedirlas.
    // Aquí llamaremos directamente a validar asumiendo que las fotos están en el provider.

    final success =
        await userProvider.validateAndSubmitDocuments('user_id_temp');

    if (mounted) {
      if (success) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('✅ ¡Validación Exitosa!'),
            content:
                const Text('Tu identidad ha sido verificada correctamente.'),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, Routes.home),
                child: const Text('Ir al Inicio'),
              )
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(userProvider.validationError ?? 'Error al validar')),
        );
      }
    }
  }

  // Método auxiliar para abrir cámara (integrado con UserProvider)
  Future<void> _takePhoto(String type) async {
    // Aquí podrías integrar la cámara directamente o llamar a un método del provider
    // Para este ejemplo, asumimos que UserProvider maneja la lógica compleja
    // y aquí solo mostramos feedback visual
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(' Capturando $type...')),
    );
    await context.read<UserProvider>().captureValidationPhotos();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validación de Identidad')),
      body: Consumer<UserProvider>(
        builder: (context, userProv, _) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Para completar tu registro, necesitamos validar tu Cédula de Identidad.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Carnet Frente
                _buildPhotoCard(
                  context,
                  title: 'Carnet (Frente)',
                  icon: Icons.credit_card,
                  file: userProv.documentPhotos['frente'],
                  onCapture: () => _takePhoto('Carnet Frente'),
                ),
                const SizedBox(height: 16),

                // Carnet Atrás
                _buildPhotoCard(
                  context,
                  title: 'Carnet (Reverso)',
                  icon: Icons.credit_card,
                  file: userProv.documentPhotos['atras'],
                  onCapture: () => _takePhoto('Carnet Atrás'),
                ),
                const SizedBox(height: 16),

                // Selfie
                _buildPhotoCard(
                  context,
                  title: 'Selfie de Validación',
                  icon: Icons.face,
                  file: userProv.documentPhotos['selfie'],
                  onCapture: () => _takePhoto('Selfie'),
                ),

                const Spacer(),

                // Botón Validar
                ElevatedButton.icon(
                  icon: userProv.isVerifying
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.check_circle),
                  label: const Text('VALIDAR DOCUMENTOS Y FINALIZAR'),
                  onPressed: userProv.isVerifying ? null : _captureAndValidate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                  ),
                ),
                const SizedBox(height: 10),
                if (userProv.validationError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(userProv.validationError!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotoCard(BuildContext context,
      {required String title,
      required IconData icon,
      File? file,
      required VoidCallback onCapture}) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon,
            size: 40, color: file != null ? Colors.green : Colors.blueGrey),
        title: Text(title),
        subtitle: file != null
            ? const Text('✅ Imagen capturada',
                style: TextStyle(color: Colors.green))
            : const Text('Toca para tomar foto'),
        trailing: ElevatedButton(
          onPressed: onCapture,
          child: const Icon(Icons.camera_alt),
        ),
      ),
    );
  }
}
