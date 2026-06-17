import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../config/routes.dart';
import '../../config/app_config.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _telefonoCtrl;
  late TextEditingController _profesionCtrl;
  late TextEditingController _direccionCtrl;

  bool _isEditing = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _telefonoCtrl = TextEditingController(text: user?.telefono ?? '');
    _profesionCtrl = TextEditingController(text: user?.profesion ?? '');
    _direccionCtrl = TextEditingController(text: user?.direccion ?? '');
  }

  @override
  void dispose() {
    _telefonoCtrl.dispose();
    _profesionCtrl.dispose();
    _direccionCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;
    if (user == null) {
      return;
    }

    final updatedUser = user.copyWith(
      telefono: _telefonoCtrl.text.trim(),
      profesion: _profesionCtrl.text.trim(),
      direccion: _direccionCtrl.text.trim(),
    );

    final success =
        await context.read<UserProvider>().updateProfile(updatedUser);

    if (!mounted) {
      return;
    }
    setState(() => _isLoading = false);

    if (success) {
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Perfil actualizado correctamente')),
      );
    } else {
      setState(() => _errorMessage = 'Error al guardar. Intenta nuevamente.');
    }
  }

  void _cerrarSesion() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Cerrar sesión?'),
        content: const Text('Se cerrará tu sesión actual en este dispositivo.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.pushReplacementNamed(context, Routes.login);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final user = auth.currentUser;
        if (user == null)
          return const Center(child: Text('No hay sesión activa'));

        final initials = '${user.nombres[0]}${user.apellidos[0]}'.toUpperCase();
        final isVerified = user.estaVerificado;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // HEADER
              SliverAppBar(
                expandedHeight: 180,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColorDark
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.2),
                            child: Text(initials,
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                          const SizedBox(height: 10),
                          Text(user.nombreCompleto,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(isVerified ? Icons.verified : Icons.pending,
                                  size: 16,
                                  color: isVerified
                                      ? Colors.greenAccent
                                      : Colors.orangeAccent),
                              const SizedBox(width: 4),
                              Text(
                                isVerified
                                    ? 'Cuenta Verificada'
                                    : 'Verificación Pendiente',
                                style: TextStyle(
                                    color: isVerified
                                        ? Colors.greenAccent
                                        : Colors.orangeAccent,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(_isEditing ? Icons.close : Icons.edit,
                        color: Colors.white),
                    onPressed: () {
                      if (_isEditing) {
                        _telefonoCtrl.text = user.telefono;
                        _profesionCtrl.text = user.profesion;
                        _direccionCtrl.text = user.direccion;
                      }
                      setState(() => _isEditing = !_isEditing);
                    },
                  ),
                ],
              ),

              // CONTENT
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSectionCard('🪪 Documento de Identidad', [
                            _buildReadOnlyRow('Tipo', user.tipoDocumento),
                            _buildReadOnlyRow(
                                'Número',
                                AppConfig.formatCI(
                                    user.numeroDocumento, user.lugarExpedicion,
                                    complemento: user.complemento)),
                          ]),
                          const SizedBox(height: 12),
                          _buildSectionCard(' Contacto', [
                            _buildEditableRow('Teléfono', _telefonoCtrl,
                                isPhone: true),
                            _buildReadOnlyRow('Correo', user.email),
                          ]),
                          const SizedBox(height: 12),
                          _buildSectionCard('💼 Información Adicional', [
                            _buildEditableRow(
                                'Profesión/Oficio', _profesionCtrl),
                            _buildEditableRow('Dirección', _direccionCtrl,
                                maxLines: 2),
                            _buildReadOnlyRow('Fecha Nacimiento',
                                AppConfig.formatDate(user.fechaNacimiento)),
                            _buildReadOnlyRow('Estado Civil', user.estadoCivil),
                          ]),
                          const SizedBox(height: 20),
                          if (_isEditing) ...[
                            if (_errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(_errorMessage!,
                                    style: const TextStyle(color: Colors.red),
                                    textAlign: TextAlign.center),
                              ),
                            ElevatedButton.icon(
                              onPressed: _isLoading ? null : _guardarCambios,
                              icon: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white))
                                  : const Icon(Icons.save),
                              label: const Text('GUARDAR CAMBIOS'),
                              style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14)),
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              onPressed: () => setState(() {
                                _isEditing = false;
                                _errorMessage = null;
                              }),
                              icon: const Icon(Icons.cancel),
                              label: const Text('CANCELAR'),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Card(
                            color: Colors.red.shade50,
                            child: ListTile(
                              leading: Icon(Icons.logout,
                                  color: Colors.red.shade700),
                              title: const Text('Cerrar Sesión',
                                  style: TextStyle(color: Colors.red)),
                              onTap: _cerrarSesion,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          Flexible(
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildEditableRow(String label, TextEditingController ctrl,
      {bool isPhone = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          ),
          Expanded(
            child: TextFormField(
              controller: ctrl,
              enabled: _isEditing,
              keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
              maxLines: maxLines,
              decoration: InputDecoration(
                border:
                    _isEditing ? const OutlineInputBorder() : InputBorder.none,
                filled: _isEditing,
                fillColor: Colors.grey[50],
                contentPadding: _isEditing
                    ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                    : EdgeInsets.zero,
              ),
              validator: (v) {
                if (isPhone && !AppConfig.isValidPhone(v ?? ''))
                  return 'Teléfono inválido';
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
