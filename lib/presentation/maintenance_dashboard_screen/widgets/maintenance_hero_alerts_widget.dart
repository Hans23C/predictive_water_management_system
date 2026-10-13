import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

class MaintenanceHeroAlertsWidget extends StatelessWidget {
  const MaintenanceHeroAlertsWidget({super.key});

  // Mirroring reference image: hero metric top section
  static const int _activeAlerts = 3;
  static const int _criticalAlerts = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAlerts = _activeAlerts > 0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: hasAlerts ? AppTheme.errorContainer : AppTheme.successContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasAlerts
              ? AppTheme.error.withAlpha(64)
              : AppTheme.success.withAlpha(64),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: hasAlerts
                ? AppTheme.error.withAlpha(26)
                : AppTheme.success.withAlpha(26),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_activeAlerts',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 56,
                    fontWeight: FontWeight.w700,
                    color: hasAlerts ? AppTheme.error : AppTheme.success,
                    height: 1.0,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Alertas activas ahora',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: hasAlerts
                        ? AppTheme.error.withAlpha(204)
                        : AppTheme.success.withAlpha(204),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _AlertChip(
                      count: _criticalAlerts,
                      label: 'Críticos',
                      color: AppTheme.error,
                    ),
                    const SizedBox(width: 8),
                    _AlertChip(
                      count: _activeAlerts - _criticalAlerts,
                      label: 'Advertencias',
                      color: AppTheme.warning,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: hasAlerts
                  ? AppTheme.error.withAlpha(38)
                  : AppTheme.success.withAlpha(38),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              hasAlerts
                  ? Icons.warning_amber_rounded
                  : Icons.check_circle_rounded,
              size: 36,
              color: hasAlerts ? AppTheme.error : AppTheme.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertChip extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _AlertChip({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(38),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
