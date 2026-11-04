// APARTADO: Componente de la aplicación: lista bombas mantenimiento
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/tema_aplicacion.dart';
import '../../../widgets/insignia_estado.dart';

class _PumpData {
  final String id;
  final String zone;
  final String status;
  final String statusLabel;
  final double pressure;
  final String lastChecked;
  final double flowRate;
  final String alertMessage;

  const _PumpData({
    required this.id,
    required this.zone,
    required this.status,
    required this.statusLabel,
    required this.pressure,
    required this.lastChecked,
    required this.flowRate,
    this.alertMessage = '',
  });
}

class MaintenancePumpListWidget extends StatefulWidget {
  const MaintenancePumpListWidget({super.key});

  @override
  State<MaintenancePumpListWidget> createState() =>
      _MaintenancePumpListWidgetState();
}

class _MaintenancePumpListWidgetState extends State<MaintenancePumpListWidget> {
  String _selectedFilter = 'todas';

  static final List<Map<String, dynamic>> _pumpMaps = [
    {
      'id': 'BOM-001',
      'zone': 'Z-01 — Edificio A',
      'status': 'operativo',
      'statusLabel': 'Operativo',
      'pressure': 4.5,
      'lastChecked': 'Hace 8 min',
      'flowRate': 12.3,
      'alertMessage': 'Funcionamiento óptimo y caudal estable',
    },
    {
      'id': 'BOM-002',
      'zone': 'Z-02 — Edificio B',
      'status': 'advertencia',
      'statusLabel': 'Advertencia',
      'pressure': 3.1,
      'lastChecked': 'Hace 22 min',
      'flowRate': 8.7,
      'alertMessage': 'Presión baja respecto a objetivo (meta 4.0 bar)',
    },
    {
      'id': 'BOM-003',
      'zone': 'Z-06 — Cafetería',
      'status': 'crítico',
      'statusLabel': 'Crítico',
      'pressure': 1.8,
      'lastChecked': 'Hace 12 min',
      'flowRate': 3.2,
      'alertMessage': 'Presión crítica por debajo del umbral mínimo de seguridad',
    },
    {
      'id': 'BOM-004',
      'zone': 'Z-04 — Edificio D',
      'status': 'operativo',
      'statusLabel': 'Operativo',
      'pressure': 4.2,
      'lastChecked': 'Hace 5 min',
      'flowRate': 11.8,
      'alertMessage': 'Presión dentro del rango nominal',
    },
    {
      'id': 'BOM-005',
      'zone': 'Z-05 — Edificio E',
      'status': 'operativo',
      'statusLabel': 'Operativo',
      'pressure': 4.4,
      'lastChecked': 'Hace 15 min',
      'flowRate': 9.6,
      'alertMessage': 'Caudal y recirculación nominales',
    },
    {
      'id': 'BOM-006',
      'zone': 'Z-06 — Campo Dep.',
      'status': 'inactivo',
      'statusLabel': 'Inactivo',
      'pressure': 0.0,
      'lastChecked': 'Hace 2h',
      'flowRate': 0.0,
      'alertMessage': 'Unidad fuera de servicio por mantenimiento programado',
    },
  ];

  late List<_PumpData> _pumps;

  @override
  void initState() {
    super.initState();
    _pumps = _pumpMaps
        .map(
          (m) => _PumpData(
            id: m['id'],
            zone: m['zone'],
            status: m['status'],
            statusLabel: m['statusLabel'],
            pressure: (m['pressure'] as num).toDouble(),
            lastChecked: m['lastChecked'],
            flowRate: (m['flowRate'] as num).toDouble(),
            alertMessage: m['alertMessage'] ?? '',
          ),
        )
        .toList();
  }

