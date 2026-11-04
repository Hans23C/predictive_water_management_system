// APARTADO: Componente de la aplicación: grafica consumo administracion
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/tema_aplicacion.dart';

class AdminConsumptionChartWidget extends StatefulWidget {
  const AdminConsumptionChartWidget({super.key});

  @override
  State<AdminConsumptionChartWidget> createState() =>
      _AdminConsumptionChartWidgetState();
}

class _AdminConsumptionChartWidgetState
    extends State<AdminConsumptionChartWidget> {
  int _selectedRangeIndex = 1; // 0: 7D, 1: 14D, 2: 30D

  static const List<double> _allData = [
    205.1, 218.4, 222.0, 230.5, 210.8, 204.3, 219.0,
    215.4, 228.7, 241.2, 195.8, 187.3, 232.1, 256.8,
    244.5, 219.6, 263.4, 248.9, 201.2, 235.7, 248.2,
  ];

  static const List<String> _allLabels = [
    '22/9', '23/9', '24/9', '25/9', '26/9', '27/9', '28/9',
    '29/9', '30/9', '01/10', '02/10', '03/10', '04/10', '05/10',
    '06/10', '07/10', '08/10', '09/10', '10/10', '11/10', '12/10',
  ];

  List<double> get _currentData {
    switch (_selectedRangeIndex) {
      case 0:
        return _allData.sublist(_allData.length - 7);
      case 1:
        return _allData.sublist(_allData.length - 14);
      case 2:
      default:
        return _allData;
    }
  }

  List<String> get _currentLabels {
    switch (_selectedRangeIndex) {
      case 0:
        return _allLabels.sublist(_allLabels.length - 7);
      case 1:
        return _allLabels.sublist(_allLabels.length - 14);
      case 2:
      default:
        return _allLabels;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = _currentData;
    final labels = _currentLabels;

    final double todayConsumption = data.last;
    final double previousDay = data.length > 1 ? data[data.length - 2] : todayConsumption;
    final double diffPercent = ((todayConsumption - previousDay) / previousDay) * 100;
    final bool isIncrease = diffPercent >= 0;

    final double avgConsumption = data.reduce((a, b) => a + b) / data.length;
    final double maxConsumption = data.reduce(math.max);
    final double minConsumption = data.reduce(math.min);

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
          // Cabecera: Métricas principales y selector de periodo
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${todayConsumption.toStringAsFixed(1)} m³',
                          style: GoogleFonts.ibmPlexMono(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: isIncrease
                                ? AppTheme.warningContainer
                                : AppTheme.successContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isIncrease
                                    ? Icons.arrow_upward_rounded
                                    : Icons.arrow_downward_rounded,
                                size: 12,
                                color: isIncrease ? AppTheme.warning : AppTheme.success,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${diffPercent.abs().toStringAsFixed(1)}%',
                                style: GoogleFonts.ibmPlexMono(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: isIncrease ? AppTheme.warning : AppTheme.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Consumo registrado hoy · vs día anterior',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Selector de rango temporal 7D / 14D / Todo
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    _RangePill(
                      text: '7D',
                      isSelected: _selectedRangeIndex == 0,
                      onTap: () => setState(() => _selectedRangeIndex = 0),
                    ),
                    _RangePill(
                      text: '14D',
                      isSelected: _selectedRangeIndex == 1,
                      onTap: () => setState(() => _selectedRangeIndex = 1),
                    ),
                    _RangePill(
                      text: '21D',
                      isSelected: _selectedRangeIndex == 2,
                      onTap: () => setState(() => _selectedRangeIndex = 2),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Mini barra resumen de estadísticas del periodo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: 'Promedio',
                  value: '${avgConsumption.toStringAsFixed(1)} m³',
                ),
                Container(width: 1, height: 20, color: Colors.grey.shade300),
                _StatItem(
                  label: 'Pico máx.',
                  value: '${maxConsumption.toStringAsFixed(1)} m³',
                ),
                Container(width: 1, height: 20, color: Colors.grey.shade300),
                _StatItem(
                  label: 'Mínimo',
                  value: '${minConsumption.toStringAsFixed(1)} m³',
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Gráfica de línea con degradados modernos y tooltips
          SizedBox(
            height: 190,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 30,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: theme.colorScheme.outlineVariant.withAlpha(100),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      interval: 30,
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
                      interval: _selectedRangeIndex == 0 ? 1 : 2,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= labels.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            labels[idx],
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w500,
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
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (data.length - 1).toDouble(),
                minY: 160,
                maxY: 280,
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: const Color(0xFF0F2537),
                    tooltipRoundedRadius: 10,
                    tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    getTooltipItems: (spots) => spots.map(
                      (spot) {
                        final idx = spot.x.toInt();
                        final dateLabel = idx >= 0 && idx < labels.length ? labels[idx] : '';
                        return LineTooltipItem(
                          '${spot.y.toStringAsFixed(1)} m³\n$dateLabel',
                          GoogleFonts.ibmPlexMono(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF67E8F9),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      data.length,
                      (i) => FlSpot(i.toDouble(), data[i]),
                    ),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF087FAD),
                        Color(0xFF06B6D4),
                        Color(0xFF14B8A6),
                      ],
                    ),
                    barWidth: 3.2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) {
                        final isLast = index == data.length - 1;
                        final isPeak = spot.y == maxConsumption;

                        if (isLast || isPeak) {
                          return FlDotCirclePainter(
                            radius: 5,
                            color: isPeak ? const Color(0xFFF59E0B) : const Color(0xFF087FAD),
                            strokeWidth: 2.5,
                            strokeColor: Colors.white,
                          );
                        }
                        return FlDotCirclePainter(
                          radius: 0,
                          color: Colors.transparent,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF087FAD).withAlpha(90),
                          const Color(0xFF06B6D4).withAlpha(40),
                          const Color(0xFF06B6D4).withAlpha(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Leyenda inferior con indicadores
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _LegendDot(color: const Color(0xFF087FAD), text: 'Consumo diario'),
              const SizedBox(width: 14),
              _LegendDot(color: const Color(0xFFF59E0B), text: 'Pico máximo'),
            ],
          ),
        ],
      ),
    );
  }
}

class _RangePill extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _RangePill({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppTheme.primary : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: GoogleFonts.ibmPlexMono(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.primary,
          ),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendDot({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
