import 'package:go_router/go_router.dart';
import 'package:test_flutter/ui/pages/login_page.dart';
import 'package:test_flutter/ui/pages/client_page.dart';
import 'package:test_flutter/ui/pages/admin_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/client',
      builder: (context, state) => const ClientPage(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminPage(),
    ),
  ],
);
