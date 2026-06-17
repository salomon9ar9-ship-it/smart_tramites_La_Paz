// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// ✅ Theme
import 'theme/app_theme.dart';

// ✅ Config & Routes
import 'config/routes.dart';

// ✅ Providers
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/tramite_provider.dart';

// ✅ Data initialization
import 'data/local/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar preferencias
  await Preferences().init();

  // Configurar orientación vertical
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Configurar barra de estado
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TramiteProvider()),
      ],
      child: const SmartTramitesApp(),
    ),
  );
}

class SmartTramitesApp extends StatelessWidget {
  const SmartTramitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartTrámites La Paz',
      debugShowCheckedModeBanner: false,

      // Tema claro y oscuro
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      // Enrutamiento centralizado
      initialRoute: Routes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
