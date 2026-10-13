import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

class _SummaryData {
  final String value;
  final String unit;
  final String label;
  final String dateRange;
  final IconData icon;
  final Color iconColor;
  final Color containerColor;

  const _SummaryData({
    required this.value,
    required this.unit,
    required this.label,
    required this.dateRange,
    required this.icon,
    required this.iconColor,
    required this.containerColor,
  });
}

class MaintenanceSummaryCardsWidget extends StatelessWidget {
  const MaintenanceSummaryCardsWidget({super.key});

  // Mirrors reference image's horizontal-scroll summary cards below chart
  static const List<_SummaryData> _summaries = [
    _SummaryData(
      value: '14',
      unit: 'incidentes',
      label: 'Turno anterior',
      dateRange: '11 Oct — 06:00',
      icon: Icons.build_outlined,
      iconColor: AppTheme.primary,
      containerColor: Color(0xFFE0F2F1),
    ),
    _SummaryData(
      value: '248.2',
      unit: 'm³',
      label: 'Consumo hoy',
      dateRange: '12 Oct — Actual',
      icon: Icons.water_drop_outlined,
      iconColor: AppTheme.info,
      containerColor: AppTheme.infoContainer,
    ),
    _SummaryData(
      value: '3',
      unit: 'alertas',
      label: 'Alertas activas',
      dateRange: '12 Oct — En curso',
      icon: Icons.warning_amber_outlined,
      iconColor: AppTheme.warning,
      containerColor: AppTheme.warningContainer,
    ),
    _SummaryData(
      value: '87.5',
      unit: '%',
      label: 'Bombas OK',
      dateRange: '14 de 16 activas',
      icon: Icons.settings_input_component_outlined,
      iconColor: AppTheme.success,
      containerColor: AppTheme.successContainer,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Horizontal scroll of summary cards — matches reference image bottom section
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _summaries.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) => _SummaryCard(data: _summaries[i]),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final _SummaryData data;

  const _SummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: data.iconColor.withAlpha(51), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: data.containerColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(data.icon, size: 15, color: data.iconColor),
              ),
              const Spacer(),
              Text(
                data.unit,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            data.value,
            style: GoogleFonts.ibmPlexMono(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.label,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            data.dateRange,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 9,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
