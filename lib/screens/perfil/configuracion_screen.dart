import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/constants.dart';
import '../../config/routes.dart';

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  bool _notificaciones = true;
  bool _temaOscuro = false;
  bool _biometria = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _cambiarPassword() async {
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cambiar Contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: oldPassCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Contraseña Actual',
                    prefixIcon: Icon(Icons.lock_outline))),
            TextField(
                controller: newPassCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Nueva Contraseña',
                    prefixIcon: Icon(Icons.lock))),
            TextField(
                controller: confirmPassCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Confirmar Contraseña',
                    prefixIcon: Icon(Icons.lock_reset))),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (newPassCtrl.text != confirmPassCtrl.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Las contraseñas no coinciden')));
                return;
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('✅ Contraseña actualizada (simulación)')));
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    oldPassCtrl.dispose();
    newPassCtrl.dispose();
    confirmPassCtrl.dispose();
  }

  void _limpiarCache() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Limpiar Caché'),
        content: const Text(
            'Se eliminarán imágenes temporales y datos en caché. ¿Continuar?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('🗑️ Caché limpiado correctamente')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }

  void _eliminarCuenta() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('⚠️ Eliminar Cuenta'),
        content: const Text(
            'Esta acción es irreversible. Se borrarán todos tus datos. ¿Estás seguro?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.pushReplacementNamed(context, Routes.login);
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Cuenta eliminada')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _SectionHeader('CUENTA'),
          ListTile(
            leading: const Icon(Icons.security, color: Colors.blue),
            title: const Text('Cambiar Contraseña'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _cambiarPassword,
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.red.shade700),
            title: const Text('Eliminar Cuenta', style: TextStyle(color: Colors.red)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
            onTap: _eliminarCuenta,
          ),
          _SectionHeader('PREFERENCIAS'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications, color: Colors.orange),
            title: const Text('Notificaciones Push'),
            subtitle: const Text('Recordatorios de trámites y vencimientos'),
            value: _notificaciones,
            onChanged: (val) => setState(() => _notificaciones = val),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode, color: Colors.purple),
            title: const Text('Modo Oscuro'),
            subtitle: const Text('Tema visual de la aplicación'),
            value: _temaOscuro,
            onChanged: (val) => setState(() => _temaOscuro = val),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.fingerprint, color: Colors.teal),
            title: const Text('Acceso Biométrico'),
            subtitle: const Text('Huella o rostro para abrir la app'),
            value: _biometria,
            onChanged: (val) => setState(() => _biometria = val),
          ),
          _SectionHeader('DATOS Y ALMACENAMIENTO'),
          ListTile(
            leading: const Icon(Icons.storage, color: Colors.grey),
            title: const Text('Limpiar Caché'),
            subtitle: const Text('Libera espacio eliminando archivos temporales'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _limpiarCache,
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.indigo),
            title: const Text('Historial de Pagos'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.pushNamed(context, Routes.historialPagos),
          ),
          _SectionHeader('ACERCA DE'),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.blueGrey),
            title: const Text('Versión de la App'),
            subtitle: Text(AppConstants.appVersion),
          ),
          ListTile(
            leading: const Icon(Icons.support_agent, color: Colors.green),
            title: const Text('Soporte y Ayuda'),
            subtitle: const Text('contacto@tramitesbolivia.bo'),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('📧 Abriendo cliente de correo...')),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Trámites Bolivia © ${DateTime.now().year}',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _SectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(title,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              letterSpacing: 1.2)),
    );
  }
}
