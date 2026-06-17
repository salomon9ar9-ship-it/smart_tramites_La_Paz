import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/routes.dart';
import '../../config/app_config.dart';
import '../../config/constants.dart';
import '../../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombresCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _ciCtrl = TextEditingController();
  final _complementoCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _profesionCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();

  String _selectedDepto = 'LP';
  String _selectedGenero = 'Masculino';
  String _selectedEstadoCivil = 'Soltero/a';
  DateTime? _fechaNacimiento;

  @override
  void dispose() {
    for (final c in [
      _nombresCtrl,
      _apellidosCtrl,
      _ciCtrl,
      _complementoCtrl,
      _telefonoCtrl,
      _emailCtrl,
      _passCtrl,
      _profesionCtrl,
      _direccionCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fechaNacimiento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecciona tu fecha de nacimiento')));
      return;
    }

    final userData = UserModel(
      tipoDocumento: AppConstants.docCI,
      numeroDocumento: _ciCtrl.text.trim(),
      complemento: _complementoCtrl.text.trim().isEmpty
          ? null
          : _complementoCtrl.text.trim(),
      lugarExpedicion: _selectedDepto,
      nombres: _nombresCtrl.text.trim(),
      apellidos: _apellidosCtrl.text.trim(),
      fechaNacimiento: _fechaNacimiento!,
      telefono: _telefonoCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      genero: _selectedGenero,
      estadoCivil: _selectedEstadoCivil,
      profesion: _profesionCtrl.text.trim(),
      direccion: _direccionCtrl.text.trim(),
    );

    final success = await context.read<AuthProvider>().register(userData);
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, Routes.documentValidation);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 6570)),
    );
    if (picked != null) setState(() => _fechaNacimiento = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Usuario')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('👤 Datos Personales'),
              _buildTextField(_nombresCtrl, 'Nombres',
                  icon: Icons.person, required: true),
              const SizedBox(height: 8),
              _buildTextField(_apellidosCtrl, 'Apellidos',
                  icon: Icons.person_outline, required: true),
              const SizedBox(height: 16),
              _buildSectionTitle('🪪 Cédula de Identidad'),
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: _buildTextField(_ciCtrl, 'Número de CI',
                          icon: Icons.credit_card, required: true)),
                  const SizedBox(width: 8),
                  Expanded(
                      flex: 1,
                      child: _buildTextField(_complementoCtrl, 'Comp.')),
                ],
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedDepto,
                decoration: const InputDecoration(
                    labelText: 'Lugar de Expedición',
                    border: OutlineInputBorder()),
                items: AppConstants.departamentos.entries
                    .map<DropdownMenuItem<String>>((e) {
                  return DropdownMenuItem<String>(
                      value: e.key, child: Text('${e.value} (${e.key})'));
                }).toList(),
                onChanged: (v) => setState(() => _selectedDepto = v!),
                validator: (v) => v == null ? 'Seleccione departamento' : null,
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('📅 Info Personal'),
              ListTile(
                title: Text(_fechaNacimiento == null
                    ? 'Fecha de Nacimiento *'
                    : AppConfig.formatDate(_fechaNacimiento!)),
                leading: const Icon(Icons.calendar_today),
                onTap: _selectDate,
                contentPadding: EdgeInsets.zero,
                trailing: const Icon(Icons.arrow_drop_down),
              ),
              if (_fechaNacimiento == null)
                const Text('Fecha requerida',
                    style: TextStyle(color: Colors.red, fontSize: 12)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                      child: _buildRadioGroup(
                          'Género',
                          ['Masculino', 'Femenino'],
                          _selectedGenero,
                          (v) => setState(() => _selectedGenero = v))),
                  Expanded(
                      child: _buildRadioGroup(
                          'Estado Civil',
                          ['Soltero/a', 'Casado/a', 'Divorciado/a'],
                          _selectedEstadoCivil,
                          (v) => setState(() => _selectedEstadoCivil = v))),
                ],
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('📞 Contacto y Seguridad'),
              _buildTextField(_telefonoCtrl, 'Teléfono',
                  icon: Icons.phone,
                  required: true,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 8),
              _buildTextField(_emailCtrl, 'Correo Electrónico',
                  icon: Icons.email,
                  required: true,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 8),
              _buildTextField(_passCtrl, 'Contraseña',
                  icon: Icons.lock, required: true, obscure: true),
              const SizedBox(height: 8),
              _buildTextField(_profesionCtrl, 'Profesión / Oficio',
                  icon: Icons.work),
              const SizedBox(height: 8),
              _buildTextField(_direccionCtrl, 'Dirección Domiciliaria',
                  icon: Icons.home, required: true),
              const SizedBox(height: 24),
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return ElevatedButton(
                    onPressed: auth.isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: auth.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('REGISTRAR Y CONTINUAR',
                            style: TextStyle(fontSize: 16)),
                  );
                },
              ),
              const SizedBox(height: 16),
              Consumer<AuthProvider>(
                builder: (context, auth, _) => auth.errorMessage != null
                    ? Text(auth.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label,
      {IconData? icon,
      bool required = false,
      bool obscure = false,
      TextInputType? keyboardType}) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: const OutlineInputBorder(),
      ),
      validator: (v) {
        if (required && (v == null || v.trim().isEmpty)) {
          return '$label es requerido';
        }
        if (label == 'Número de CI' &&
            v != null &&
            v.isNotEmpty &&
            !AppConfig.isValidCI(v)) {
          return 'CI inválido (4-8 dígitos)';
        }
        if (label == 'Teléfono' &&
            v != null &&
            v.isNotEmpty &&
            !AppConfig.isValidPhone(v)) {
          return 'Teléfono inválido (ej: 71234567)';
        }
        if (label == 'Correo Electrónico' &&
            v != null &&
            v.isNotEmpty &&
            !AppConfig.isValidEmail(v)) {
          return 'Correo inválido';
        }
        if (label == 'Contraseña' &&
            v != null &&
            v.isNotEmpty &&
            !AppConfig.isValidPassword(v)) {
          return 'Mín. 8 caracteres, letras y números';
        }
        return null;
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey)),
    );
  }

  Widget _buildRadioGroup(String title, List<String> options, String value,
      Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ...options.map((opt) => RadioListTile<String>(
              // ignore: deprecated_member_use
              value: opt,
              // ignore: deprecated_member_use
              groupValue: value,
              onChanged: (v) => onChanged(v!),
              title: Text(opt),
              dense: true,
              contentPadding: EdgeInsets.zero,
            )),
      ],
    );
  }
}
