import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tramites.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tramite_provider.dart';
import '../../config/routes.dart';

class NuevoTramiteScreen extends StatefulWidget {
  final Tramite tramite;
  const NuevoTramiteScreen({super.key, required this.tramite});

  @override
  State<NuevoTramiteScreen> createState() => _NuevoTramiteScreenState();
}

class _NuevoTramiteScreenState extends State<NuevoTramiteScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _confirmarInicio() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final auth = context.read<AuthProvider>();
    final tramiteProv = context.read<TramiteProvider>();
    final userId = auth.currentUser?.id;

    if (userId == null) {
      setState(() {
        _loading = false;
        _error = 'Debes iniciar sesión para continuar.';
      });
      return;
    }

    final success =
        await tramiteProv.startNewTramite(userId, widget.tramite.id);

    if (!mounted) return;
    setState(() => _loading = false);

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('✅ Trámite Iniciado'),
          content: Text(
              'Se ha creado el registro para "${widget.tramite.nombre}". ¿Deseas realizar el pago ahora?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Después')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.seleccionarBanco,
                    arguments: {'tramite': widget.tramite});
              },
              child: const Text('Ir a Pagar'),
            ),
          ],
        ),
      );
    } else {
      setState(
          () => _error = 'Error al guardar el trámite. Inténtalo de nuevo.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar Inicio')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.folder_open,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(widget.tramite.nombre,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                      ],
                    ),
                    const Divider(height: 24),
                    _DetailItem('Entidad', widget.tramite.entidad),
                    _DetailItem('Costo', widget.tramite.costo),
                    _DetailItem('Requisitos',
                        '${widget.tramite.requisitos.length} documentos'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Al confirmar, se generará un registro en tu historial y podrás proceder con el pago o subir documentos requeridos.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(_error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center),
              ),
            ElevatedButton(
              onPressed: _loading ? null : _confirmarInicio,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('CONFIRMAR Y GUARDAR'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _DetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