  List<_PumpData> get _filteredPumps {
    if (_selectedFilter == 'todas') return _pumps;
    return _pumps.where((p) => p.status == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalCount = _pumps.length;
    final opCount = _pumps.where((p) => p.status == 'operativo').length;
    final advCount = _pumps.where((p) => p.status == 'advertencia').length;
    final critCount = _pumps.where((p) => p.status == 'crítico').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Barra de filtros rápidos de bombas
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(
                label: 'Todas ($totalCount)',
                isSelected: _selectedFilter == 'todas',
                onTap: () => setState(() => _selectedFilter = 'todas'),
                activeColor: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Operativas ($opCount)',
                isSelected: _selectedFilter == 'operativo',
                onTap: () => setState(() => _selectedFilter = 'operativo'),
                activeColor: AppTheme.success,
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Advertencia ($advCount)',
                isSelected: _selectedFilter == 'advertencia',
                onTap: () => setState(() => _selectedFilter = 'advertencia'),
                activeColor: AppTheme.warning,
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Críticas ($critCount)',
                isSelected: _selectedFilter == 'crítico',
                onTap: () => setState(() => _selectedFilter = 'crítico'),
                activeColor: AppTheme.error,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Lista de tarjetas individuales de bombas
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _filteredPumps.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            return _EnhancedPumpCard(
              pump: _filteredPumps[i],
              index: i,
            );
          },
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = AppTheme.isDark(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withAlpha(isDark ? 50 : 30) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : theme.colorScheme.outlineVariant,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withAlpha(40),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? activeColor : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _EnhancedPumpCard extends StatefulWidget {
  final _PumpData pump;
  final int index;

  const _EnhancedPumpCard({
    required this.pump,
    required this.index,
  });

  @override
  State<_EnhancedPumpCard> createState() => _EnhancedPumpCardState();
}

class _EnhancedPumpCardState extends State<_EnhancedPumpCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.04, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    Future.delayed(Duration(milliseconds: 40 * widget.index), () {
      if (mounted) _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showPumpDetails(BuildContext context) {
    final pump = widget.pump;
    final statusColor = AppTheme.statusColor(pump.status);

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pump.id,
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        pump.zone,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  StatusBadgeWidget(
                    label: pump.statusLabel,
                    status: pump.status,
                    fontSize: 12,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.statusContainerColor(pump.status),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withAlpha(60)),
                ),
                child: Row(
                  children: [
                    Icon(
                      pump.status == 'crítico'
                          ? Icons.warning_amber_rounded
                          : pump.status == 'advertencia'
                          ? Icons.info_outline_rounded
                          : Icons.check_circle_outline_rounded,
                      color: statusColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        pump.alertMessage,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _DetailMetricBox(
                      title: 'Presión Hidráulica',
                      value: '${pump.pressure.toStringAsFixed(1)} bar',
                      statusColor: statusColor,
                      icon: Icons.speed_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DetailMetricBox(
                      title: 'Caudal de Bombeo',
                      value: '${pump.flowRate.toStringAsFixed(1)} L/s',
                      statusColor: AppTheme.primary,
                      icon: Icons.water_drop_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Entendido'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pump = widget.pump;
    final statusColor = AppTheme.statusColor(pump.status);
    final statusContainer = AppTheme.statusContainerColor(pump.status);

    final isDark = AppTheme.isDark(context);

    // Fondo según criticidad para impacto visual inmediato
    Color cardBg;
    Color borderLeftColor;
    IconData pumpIcon;

    if (pump.status == 'crítico') {
      cardBg = isDark ? const Color(0xFF381010) : const Color(0xFFFFF5F5);
      borderLeftColor = AppTheme.error;
      pumpIcon = Icons.error_rounded;
    } else if (pump.status == 'advertencia') {
      cardBg = isDark ? const Color(0xFF2E1C07) : const Color(0xFFFFFDF5);
      borderLeftColor = AppTheme.warning;
      pumpIcon = Icons.warning_rounded;
    } else if (pump.status == 'operativo') {
      cardBg = theme.colorScheme.surface;
      borderLeftColor = AppTheme.success;
      pumpIcon = Icons.power_rounded;
    } else {
      cardBg = isDark ? const Color(0xFF131D28) : const Color(0xFFFAFAFA);
      borderLeftColor = theme.colorScheme.outlineVariant;
      pumpIcon = Icons.power_off_rounded;
    }

    // Porcentaje de presión respecto al objetivo 4.0 bar (máx 6.0)
    final double pressurePercent = (pump.pressure / 6.0).clamp(0.0, 1.0);

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: pump.status == 'crítico'
                  ? AppTheme.error.withAlpha(80)
                  : pump.status == 'advertencia'
                  ? AppTheme.warning.withAlpha(80)
                  : theme.colorScheme.outlineVariant,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: pump.status == 'crítico'
                    ? AppTheme.error.withAlpha(25)
                    : pump.status == 'advertencia'
                    ? AppTheme.warning.withAlpha(20)
                    : Colors.black.withAlpha(12),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showPumpDetails(context),
              borderRadius: BorderRadius.circular(16),
              splashColor: statusColor.withAlpha(25),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: borderLeftColor, width: 4.5),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cabecera de la tarjeta: Icono, ID, Zona e Insignia de estado
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: statusContainer,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: statusColor.withAlpha(45),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: statusColor.withAlpha(30),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              pumpIcon,
                              color: statusColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      pump.id,
                                      style: GoogleFonts.ibmPlexMono(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    const Spacer(),
                                    StatusBadgeWidget(
                                      label: pump.statusLabel,
                                      status: pump.status,
                                      fontSize: 10.5,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  pump.zone,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Mensaje contextual para estados de alerta o críticos
                      if (pump.status == 'crítico' || pump.status == 'advertencia') ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                pump.status == 'crítico'
                                    ? Icons.report_problem_rounded
                                    : Icons.warning_amber_rounded,
                                size: 14,
                                color: statusColor,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  pump.alertMessage,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),

                      // Barra visual de nivel de presión
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Nivel de Presión (Objetivo: 4.0 bar)',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${pump.pressure.toStringAsFixed(1)} / 6.0 bar',
                                style: GoogleFonts.ibmPlexMono(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: pressurePercent,
                              minHeight: 6,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Fila inferior con métricas (chips modernos)
                      Row(
                        children: [
                          _MetricBadge(
                            icon: Icons.speed_rounded,
                            label: '${pump.pressure.toStringAsFixed(1)} bar',
                            color: statusColor,
                          ),
                          const SizedBox(width: 8),
                          _MetricBadge(
                            icon: Icons.water_drop_outlined,
                            label: '${pump.flowRate.toStringAsFixed(1)} L/s',
                            color: AppTheme.primary,
                          ),
                          const Spacer(),
                          Text(
                            pump.lastChecked,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetricBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(22),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.ibmPlexMono(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailMetricBox extends StatelessWidget {
  final String title;
  final String value;
  final Color statusColor;
  final IconData icon;

  const _DetailMetricBox({
    required this.title,
    required this.value,
    required this.statusColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: statusColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.ibmPlexMono(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
