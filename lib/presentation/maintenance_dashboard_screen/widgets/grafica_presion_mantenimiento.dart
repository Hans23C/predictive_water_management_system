// APARTADO: Componente de la aplicación: grafica presion mantenimiento
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/tema_aplicacion.dart';

class MaintenancePressureChartWidget extends StatefulWidget {
  const MaintenancePressureChartWidget({super.key});

  @override
  State<MaintenancePressureChartWidget> createState() =>
      _MaintenancePressureChartWidgetState();
}

class _MaintenancePressureChartWidgetState
    extends State<MaintenancePressureChartWidget> {
  int _selectedPeriod = 0;
  static const List<String> _periods = ['Turno actual', 'Últimas 24h'];

  static const List<double> _pressureDataTurno = [4.5, 3.1, 1.8, 4.2, 4.4, 0.0];
  static const List<double> _pressureData24h = [4.3, 3.4, 2.2, 4.1, 4.2, 0.0];

  static const List<String> _zoneLabels = [
    'Z-01',
    'Z-02',
    'Z-03',
    'Z-04',
    'Z-05',
    'Z-06',
  ];

  static const List<String> _zoneNames = [
    'Edif. A',
    'Edif. B',
    'Cafetería',
    'Edif. D',
    'Edif. E',
    'Campo Dep.',
  ];

  static const double _targetPressure = 4.0;

  List<double> get _currentPressureData =>
      _selectedPeriod == 0 ? _pressureDataTurno : _pressureData24h;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pressureData = _currentPressureData;

    // Calcular estadísticas
    final activePressures = pressureData.where((p) => p > 0).toList();
    final double avgPressure = activePressures.isNotEmpty
        ? activePressures.reduce((a, b) => a + b) / activePressures.length
        : 0.0;

    final int optimalCount = pressureData.where((p) => p >= _targetPressure).length;
    final int warningCount = pressureData.where((p) => p >= 2.5 && p < _targetPressure).length;
    final int criticalCount = pressureData.where((p) => p > 0 && p < 2.5).length;
    final int offCount = pressureData.where((p) => p == 0).length;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(80),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera: Promedio de presión y selector de periodo
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          avgPressure.toStringAsFixed(2),
                          style: GoogleFonts.ibmPlexMono(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'bar',
                          style: GoogleFonts.ibmPlexMono(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: avgPressure >= _targetPressure
                                ? AppTheme.successContainer
                                : AppTheme.warningContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            avgPressure >= _targetPressure ? 'En Rango' : 'Alerta Leve',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: avgPressure >= _targetPressure
                                  ? AppTheme.success
                                  : AppTheme.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Presión promedio en zonas activas',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Selector de periodo (Turno / 24h)
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: List.generate(_periods.length, (i) {
                    final isSelected = i == _selectedPeriod;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedPeriod = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(15),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          _periods[i],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppTheme.primary : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Gráfica de barras estilizada
          SizedBox(
            height: 175,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 6.0,
                minY: 0,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: const Color(0xFF0F2537),
                    tooltipRoundedRadius: 10,
                    tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final zoneLabel = _zoneLabels[group.x];
                      final zoneName = _zoneNames[group.x];
                      final pressureVal = rod.toY;

                      String statusDesc;
                      if (pressureVal == 0) {
                        statusDesc = 'Inactivo';
                      } else if (pressureVal < 2.5) {
                        statusDesc = 'Crítico';
                      } else if (pressureVal < _targetPressure) {
                        statusDesc = 'Baja';
                      } else {
                        statusDesc = 'Óptima';
                      }

                      return BarTooltipItem(
                        '$zoneLabel ($zoneName)\n',
                        GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: Colors.grey.shade300,
                        ),
                        children: [
                          TextSpan(
                            text: '${pressureVal.toStringAsFixed(1)} bar · $statusDesc',
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF67E8F9),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 2,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}',
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 10,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= _zoneLabels.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            _zoneLabels[idx],
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: theme.colorScheme.outlineVariant.withAlpha(100),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ),
                borderData: FlBorderData(show: false),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: _targetPressure,
                      color: const Color(0xFF10B981).withAlpha(190),
                      strokeWidth: 1.6,
                      dashArray: [6, 4],
                      label: HorizontalLineLabel(
                        show: true,
                        alignment: Alignment.topRight,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          color: const Color(0xFF059669),
                          fontWeight: FontWeight.w700,
                        ),
                        labelResolver: (_) => 'Meta 4.0 bar',
                      ),
                    ),
                  ],
                ),
                barGroups: List.generate(pressureData.length, (i) {
                  final pressure = pressureData[i];

                  LinearGradient gradient;
                  if (pressure == 0.0) {
                    gradient = LinearGradient(
                      colors: [Colors.grey.shade400, Colors.grey.shade500],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    );
                  } else if (pressure < 2.5) {
                    gradient = const LinearGradient(
                      colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    );
                  } else if (pressure < _targetPressure) {
                    gradient = const LinearGradient(
                      colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    );
                  } else {
                    gradient = const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF047857)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    );
                  }

                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: pressure,
                        gradient: gradient,
                        width: 26,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                          bottom: Radius.circular(3),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 6.0,
                          color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Leyenda de estados de presión con conteos
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatusPill(
                color: const Color(0xFF10B981),
                text: 'Óptimo ($optimalCount)',
              ),
              const SizedBox(width: 8),
              _StatusPill(
                color: const Color(0xFFF59E0B),
                text: 'Atención ($warningCount)',
              ),
              const SizedBox(width: 8),
              _StatusPill(
                color: const Color(0xFFEF4444),
                text: 'Crítico ($criticalCount)',
              ),
              if (offCount > 0) ...[
                const SizedBox(width: 8),
                _StatusPill(
                  color: Colors.grey.shade500,
                  text: 'Off ($offCount)',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final Color color;
  final String text;

  const _StatusPill({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
