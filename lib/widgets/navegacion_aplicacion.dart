// APARTADO: Componente de la aplicación: navegación adaptativa completa de 5 módulos
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _TabSpec {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final int branchIndex;

  const _TabSpec({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.branchIndex,
  });
}

class AppNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigation({required this.navigationShell, super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _selectedVisualIndex = 0;

  static const List<_TabSpec> _tabs = [
    _TabSpec(
      label: 'Admin',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard_rounded,
      branchIndex: 0,
    ),
    _TabSpec(
      label: 'Mantenimiento',
      icon: Icons.build_outlined,
      selectedIcon: Icons.build_rounded,
      branchIndex: 1,
    ),
    _TabSpec(
      label: 'Zonas',
      icon: Icons.apartment_outlined,
      selectedIcon: Icons.apartment_rounded,
      branchIndex: 2,
    ),
    _TabSpec(
      label: 'Reportes',
      icon: Icons.assignment_outlined,
      selectedIcon: Icons.assignment_rounded,
      branchIndex: 3,
    ),
    _TabSpec(
      label: 'Ajustes',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
      branchIndex: 4,
    ),
  ];

  void _onTabTapped(int visualIndex) {
    final tab = _tabs[visualIndex];
    setState(() {
      _selectedVisualIndex = visualIndex;
    });
    widget.navigationShell.goBranch(
      tab.branchIndex,
      initialLocation: tab.branchIndex == widget.navigationShell.currentIndex,
    );
  }

  @override
  void didUpdateWidget(AppNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    final currentBranch = widget.navigationShell.currentIndex;
    for (int i = 0; i < _tabs.length; i++) {
      if (_tabs[i].branchIndex == currentBranch) {
        if (_selectedVisualIndex != i) {
          setState(() => _selectedVisualIndex = i);
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NavigationBar(
      selectedIndex: _selectedVisualIndex,
      onDestinationSelected: _onTabTapped,
      backgroundColor: theme.colorScheme.surface,
      indicatorColor: theme.colorScheme.primaryContainer,
      surfaceTintColor: theme.colorScheme.primary,
      elevation: 4,
      destinations: List.generate(_tabs.length, (i) {
        final tab = _tabs[i];
        return NavigationDestination(
          icon: Icon(tab.icon),
          selectedIcon: Icon(tab.selectedIcon),
          label: tab.label,
        );
      }),
    );
  }
}
