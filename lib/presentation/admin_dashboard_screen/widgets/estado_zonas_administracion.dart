// APARTADO: Componente de la aplicación: estado zonas administracion
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/tema_aplicacion.dart';
import '../../../widgets/insignia_estado.dart';

class _ZoneData {
  final String id;
  final String name;
  final String status;
  final String statusLabel;
  final double consumption;
  final int sensors;
  final int activeSensors;

  const _ZoneData({
    required this.id,
    required this.name,
    required this.status,
    required this.statusLabel,
    required this.consumption,
    required this.sensors,
    required this.activeSensors,
  });
}

class AdminZoneStatusWidget extends StatelessWidget {
  const AdminZoneStatusWidget({super.key});

  static const List<_ZoneData> _zones = [
    _ZoneData(
      id: 'Z-01',
      name: 'Bloque A — Ciencias',
      status: 'normal',
      statusLabel: 'Normal',
      consumption: 42.8,
      sensors: 6,
      activeSensors: 6,
    ),
    _ZoneData(
      id: 'Z-02',
      name: 'Biblioteca Central',
      status: 'warning',
      statusLabel: 'Advertencia',
      consumption: 61.4,
      sensors: 8,
      activeSensors: 7,
    ),
    _ZoneData(
      id: 'Z-03',
      name: 'Cafetería Norte',
      status: 'critical',
      statusLabel: 'Crítico',
      consumption: 38.2,
      sensors: 4,
      activeSensors: 3,
    ),
    _ZoneData(
      id: 'Z-04',
      name: 'Bloque B — Ingeniería',
      status: 'normal',
      statusLabel: 'Normal',
      consumption: 35.6,
      sensors: 6,
      activeSensors: 6,
    ),
    _ZoneData(
      id: 'Z-05',
      name: 'Residencias Est.',
      status: 'normal',
      statusLabel: 'Normal',
      consumption: 29.8,
      sensors: 5,
      activeSensors: 5,
    ),
    _ZoneData(
      id: 'Z-06',
      name: 'Campo Deportivo',
      status: 'offline',
      statusLabel: 'Inactivo',
      consumption: 0.0,
      sensors: 3,
      activeSensors: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _zones.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) => _ZoneCard(zone: _zones[i]),
      ),
    );
  }
}

class _ZoneCard extends StatelessWidget {
  final _ZoneData zone;

  const _ZoneCard({required this.zone});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = AppTheme.statusColor(zone.status);
    final containerColor = AppTheme.statusContainerColor(zone.status);

    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withAlpha(64), width: 1.5),
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
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                zone.id,
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            zone.name,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          StatusBadgeWidget(
            label: zone.statusLabel,
            status: zone.status,
            fontSize: 10,
          ),
          const SizedBox(height: 4),
          Text(
            '${zone.consumption.toStringAsFixed(1)} m³ · ${zone.activeSensors}/${zone.sensors} sensores',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 10,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
