// APARTADO: Componente de la aplicación: rejilla indicadores administracion
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/tema_aplicacion.dart';

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
      label: 'Consumo de Agua Hoy',
      value: '142.5',
      unit: 'm³ (~142 mil L)',
      trend: 'Dentro de lo habitual',
      trendUp: false,
      icon: Icons.water_drop_rounded,
      iconColor: AppTheme.info,
    ),
    _KpiData(
      label: 'Fugas Detectadas',
      value: '0',
      unit: 'alertas',
      trend: '🟢 Tuberías sanas',
      trendUp: true,
      isAlert: false,
      icon: Icons.check_circle_outline_rounded,
      iconColor: AppTheme.success,
    ),
    _KpiData(
      label: 'Bombas en Servicio',
      value: '4 de 4',
      unit: 'activas',
      trend: 'Operación continua',
      trendUp: true,
      icon: Icons.settings_input_component_rounded,
      iconColor: AppTheme.success,
    ),
    _KpiData(
      label: 'Edificios Monitoreados',
      value: '6',
      unit: 'zonas',
      trend: 'Edif. A a E y Cafetería',
      trendUp: true,
      icon: Icons.apartment_rounded,
      iconColor: AppTheme.primary,
    ),
    _KpiData(
      label: 'Fuerza del Agua (Presión)',
      value: '4.2',
      unit: 'bar (Óptima)',
      trend: 'Flujo adecuado en llaves',
      trendUp: true,
      icon: Icons.speed_rounded,
      iconColor: AppTheme.secondary,
    ),
    _KpiData(
      label: 'Agua Ahorrada este Mes',
      value: '18,400',
      unit: 'litros',
      trend: 'Por detección preventiva',
      trendUp: true,
      icon: Icons.eco_rounded,
      iconColor: AppTheme.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 850
            ? 3
            : (constraints.maxWidth >= 550 ? 3 : 2);
        final aspectRatio = constraints.maxWidth >= 850 ? 1.7 : 1.5;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: aspectRatio,
          ),
          itemCount: _kpis.length,
          itemBuilder: (context, i) => _KpiCard(data: _kpis[i], index: i),
        );
      },
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

    Future.delayed(Duration(milliseconds: 60 * widget.index), () {
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
    final isDark = AppTheme.isDark(context);
    final d = widget.data;

    final bgColor = d.isAlert
        ? (isDark
            ? (d.label.contains('Alerta') ? const Color(0xFF451A03) : const Color(0xFF0C3854))
            : (d.label.contains('Alerta')
                ? AppTheme.warningContainer
                : AppTheme.infoContainer.withAlpha(153)))
        : theme.colorScheme.surface;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: d.isAlert && d.label.contains('Alerta')
                  ? AppTheme.warning.withAlpha(120)
                  : theme.colorScheme.outlineVariant,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withAlpha(30) : Colors.black.withAlpha(8),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
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
                      color: d.iconColor.withAlpha(isDark ? 40 : 25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(d.icon, size: 18, color: d.iconColor),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (d.trendUp ? AppTheme.success : theme.colorScheme.outlineVariant)
                          .withAlpha(35),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      d.trend,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: d.trendUp ? AppTheme.success : theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        d.value,
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      if (d.unit.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        Text(
                          d.unit,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    d.label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
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
