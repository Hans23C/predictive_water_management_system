import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';

class _AlertData {
  final String id;
  final String title;
  final String zone;
  final String severity;
  final String severityLabel;
  final String time;
  final IconData icon;
  final bool acknowledged;

  const _AlertData({
    required this.id,
    required this.title,
    required this.zone,
    required this.severity,
    required this.severityLabel,
    required this.time,
    required this.icon,
    this.acknowledged = false,
  });
}

class AdminAlertsFeedWidget extends StatefulWidget {
  const AdminAlertsFeedWidget({super.key});

  @override
  State<AdminAlertsFeedWidget> createState() => _AdminAlertsFeedWidgetState();
}

class _AdminAlertsFeedWidgetState extends State<AdminAlertsFeedWidget> {
  // TODO: Replace with [Riverpod/Bloc] for production state management
  final List<_AlertData> _alerts = const [
    _AlertData(
      id: 'ALT-0891',
      title: 'Presión baja detectada',
      zone: 'Zona Z-03 — Cafetería Norte',
      severity: 'critical',
      severityLabel: 'Crítico',
      time: 'Hace 12 min',
      icon: Icons.speed_outlined,
    ),
    _AlertData(
      id: 'ALT-0890',
      title: 'Consumo inusualmente alto',
      zone: 'Zona Z-02 — Biblioteca',
      severity: 'warning',
      severityLabel: 'Advertencia',
      time: 'Hace 38 min',
      icon: Icons.water_drop_outlined,
    ),
    _AlertData(
      id: 'ALT-0889',
      title: 'Sensor sin respuesta',
      zone: 'Zona Z-06 — Campo Deportivo',
      severity: 'warning',
      severityLabel: 'Advertencia',
      time: 'Hace 1h 22min',
      icon: Icons.sensors_off_outlined,
    ),
    _AlertData(
      id: 'ALT-0888',
      title: 'Mantenimiento preventivo completado',
      zone: 'Zona Z-01 — Bloque A',
      severity: 'normal',
      severityLabel: 'Resuelto',
      time: 'Hace 3h',
      icon: Icons.check_circle_outline_rounded,
      acknowledged: true,
    ),
    _AlertData(
      id: 'ALT-0887',
      title: 'Fuga menor reparada',
      zone: 'Zona Z-04 — Bloque B',
      severity: 'normal',
      severityLabel: 'Resuelto',
      time: 'Hace 5h',
      icon: Icons.build_circle_outlined,
      acknowledged: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(_alerts.length, (i) {
          final alert = _alerts[i];
          return _AlertItem(alert: alert, isLast: i == _alerts.length - 1);
        }),
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  final _AlertData alert;
  final bool isLast;

  const _AlertItem({required this.alert, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = AppTheme.statusColor(alert.severity);
    final containerColor = AppTheme.statusContainerColor(alert.severity);

    return Column(
      children: [
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(isLast ? 0 : 0),
            bottom: Radius.circular(isLast ? 16 : 0),
          ),
          splashColor: theme.colorScheme.primary.withAlpha(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(alert.icon, size: 18, color: statusColor),
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
                              alert.title,
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          StatusBadgeWidget(
                            label: alert.severityLabel,
                            status: alert.severity,
                            fontSize: 10,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        alert.zone,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 11,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            alert.id,
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 10,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '·',
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            alert.time,
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 10,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: theme.colorScheme.outline,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 1,
            color: theme.colorScheme.outlineVariant,
            indent: 62,
          ),
      ],
    );
  }
}
