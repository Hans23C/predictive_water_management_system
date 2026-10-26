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

  const _PumpData({
    required this.id,
    required this.zone,
    required this.status,
    required this.statusLabel,
    required this.pressure,
    required this.lastChecked,
    required this.flowRate,
  });
}

class MaintenancePumpListWidget extends StatefulWidget {
  const MaintenancePumpListWidget({super.key});

  @override
  State<MaintenancePumpListWidget> createState() =>
      _MaintenancePumpListWidgetState();
}

class _MaintenancePumpListWidgetState extends State<MaintenancePumpListWidget> {
  // PENDIENTE: incorporar Riverpod o Bloc para administrar el estado en producción.
  static final List<Map<String, dynamic>> _pumpMaps = [
    {
      'id': 'BOM-001',
      'zone': 'Z-01 — Bloque A',
      'status': 'operativo',
      'statusLabel': 'Operativo',
      'pressure': 4.5,
      'lastChecked': 'Hace 8 min',
      'flowRate': 12.3,
    },
    {
      'id': 'BOM-002',
      'zone': 'Z-02 — Biblioteca',
      'status': 'advertencia',
      'statusLabel': 'Advertencia',
      'pressure': 3.1,
      'lastChecked': 'Hace 22 min',
      'flowRate': 8.7,
    },
    {
      'id': 'BOM-003',
      'zone': 'Z-03 — Cafetería',
      'status': 'crítico',
      'statusLabel': 'Crítico',
      'pressure': 1.8,
      'lastChecked': 'Hace 12 min',
      'flowRate': 3.2,
    },
    {
      'id': 'BOM-004',
      'zone': 'Z-04 — Bloque B',
      'status': 'operativo',
      'statusLabel': 'Operativo',
      'pressure': 4.2,
      'lastChecked': 'Hace 5 min',
      'flowRate': 11.8,
    },
    {
      'id': 'BOM-005',
      'zone': 'Z-05 — Residencias',
      'status': 'operativo',
      'statusLabel': 'Operativo',
      'pressure': 4.4,
      'lastChecked': 'Hace 15 min',
      'flowRate': 9.6,
    },
    {
      'id': 'BOM-006',
      'zone': 'Z-06 — Campo Dep.',
      'status': 'inactivo',
      'statusLabel': 'Inactivo',
      'pressure': 0.0,
      'lastChecked': 'Hace 2h',
      'flowRate': 0.0,
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
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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
        children: List.generate(_pumps.length, (i) {
          return _PumpItem(
            pump: _pumps[i],
            isFirst: i == 0,
            isLast: i == _pumps.length - 1,
            index: i,
          );
        }),
      ),
    );
  }
}

class _PumpItem extends StatefulWidget {
  final _PumpData pump;
  final bool isFirst;
  final bool isLast;
  final int index;

  const _PumpItem({
    required this.pump,
    required this.isFirst,
    required this.isLast,
    required this.index,
  });

  @override
  State<_PumpItem> createState() => _PumpItemState();
}

class _PumpItemState extends State<_PumpItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.05, 0),
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
    final pump = widget.pump;
    final statusColor = AppTheme.statusColor(pump.status);
    final containerColor = AppTheme.statusContainerColor(pump.status);

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Column(
          children: [
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.vertical(
                top: widget.isFirst ? const Radius.circular(16) : Radius.zero,
                bottom: widget.isLast ? const Radius.circular(16) : Radius.zero,
              ),
              splashColor: theme.colorScheme.primary.withAlpha(15),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: statusColor, width: 3),
                  ),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.zero,
                    right: widget.isFirst
                        ? const Radius.circular(16)
                        : widget.isLast
                        ? const Radius.circular(16)
                        : Radius.zero,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.settings_input_component_outlined,
                        size: 20,
                        color: statusColor,
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
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(width: 8),
                              StatusBadgeWidget(
                                label: pump.statusLabel,
                                status: pump.status,
                                fontSize: 10,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            pump.zone,
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _MetaChip(
                                icon: Icons.speed_outlined,
                                label:
                                    '${pump.pressure.toStringAsFixed(1)} bar',
                              ),
                              const SizedBox(width: 8),
                              _MetaChip(
                                icon: Icons.water_outlined,
                                label:
                                    '${pump.flowRate.toStringAsFixed(1)} L/s',
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  pump.lastChecked,
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 10,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: theme.colorScheme.outline,
                    ),
                  ],
                ),
              ),
            ),
            if (!widget.isLast)
              Divider(
                height: 1,
                thickness: 1,
                color: theme.colorScheme.outlineVariant,
                indent: 64,
              ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 3),
        Text(
          label,
          style: GoogleFonts.ibmPlexMono(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
