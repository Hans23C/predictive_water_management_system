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
      label: 'Inicio',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      branchIndex: 0,
    ),
    _TabSpec(
      label: 'Bombas',
      icon: Icons.water_drop_outlined,
      selectedIcon: Icons.water_drop_rounded,
      branchIndex: 1,
    ),
    _TabSpec(
      label: 'Edificios',
      icon: Icons.apartment_outlined,
      selectedIcon: Icons.apartment_rounded,
      branchIndex: 2,
    ),
    _TabSpec(
      label: 'Reportar',
      icon: Icons.campaign_outlined,
      selectedIcon: Icons.campaign_rounded,
      branchIndex: 3,
    ),
    _TabSpec(
      label: 'Ayuda',
      icon: Icons.help_center_outlined,
      selectedIcon: Icons.help_center_rounded,
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
