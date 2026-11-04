// APARTADO: Definición de rutas y navegación de la aplicación
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pantalla_presentacion.dart';
import '../presentation/login_screen/pantalla_inicio_sesion.dart';
import '../presentation/admin_dashboard_screen/pantalla_panel_administracion.dart';
import '../presentation/maintenance_dashboard_screen/pantalla_panel_mantenimiento.dart';
import '../presentation/zones_screen/pantalla_zonas.dart';
import '../presentation/reports_screen/pantalla_reportes.dart';
import '../presentation/settings_screen/pantalla_ajustes.dart';
import '../widgets/estructura_pantalla.dart';

class AppRoutes {
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String adminDashboardScreen = '/admin-dashboard-screen';
  static const String maintenanceDashboardScreen =
      '/maintenance-dashboard-screen';
  static const String zonesScreen = '/zones-screen';
  static const String reportsScreen = '/reports-screen';
  static const String settingsScreen = '/settings-screen';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.initial,
  routes: [
    GoRoute(
      path: AppRoutes.initial,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SplashScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.loginScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 250),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Rama 0: Panel Admin
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.adminDashboardScreen,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: AdminDashboardScreen()),
            ),
          ],
        ),
        // Rama 1: Panel Mantenimiento
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.maintenanceDashboardScreen,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: MaintenanceDashboardScreen()),
            ),
          ],
        ),
        // Rama 2: Zonas y Edificios
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.zonesScreen,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ZonesScreen()),
            ),
          ],
        ),
        // Rama 3: Reportes Bidireccionales
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.reportsScreen,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ReportsScreen()),
            ),
          ],
        ),
        // Rama 4: Ajustes y Perfil
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settingsScreen,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SettingsScreen()),
            ),
          ],
        ),
      ],
    ),
  ],
);
