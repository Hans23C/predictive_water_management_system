// APARTADO: Agrupamiento K-means de zonas según consumo y telemetría
// Este archivo está adaptado para visualización amigable en modo claro y oscuro.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/tema_aplicacion.dart';

class _ZonaVector {
  final String nombre;
  final List<double> valores;
  const _ZonaVector(this.nombre, this.valores);
}

class _Grupo {
  final String nombre;
  final String explicacion;
  final Color color;
  final List<String> zonas;
  const _Grupo(this.nombre, this.explicacion, this.color, this.zonas);
}

class AnalisisClusteringZonas extends StatelessWidget {
  const AnalisisClusteringZonas({super.key});

  List<_Grupo> _calcularGrupos() {
    const datos = <_ZonaVector>[
      _ZonaVector('Edificio A', [46, 3.4, 100]),
      _ZonaVector('Edificio B', [72, 2.8, 88]),
      _ZonaVector('Edificio C', [58, 3.0, 100]),
      _ZonaVector('Edificio D', [31, 3.8, 100]),
      _ZonaVector('Edificio E', [27, 4.0, 100]),
      _ZonaVector('Cafetería', [86, 2.1, 75]),
    ];
    const k = 3;
    var centroides = <List<double>>[
      List<double>.from(datos[0].valores),
      List<double>.from(datos[2].valores),
      List<double>.from(datos[5].valores),
    ];
    List<int> asignaciones = List.filled(datos.length, 0);

    for (var iteracion = 0; iteracion < 20; iteracion++) {
      for (var i = 0; i < datos.length; i++) {
        var mejor = 0;
        var distanciaMinima = double.infinity;
        for (var c = 0; c < k; c++) {
          final distancia = _distancia(datos[i].valores, centroides[c]);
          if (distancia < distanciaMinima) {
            distanciaMinima = distancia;
            mejor = c;
          }
        }
        asignaciones[i] = mejor;
      }
      for (var c = 0; c < k; c++) {
        final miembros = <List<double>>[];
        for (var i = 0; i < datos.length; i++) {
          if (asignaciones[i] == c) miembros.add(datos[i].valores);
        }
        if (miembros.isEmpty) continue;
        centroides[c] = List.generate(
          3,
          (j) => miembros.map((v) => v[j]).reduce((a, b) => a + b) / miembros.length,
        );
      }
    }

    final grupos = <_Grupo>[];
    const nombres = ['Consumo Moderado', 'Consumo Regular', 'Demanda Alta'];
    const explicaciones = [
      'Uso eficiente de agua y buena presión',
      'Flujo continuo estándar para aulas y pasillos',
      'Zona de alto flujo constante (cocinas y baños)',
    ];
    const colores = [Color(0xFF16A34A), Color(0xFFD97706), Color(0xFFDC2626)];
    final indices = List.generate(k, (i) => i)
      ..sort((a, b) => centroides[a][0].compareTo(centroides[b][0]));

    for (var orden = 0; orden < indices.length; orden++) {
      final cluster = indices[orden];
      final nombresZona = <String>[];
      for (var i = 0; i < datos.length; i++) {
        if (asignaciones[i] == cluster) nombresZona.add(datos[i].nombre);
      }
      grupos.add(_Grupo(nombres[orden], explicaciones[orden], colores[orden], nombresZona));
    }
    return grupos;
  }

  double _distancia(List<double> a, List<double> b) {
    var suma = 0.0;
    for (var i = 0; i < a.length; i++) {
      final escala = [100.0, 5.0, 100.0][i];
      suma += math.pow((a[i] - b[i]) / escala, 2).toDouble();
    }
    return math.sqrt(suma);
  }

  @override
  Widget build(BuildContext context) {
    final grupos = _calcularGrupos();
    final theme = Theme.of(context);
    final isDark = AppTheme.isDark(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(40) : Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.hub_rounded, size: 20, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Agrupación Inteligente de Zonas (K-Means)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Organiza automáticamente los edificios según su patrón de gasto',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '3 Grupos',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2E2007) : const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? const Color(0xFF854D0E) : const Color(0xFFFDE68A),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 16,
                  color: isDark ? const Color(0xFFFDE047) : const Color(0xFFB45309),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Esta agrupación te ayuda a priorizar el mantenimiento donde más agua se consume.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: isDark ? const Color(0xFFFEF08A) : const Color(0xFF92400E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...grupos.map(
            (grupo) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2D3D) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: grupo.color.withAlpha(60)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: grupo.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              grupo.nombre,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: grupo.color,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${grupo.zonas.length} edificios',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          grupo.explicacion,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: grupo.zonas.map((z) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF283B4F) : Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: theme.colorScheme.outlineVariant),
                              ),
                              child: Text(
                                z,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
