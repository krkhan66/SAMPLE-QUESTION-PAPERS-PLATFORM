import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/papers/presentation/pages/paper_list_page.dart';
import '../../features/papers/presentation/pages/paper_detail_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../app.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/papers',
                name: 'papers',
                builder: (context, state) {
                  final subject = state.uri.queryParameters['subject'];
                  final category = state.uri.queryParameters['category'];
                  return PaperListPage(
                    subject: subject,
                    category: category,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                name: 'favorites',
                builder: (context, state) => const FavoritesPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/papers/detail',
        name: 'paperDetail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final paperId = state.uri.queryParameters['id'] ?? '';
          return PaperDetailPage(paperId: paperId);
        },
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SignupPage(),
      ),
    ],
  );
}
