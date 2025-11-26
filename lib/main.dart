import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter/ui/pages/router/router.dart';

// tes services backend
import 'package:test_flutter/di/dependency_injection.dart';

// providers de présentation (UI)
import 'package:test_flutter/presentation/providers/auth_provider.dart';
import 'package:test_flutter/presentation/providers/admin_provider.dart';

import 'core/config/env_config.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment configuration
  await EnvConfig.load();

  // 👉 initialise ton conteneur backend (Dio, services, API)
  final container = AppContainer(useDio: true);

  // Initialize services that need async setup
  await container.initialize();

  runApp(
    MultiProvider(
      providers: [
        // 👉 Injection de ton AppContainer
        Provider<AppContainer>.value(value: container),

        // 👉 Injection des services backend pour l’UI
        Provider.value(value: container.userService),
        Provider.value(value: container.adminService),
        Provider.value(value: container.authService),
        ChangeNotifierProvider.value(value: container.loginService),

        // 👉 Providers pour gérer l'état côté UI
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider(container.api)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(scaffoldBackgroundColor: Colors.transparent),
      routerConfig: router,
    );
  }
}
