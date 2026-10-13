import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/login_screen/login_screen.dart';
import '../presentation/admin_dashboard_screen/admin_dashboard_screen.dart';
import '../presentation/maintenance_dashboard_screen/maintenance_dashboard_screen.dart';
import '../widgets/app_scaffold.dart';

class AppRoutes {
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String adminDashboardScreen = '/admin-dashboard-screen';
  static const String maintenanceDashboardScreen =
      '/maintenance-dashboard-screen';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.initial,
  routes: [
    GoRoute(
      path: AppRoutes.initial,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const _InitialRedirectScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 280),
      ),
    ),
    GoRoute(
      path: AppRoutes.loginScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0.04, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 280),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.adminDashboardScreen,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: AdminDashboardScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.maintenanceDashboardScreen,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: MaintenanceDashboardScreen()),
            ),
          ],
        ),
      ],
    ),
  ],
);

class _InitialRedirectScreen extends StatefulWidget {
  const _InitialRedirectScreen();

  @override
  State<_InitialRedirectScreen> createState() => _InitialRedirectScreenState();
}

class _InitialRedirectScreenState extends State<_InitialRedirectScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // TODO: Replace with secure_storage for production token management
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('session_token');
    final role = prefs.getString('user_role');

    if (!mounted) return;

    if (token != null && role != null) {
      if (role == 'administrador_general') {
        context.go(AppRoutes.adminDashboardScreen);
      } else {
        context.go(AppRoutes.maintenanceDashboardScreen);
      }
    } else {
      context.go(AppRoutes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
