import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tramite_provider.dart';
import '../../models/licencia_model.dart';
import '../../config/routes.dart';
import '../../config/app_config.dart';

class RenovacionScreen extends StatefulWidget {
  const RenovacionScreen({super.key});

  @override
  State<RenovacionScreen> createState() => _RenovacionScreenState();
}

class _RenovacionScreenState extends State<RenovacionScreen> {
  final _formKey = GlobalKey<FormState>();
  LicenciaCategoria? _selectedCategoria;
  DateTime? _fechaVencimiento;
  bool _tieneMultas = false;
  bool _isLoading = false;

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _fechaVencimiento = picked);
  }

  Future<void> _solicitarRenovacion() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoria == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecciona una categoría')));
      return;
    }

    setState(() => _isLoading = true);

    final auth = context.read<AuthProvider>();
    final tramiteProv = context.read<TramiteProvider>();
    final userId = auth.currentUser?.id;

    if (userId == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Debes iniciar sesión')));
      return;
    }

    // Simular inicio de trámite de renovación
    final success = await tramiteProv.startNewTramite(
        userId, 'renovacion_${_selectedCategoria!.codigo}');

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushNamed(
        context,
        Routes.seleccionarBanco,
        arguments: {
          'tramite': 'Renovación Licencia ${_selectedCategoria!.codigo}',
          'monto': _selectedCategoria!.costo,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Error al iniciar la renovación. Intenta nuevamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Renovación de Licencia')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Completa los datos para iniciar tu renovación. El sistema validará tu historial y generará el comprobante de pago.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Categoría
            DropdownButtonFormField<LicenciaCategoria>(
              value: _selectedCategoria,
              decoration: const InputDecoration(
                labelText: 'Categoría a Renovar',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: categoriasLicenciaBolivia
                  .map<DropdownMenuItem<LicenciaCategoria>>((cat) {
                return DropdownMenuItem<LicenciaCategoria>(
                    value: cat,
                    child:
                        Text('Categoría ${cat.codigo} - ${cat.descripcion}'));
              }).toList(),
              onChanged: (val) => setState(() => _selectedCategoria = val),
              validator: (v) => v == null ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 16),

            // Fecha de vencimiento actual
            ListTile(
              title: Text(_fechaVencimiento == null
                  ? 'Fecha de Vencimiento Actual'
                  : AppConfig.formatDate(_fechaVencimiento!)),
              leading: const Icon(Icons.calendar_today),
              onTap: _selectDate,
              contentPadding: EdgeInsets.zero,
              trailing: const Icon(Icons.arrow_drop_down),
            ),
            if (_fechaVencimiento == null)
              const Padding(
                  padding: EdgeInsets.only(left: 48, top: 4),
                  child: Text('Fecha requerida',
                      style: TextStyle(color: Colors.red, fontSize: 12))),
            const SizedBox(height: 16),

            // Checkbox multas
            CheckboxListTile(
              title:
                  const Text('Declaro no tener multas de tránsito pendientes'),
              value: _tieneMultas,
              onChanged: (val) => setState(() => _tieneMultas = val ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const SizedBox(height: 24),
            Consumer<TramiteProvider>(
              builder: (context, tramiteProv, _) {
                return ElevatedButton(
                  onPressed: _isLoading || tramiteProv.isLoading
                      ? null
                      : _solicitarRenovacion,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isLoading || tramiteProv.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('CONTINUAR AL PAGO'),
                );
              },
            ),
            const SizedBox(height: 16),
            Consumer<TramiteProvider>(
              builder: (context, tramiteProv, _) => tramiteProv.error != null
                  ? Text(tramiteProv.error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
