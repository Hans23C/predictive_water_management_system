import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

class _KpiData {
  final String label;
  final String value;
  final String unit;
  final String trend;
  final bool trendUp;
  final bool isAlert;
  final IconData icon;
  final Color iconColor;

  const _KpiData({
    required this.label,
    required this.value,
    required this.unit,
    required this.trend,
    required this.trendUp,
    this.isAlert = false,
    required this.icon,
    required this.iconColor,
  });
}

class AdminKpiGridWidget extends StatelessWidget {
  const AdminKpiGridWidget({super.key});

  static const List<_KpiData> _kpis = [
    _KpiData(
      label: 'Consumo hoy',
      value: '248.2',
      unit: 'm³',
      trend: '+6.3%',
      trendUp: true,
      isAlert: true,
      icon: Icons.water_drop_outlined,
      iconColor: AppTheme.info,
    ),
    _KpiData(
      label: 'Alertas activas',
      value: '3',
      unit: 'alertas',
      trend: '+2 vs ayer',
      trendUp: true,
      isAlert: true,
      icon: Icons.warning_amber_rounded,
      iconColor: AppTheme.warning,
    ),
    _KpiData(
      label: 'Bombas operativas',
      value: '14',
      unit: '/ 16',
      trend: '87.5%',
      trendUp: false,
      icon: Icons.settings_input_component_outlined,
      iconColor: AppTheme.success,
    ),
    _KpiData(
      label: 'Zonas monitoreadas',
      value: '8',
      unit: 'zonas',
      trend: 'Todo activo',
      trendUp: true,
      icon: Icons.map_outlined,
      iconColor: AppTheme.primary,
    ),
    _KpiData(
      label: 'Presión promedio',
      value: '4.2',
      unit: 'bar',
      trend: '−0.3 bar',
      trendUp: false,
      isAlert: false,
      icon: Icons.speed_outlined,
      iconColor: AppTheme.secondary,
    ),
    _KpiData(
      label: 'Agua conservada',
      value: '1,840',
      unit: 'L hoy',
      trend: '+12.1%',
      trendUp: true,
      icon: Icons.eco_outlined,
      iconColor: AppTheme.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.55,
      ),
      itemCount: _kpis.length,
      itemBuilder: (context, i) => _KpiCard(data: _kpis[i], index: i),
    );
  }
}

class _KpiCard extends StatefulWidget {
  final _KpiData data;
  final int index;

  const _KpiCard({required this.data, required this.index});

  @override
  State<_KpiCard> createState() => _KpiCardState();
}

class _KpiCardState extends State<_KpiCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: 80 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final d = widget.data;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Container(
          decoration: BoxDecoration(
            color: d.isAlert
                ? (d.label.contains('Alerta')
                      ? AppTheme.warningContainer
                      : AppTheme.infoContainer.withAlpha(153))
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: d.isAlert && d.label.contains('Alerta')
                ? Border.all(color: AppTheme.warning.withAlpha(77), width: 1)
                : null,
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: d.iconColor.withAlpha(31),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(d.icon, size: 18, color: d.iconColor),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: d.trendUp
                          ? (d.isAlert && d.label.contains('Alerta')
                                ? AppTheme.warningContainer
                                : AppTheme.infoContainer)
                          : AppTheme.successContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          d.trendUp
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          size: 10,
                          color: d.trendUp
                              ? (d.isAlert && d.label.contains('Alerta')
                                    ? AppTheme.warning
                                    : AppTheme.info)
                              : AppTheme.success,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          d.trend,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: d.trendUp
                                ? (d.isAlert && d.label.contains('Alerta')
                                      ? AppTheme.warning
                                      : AppTheme.info)
                                : AppTheme.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        d.value,
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(width: 3),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          d.unit,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    d.label,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
