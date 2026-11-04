// APARTADO: Componente de la aplicación: estructura pantalla
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import './navegacion_aplicacion.dart';

class AppScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppNavigation(navigationShell: navigationShell),
    );
  }
}
