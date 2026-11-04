// Estado operativo de las seis zonas oficiales del campus adaptativo.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class _Zona {
  final String id;
  final String nombre;
  final String estado;
  final Color color;
  final double consumoReferencia;
  const _Zona(this.id, this.nombre, this.estado, this.color, this.consumoReferencia);
}

class AdminZoneStatusWidget extends StatelessWidget {
  const AdminZoneStatusWidget({super.key});

  static const List<_Zona> _zonas = [
    _Zona('Z-01', 'Edificio A', 'Operación normal', Color(0xFF16A34A), 46),
    _Zona('Z-02', 'Edificio B', 'Operación normal', Color(0xFF16A34A), 72),
    _Zona('Z-03', 'Edificio C', 'Operación normal', Color(0xFF16A34A), 58),
    _Zona('Z-04', 'Edificio D', 'Operación normal', Color(0xFF16A34A), 31),
    _Zona('Z-05', 'Edificio E', 'Operación normal', Color(0xFF16A34A), 27),
    _Zona('Z-06', 'Cafetería', 'Demanda activa', Color(0xFF0284C7), 86),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: _zonas
          .map(
            (zona) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border.all(color: theme.colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(color: zona.color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 44,
                    child: Text(
                      zona.id,
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      zona.nombre,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: zona.color.withAlpha(20),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      zona.estado,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: zona.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
