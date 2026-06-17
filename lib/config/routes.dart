import 'package:flutter/material.dart';
import 'constants.dart';

// ==========================================
// 📦 IMPORTS DE PANTALLAS
// ==========================================
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/document_validation_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/dashboard_screen.dart';
import '../screens/tramites/lista_tramites_screen.dart';
import '../screens/tramites/detalle_tramite_screen.dart';
import '../screens/tramites/nuevo_tramite_screen.dart';
import '../screens/tramites/comprobante_screen.dart';
import '../screens/licencias/categorias_screen.dart';
import '../screens/licencias/requisitos_screen.dart';
import '../screens/licencias/costos_screen.dart';
import '../screens/licencias/renovacion_screen.dart';
import '../screens/entidades/bancos_screen.dart';
import '../screens/entidades/alcaldias_screen.dart';
import '../screens/entidades/segip_screen.dart';
import '../screens/entidades/impuestos_screen.dart';
import '../screens/pagos/pago_qr_screen.dart';
import '../screens/pagos/seleccionar_banco_screen.dart';
import '../screens/pagos/historial_pagos_screen.dart';
import '../screens/perfil/perfil_screen.dart';
import '../screens/perfil/configuracion_screen.dart';
import '../models/tramites.dart';
import '../models/comprobante_model.dart';
import '../models/licencia_model.dart';

// ==========================================
// 🗺️ CONSTANTES DE RUTAS
// ==========================================

class Routes {
  Routes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String documentValidation = '/register/validation';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String listaTramites = '/tramites';
  static const String tramites = '/tramites'; // alias
  static const String detalleTramite = '/tramite/detalle';
  static const String nuevoTramite = '/tramite/nuevo';
  static const String comprobante = '/comprobante';
  static const String categoriasLicencia = '/licencias/categorias';
  static const String requisitosLicencia = '/licencias/requisitos';
  static const String costosLicencia = '/licencias/costos';
  static const String renovacionLicencia = '/licencias/renovacion';
  static const String bancos = '/entidades/bancos';
  static const String alcaldias = '/entidades/alcaldias';
  static const String segip = '/entidades/segip';
  static const String impuestos = '/entidades/impuestos';
  static const String pagoQR = '/pago/qr';
  static const String seleccionarBanco = '/pago/seleccionar-banco';
  static const String historialPagos = '/pago/historial';
  static const String perfil = '/perfil';
  static const String configuracion = '/perfil/configuracion';
}

// ==========================================
// 🔄 GENERADOR DE RUTAS
// ==========================================

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    MaterialPageRoute<T> buildRoute<T>(Widget page) {
      return MaterialPageRoute(builder: (_) => page, settings: settings);
    }

    Map<String, dynamic>? getArgs() =>
        settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case Routes.splash:
        return buildRoute(const SplashScreen());
      case Routes.login:
        return buildRoute(const LoginScreen());
      case Routes.register:
        return buildRoute(const RegisterScreen());
      case Routes.documentValidation:
        return buildRoute(const DocumentValidationScreen());
      case Routes.forgotPassword:
        return buildRoute(const ForgotPasswordScreen());
      case Routes.home:
        return buildRoute(const HomeScreen());
      case Routes.dashboard:
        return buildRoute(const DashboardScreen());
      case Routes.listaTramites:
        return buildRoute(const ListaTramitesScreen());
      case Routes.detalleTramite:
        final tramite = getArgs()?['tramite'] as Tramite?;
        if (tramite != null) {
          return buildRoute(DetalleTramiteScreen(tramite: tramite));
        }
        return buildRoute(_NotFoundScreen(routeName: settings.name));
      case Routes.nuevoTramite:
        final tramite = getArgs()?['tramite'] as Tramite?;
        if (tramite != null) {
          return buildRoute(NuevoTramiteScreen(tramite: tramite));
        }
        return buildRoute(_NotFoundScreen(routeName: settings.name));
      case Routes.comprobante:
        final comp = getArgs()?['comprobante'] as Comprobante?;
        if (comp != null) {
          return buildRoute(ComprobanteScreen(comprobante: comp));
        }
        return buildRoute(_NotFoundScreen(routeName: settings.name));
      case Routes.categoriasLicencia:
        return buildRoute(const CategoriasScreen());
      case Routes.requisitosLicencia:
        final cat = getArgs()?['categoria'] as LicenciaCategoria?;
        if (cat != null) {
          return buildRoute(RequisitosScreen(categoria: cat));
        }
        return buildRoute(_NotFoundScreen(routeName: settings.name));
      case Routes.costosLicencia:
        return buildRoute(const CostosScreen());
      case Routes.renovacionLicencia:
        return buildRoute(const RenovacionScreen());
      case Routes.bancos:
        return buildRoute(const BancosScreen());
      case Routes.alcaldias:
        return buildRoute(const AlcaldiasScreen());
      case Routes.segip:
        return buildRoute(const SegipScreen());
      case Routes.impuestos:
        return buildRoute(const ImpuestosScreen());
      case Routes.pagoQR:
        return buildRoute(const PagoQRScreen());
      case Routes.seleccionarBanco:
        final args = getArgs();
        return buildRoute(SeleccionarBancoScreen(
          prefillMonto: args?['monto'] as String?,
          prefillConcepto: args?['concepto'] as String?,
        ));
      case Routes.historialPagos:
        return buildRoute(const HistorialPagosScreen());
      case Routes.perfil:
        return buildRoute(const PerfilScreen());
      case Routes.configuracion:
        return buildRoute(const ConfiguracionScreen());
      default:
        return buildRoute(_NotFoundScreen(routeName: settings.name));
    }
  }
}

// ==========================================
// 🟦 SPLASH SCREEN
// ==========================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnAuth();
  }

  Future<void> _navigateBasedOnAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      Routes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  size: 64,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                AppConstants.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'v${AppConstants.appVersion}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// ⚠️ PANTALLA 404
// ==========================================

class _NotFoundScreen extends StatelessWidget {
  final String? routeName;
  const _NotFoundScreen({this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error de navegación')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.orange[400]),
              const SizedBox(height: 24),
              Text(
                '⚠️ Ruta no encontrada',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              if (routeName != null)
                Text(
                  '"$routeName"',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontFamily: 'monospace',
                      ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, Routes.home),
                icon: const Icon(Icons.home),
                label: const Text('Ir al Inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
