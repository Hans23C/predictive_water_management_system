// APARTADO: Barra superior con notificaciones Liquid Glass y cierre de sesión seguro
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/rutas_aplicacion.dart';
import '../theme/tema_aplicacion.dart';
import 'boton_cerrar_sesion_animado.dart';
import 'boton_notificaciones_animado.dart';
import 'boton_tema_animado.dart';
import 'guia_rapida_dialogo.dart';

/// Botón estilizado para acciones personalizadas en la barra superior
class AppBarActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? iconColor;
  final double size;

  const AppBarActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.iconColor,
    this.size = 38,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(size / 2),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? const Color(0xFF1E2D3D).withAlpha(180)
                  : const Color(0xFFE2E8F0).withAlpha(160),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF38BDF8).withAlpha(80)
                    : const Color(0xFF0EA5E9).withAlpha(60),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? const Color(0xFF38BDF8).withAlpha(25)
                      : const Color(0xFF0284C7).withAlpha(15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: iconColor ??
                  (isDark ? const Color(0xFF38BDF8) : const Color(0xFF087FAD)),
              size: 19,
            ),
          ),
        ),
      ),
    );
  }
}

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? leading;
  final bool showHelpAction;
  final bool showThemeToggle;
  final bool showNotificationAction;
  final bool showLogoutAction;

  const AppBarWidget({
    required this.title,
    this.subtitle,
    this.actions,
    this.showBack = false,
    this.onBack,
    this.leading,
    this.showHelpAction = true,
    this.showThemeToggle = true,
    this.showNotificationAction = true,
    this.showLogoutAction = true,
    super.key,
  });

  static void showNotifications(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _NotificationLiquidSheet(),
    );
  }

  static Future<void> showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => const _LogoutGlassDialog(),
    );

    if (confirmed == true && context.mounted) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (context.mounted) context.go(AppRoutes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final actionItems = <Widget>[
      if (actions != null)
        for (final act in actions!)
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: act,
          ),
      if (showThemeToggle)
        const Padding(
          padding: EdgeInsets.only(right: 6),
          child: AnimatedThemeToggleButton(size: 38),
        ),
      if (showNotificationAction)
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: AnimatedNotificationButton(
            size: 38,
            count: 3,
            onPressed: () => showNotifications(context),
          ),
        ),
      if (showHelpAction)
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: AppBarActionButton(
            icon: Icons.help_outline_rounded,
            tooltip: 'Guía rápida del sistema',
            onPressed: () => GuiaRapidaDialogo.show(context),
          ),
        ),
      if (showLogoutAction)
        AnimatedLogoutButton(
          size: 38,
          onPressed: () => showLogoutDialog(context),
        ),
    ];

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: theme.colorScheme.primary,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
              color: theme.colorScheme.onSurface,
            )
          : leading,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
              letterSpacing: -0.2,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 1),
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: actionItems,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(subtitle != null ? 64 : kToolbarHeight);
}

/// Panel Inferior de Notificaciones Liquid Glass
class _NotificationLiquidSheet extends StatefulWidget {
  const _NotificationLiquidSheet();

  @override
  State<_NotificationLiquidSheet> createState() => _NotificationLiquidSheetState();
}

class _NotificationLiquidSheetState extends State<_NotificationLiquidSheet> {
  int _activeFilter = 0; // 0: Todas, 1: Críticas, 2: Preventivas

  static const List<Map<String, dynamic>> _alerts = [
    {
      'id': 'ALT-101',
      'title': 'BOM-003: Presión Crítica',
      'zone': 'Cafetería Central',
      'desc': 'La presión descendió a 1.8 bar. Posible fuga en el codo de impulsión principal.',
      'severity': 'critical',
      'time': 'Hace 6 min',
    },
    {
      'id': 'ALT-102',
      'title': 'BOM-002: Caudal por debajo del habitual',
      'zone': 'Edificio B (Laboratorios)',
      'desc': 'Consumo elevado continuo. Se sugiere inspeccionar las válvulas del laboratorio químico.',
      'severity': 'warning',
      'time': 'Hace 24 min',
    },
    {
      'id': 'ALT-103',
      'title': 'Cisterna al 68% de capacidad',
      'zone': 'Cisterna Principal',
      'desc': 'Nivel estable con reserva suficiente para 14 horas de autonomía.',
      'severity': 'info',
      'time': 'Hace 1 hora',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = AppTheme.isDark(context);

    final filtered = _alerts.where((a) {
      if (_activeFilter == 1) return a['severity'] == 'critical';
      if (_activeFilter == 2) return a['severity'] == 'warning';
      return true;
    }).toList();

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.78,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F1A26).withAlpha(240) : Colors.white.withAlpha(240),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: isDark ? Colors.white.withAlpha(30) : const Color(0xFF0EA5E9).withAlpha(40),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Barra de arrastre superior
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Encabezado
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.notifications_active_rounded, color: AppTheme.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Centro de Notificaciones y Alertas',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'Telemetría en tiempo real de los 6 edificios',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Selector de Filtros
              Row(
                children: [
                  _filterButton('Todas (3)', 0, theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  _filterButton('Críticas (1)', 1, AppTheme.error),
                  const SizedBox(width: 8),
                  _filterButton('Preventivas (1)', 2, AppTheme.warning),
                ],
              ),
              const SizedBox(height: 14),

              // Lista de Notificaciones
              Expanded(
                child: ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final item = filtered[i];
                    final isCrit = item['severity'] == 'critical';
                    final isWarn = item['severity'] == 'warning';
                    final color = isCrit
                        ? AppTheme.error
                        : (isWarn ? AppTheme.warning : AppTheme.info);

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF162536) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: color.withAlpha(isDark ? 80 : 50)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withAlpha(25),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isCrit ? Icons.error_rounded : (isWarn ? Icons.warning_rounded : Icons.water_drop_rounded),
                              color: color,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['title'],
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      item['time'],
                                      style: GoogleFonts.ibmPlexMono(
                                        fontSize: 10,
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['zone'],
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['desc'],
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterButton(String label, int index, Color color) {
    final isSelected = _activeFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(35) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? color : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// Diálogo de Cierre de Sesión Seguro Liquid Glass
class _LogoutGlassDialog extends StatelessWidget {
  const _LogoutGlassDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = AppTheme.isDark(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F1A26).withAlpha(230) : Colors.white.withAlpha(230),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? Colors.white.withAlpha(30) : const Color(0xFF0EA5E9).withAlpha(40),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.error.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.logout_rounded, color: AppTheme.error, size: 26),
                ),
                const SizedBox(height: 16),
                Text(
                  '¿Cerrar Sesión Segura?',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Se finalizará tu turno activo en el sistema. Podrás volver a ingresar en cualquier momento con tus credenciales o accesos demo.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.error,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'Cerrar sesión',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
