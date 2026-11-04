// APARTADO: Pantalla oficial de Zonas (Edificios del Campus con Bombas y Flujo en Vivo)
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/tema_aplicacion.dart';
import '../../widgets/barra_superior_aplicacion.dart';
import '../../widgets/guia_rapida_dialogo.dart';
import '../../widgets/liquid_glass_container.dart';

class _BuildingPump {
  final String id;
  final String name;
  final double pressure;
  final String status;
  final bool isRunning;

  const _BuildingPump({
    required this.id,
    required this.name,
    required this.pressure,
    required this.status,
    required this.isRunning,
  });
}

class _BuildingZone {
  final String id;
  final String name;
  final String description;
  final double flowRate; // L/min
  final double supplyPercent;
  final String status;
  final Color statusColor;
  final IconData icon;
  final List<_BuildingPump> pumps;

  const _BuildingZone({
    required this.id,
    required this.name,
    required this.description,
    required this.flowRate,
    required this.supplyPercent,
    required this.status,
    required this.statusColor,
    required this.icon,
    required this.pumps,
  });
}

class ZonesScreen extends StatefulWidget {
  const ZonesScreen({super.key});

  @override
  State<ZonesScreen> createState() => _ZonesScreenState();
}

class _ZonesScreenState extends State<ZonesScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flowLoopController;

  static const List<_BuildingZone> _zones = [
    _BuildingZone(
      id: 'Z-01',
      name: 'Edificio A',
      description: 'Aulas magnas, Decanatura y oficinas académicas',
      flowRate: 38.2,
      supplyPercent: 98,
      status: 'Operativo',
      statusColor: AppTheme.success,
      icon: Icons.school_rounded,
      pumps: [
        _BuildingPump(id: 'BOM-001', name: 'Bomba Principal Impulsión', pressure: 4.2, status: 'Operativo', isRunning: true),
        _BuildingPump(id: 'BOM-007', name: 'Bomba Respaldo Secundario', pressure: 0.0, status: 'En espera', isRunning: false),
      ],
    ),
    _BuildingZone(
      id: 'Z-02',
      name: 'Edificio B',
      description: 'Laboratorios de Ingeniería y Ciencias Aplicadas',
      flowRate: 54.8,
      supplyPercent: 92,
      status: 'Consumo Elevado',
      statusColor: AppTheme.warning,
      icon: Icons.biotech_rounded,
      pumps: [
        _BuildingPump(id: 'BOM-002', name: 'Bomba Red Laboratorios', pressure: 3.1, status: 'Advertencia', isRunning: true),
        _BuildingPump(id: 'BOM-008', name: 'Bomba Dosificación Química', pressure: 2.8, status: 'Operativo', isRunning: true),
      ],
    ),
    _BuildingZone(
      id: 'Z-03',
      name: 'Edificio C',
      description: 'Biblioteca Central, Auditorio y Salas de Estudio',
      flowRate: 24.1,
      supplyPercent: 100,
      status: 'Operativo',
      statusColor: AppTheme.success,
      icon: Icons.menu_book_rounded,
      pumps: [
        _BuildingPump(id: 'BOM-004', name: 'Bomba Alimentación Sanitaria', pressure: 3.8, status: 'Operativo', isRunning: true),
      ],
    ),
    _BuildingZone(
      id: 'Z-04',
      name: 'Edificio D',
      description: 'Servicios Administrativos, Recursos Humanos y Cómputo',
      flowRate: 19.5,
      supplyPercent: 100,
      status: 'Operativo',
      statusColor: AppTheme.success,
      icon: Icons.account_balance_rounded,
      pumps: [
        _BuildingPump(id: 'BOM-005', name: 'Bomba Abastecimiento General', pressure: 4.0, status: 'Operativo', isRunning: true),
      ],
    ),
    _BuildingZone(
      id: 'Z-05',
      name: 'Edificio E',
      description: 'Posgrados, Aulas de Maestría y Centros de Investigación',
      flowRate: 26.7,
      supplyPercent: 97,
      status: 'Operativo',
      statusColor: AppTheme.success,
      icon: Icons.domain_rounded,
      pumps: [
        _BuildingPump(id: 'BOM-006', name: 'Bomba Impulsión Continua', pressure: 3.9, status: 'Operativo', isRunning: true),
      ],
    ),
    _BuildingZone(
      id: 'Z-06',
      name: 'Cafetería Central',
      description: 'Cocinas industriales, área de comensales y módulos de lavado',
      flowRate: 64.3,
      supplyPercent: 78,
      status: 'Presión Crítica',
      statusColor: AppTheme.error,
      icon: Icons.restaurant_rounded,
      pumps: [
        _BuildingPump(id: 'BOM-003', name: 'Bomba Alta Demanda Cocina', pressure: 1.8, status: 'Crítico', isRunning: true),
        _BuildingPump(id: 'BOM-009', name: 'Bomba Hidroneumática Alterna', pressure: 2.1, status: 'En apoyo', isRunning: true),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _flowLoopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _flowLoopController.dispose();
    super.dispose();
  }

  void _inspectZone(BuildContext context, _BuildingZone zone) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ZoneDetailsModal(zone: zone),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: 'Zonas y Edificios del Campus',
        subtitle: 'Telemetría de Bombas y Flujos por Edificio',
        actions: [
          AppBarActionButton(
            tooltip: 'Guía de ayuda',
            onPressed: () => GuiaRapidaDialogo.show(context),
            icon: Icons.help_outline_rounded,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 850;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 24 : 16,
                    vertical: 16,
                  ).copyWith(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Tarjeta de Resumen General Liquid Glass
                      LiquidGlassContainer(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withAlpha(30),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.apartment_rounded,
                                color: theme.colorScheme.primary,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '6 Zonas Conectadas a la Red Hidráulica',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    'Monitoreo activo de 10 bombas y distribución hidráulica sectorizada',
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
                      ),
                      const SizedBox(height: 18),

                      // Rejilla Responsiva de Edificios
                      if (isWide)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.35,
                          ),
                          itemCount: _zones.length,
                          itemBuilder: (context, i) => _buildZoneCard(context, _zones[i]),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _zones.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 14),
                          itemBuilder: (context, i) => _buildZoneCard(context, _zones[i]),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildZoneCard(BuildContext context, _BuildingZone zone) {
    final theme = Theme.of(context);
    final isDark = AppTheme.isDark(context);

    return LiquidGlassContainer(
      padding: const EdgeInsets.all(18),
      onTap: () => _inspectZone(context, zone),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabecera del Edificio
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: zone.statusColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(zone.icon, color: zone.statusColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          zone.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            zone.id,
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      zone.description,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: zone.statusColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: zone.statusColor.withAlpha(80)),
                ),
                child: Text(
                  zone.status,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: zone.statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Tubería de Flujo Animado de este Edificio
          Row(
            children: [
              Icon(Icons.water_drop_rounded, size: 14, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                'Caudal de suministro: ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                '${zone.flowRate} L/min',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
              const Spacer(),
              Text(
                '${zone.supplyPercent.round()}% Cobertura',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: zone.statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Barra visual de flujo animado
          SizedBox(
            height: 12,
            child: AnimatedBuilder(
              animation: _flowLoopController,
              builder: (context, _) => CustomPaint(
                painter: _ZoneFlowPipePainter(
                  phase: _flowLoopController.value,
                  color: zone.statusColor,
                  isDark: isDark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Bombas asignadas a este edificio
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF162536) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.power_settings_new_rounded, size: 13, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Text(
                      'Bombas en servicio (${zone.pumps.length}):',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: zone.pumps.map((p) {
                    final isPGood = p.status == 'Operativo';
                    final isPCrit = p.status == 'Crítico';
                    final pColor = isPGood
                        ? AppTheme.success
                        : (isPCrit ? AppTheme.error : AppTheme.warning);

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E2D3D) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: pColor.withAlpha(90)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(color: pColor, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            p.id,
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '· ${p.pressure} bar',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mini Pintor de Flujo de Agua por Edificio
class _ZoneFlowPipePainter extends CustomPainter {
  final double phase;
  final Color color;
  final bool isDark;

  _ZoneFlowPipePainter({required this.phase, required this.color, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));

    // Fondo del canal
    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF132233) : const Color(0xFFE2E8F0);
    canvas.drawRRect(rrect, bgPaint);

    canvas.save();
    canvas.clipRRect(rrect);

    // Flujo animado
    final flowPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withAlpha(80),
          color.withAlpha(220),
          color.withAlpha(120),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, flowPaint);

    // Gotas en movimiento
    for (int i = 0; i < 5; i++) {
      final t = (i / 5.0 + phase) % 1.0;
      final x = t * size.width;
      canvas.drawCircle(
        Offset(x, size.height / 2),
        2.2,
        Paint()..color = Colors.white,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ZoneFlowPipePainter oldDelegate) {
    return oldDelegate.phase != phase || oldDelegate.color != color || oldDelegate.isDark != isDark;
  }
}

/// Modal de Inspección Detallada de Zona
class _ZoneDetailsModal extends StatelessWidget {
  final _BuildingZone zone;

  const _ZoneDetailsModal({required this.zone});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Icon(zone.icon, color: zone.statusColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${zone.name} (${zone.id})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      zone.description,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
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
          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'Bombas Instaladas y Telemetría',
            style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...zone.pumps.map((p) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.power_rounded,
                  color: p.status == 'Operativo' ? AppTheme.success : AppTheme.error,
                ),
                title: Text('${p.id} · ${p.name}', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                subtitle: Text('Presión de descarga: ${p.pressure} bar · Estado: ${p.status}'),
                trailing: Text(
                  p.isRunning ? 'ENCENDIDA' : 'DETENIDA',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: p.isRunning ? AppTheme.success : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Válvulas de ${zone.name} sincronizadas correctamente'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.tune_rounded),
            label: const Text('Comprobar Calibración de Válvulas'),
          ),
        ],
      ),
    );
  }
}
