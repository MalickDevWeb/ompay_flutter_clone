import 'package:go_router/go_router.dart';
import 'package:test_flutter/ui/pages/login_page.dart';
import 'package:test_flutter/ui/pages/client_page.dart';
import 'package:test_flutter/ui/pages/admin_page.dart';
import 'package:test_flutter/ui/pages/fournisseur_page.dart';
import 'package:test_flutter/services/login_service.dart';
import 'package:provider/provider.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(loginService: context.read<LoginService>()),
    ),
    GoRoute(
      path: '/client',
      builder: (context, state) => const ClientPage(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminPage(),
    ),
    GoRoute(
      path: '/fournisseur',
      builder: (context, state) => const FournisseurPage(),
    ),
  ],
);
