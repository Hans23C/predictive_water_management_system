// APARTADO: Modal de ayuda y guía rápida para usuarios no técnicos
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/tema_aplicacion.dart';

class GuiaRapidaDialogo extends StatelessWidget {
  const GuiaRapidaDialogo({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => const GuiaRapidaDialogo(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = AppTheme.isDark(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: theme.colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Encabezado con icono amigable
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF0284C7), const Color(0xFF0D9488)]
                            : [const Color(0xFF087FAD), const Color(0xFF14B8A6)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.help_outline_rounded,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Guía Rápida del Sistema',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'Aprende a interpretar tus datos en 1 minuto',
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
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Cerrar guía',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Contenido con scroll
              Expanded(
                child: ListView(
                  children: [
                    _buildSectionHeader(
                      context,
                      icon: Icons.traffic_rounded,
                      title: '1. Semáforo de Colores (¿Cómo está mi agua?)',
                    ),
                    const SizedBox(height: 8),
                    _buildColorCard(
                      context,
                      color: AppTheme.success,
                      bgColor: isDark ? const Color(0xFF052E16) : const Color(0xFFDCFCE7),
                      title: 'Verde (Normal)',
                      desc: 'Todo funciona en perfectas condiciones. Las bombas operan y la cisterna tiene agua suficiente.',
                    ),
                    const SizedBox(height: 6),
                    _buildColorCard(
                      context,
                      color: AppTheme.warning,
                      bgColor: isDark ? const Color(0xFF451A03) : const Color(0xFFFEF3C7),
                      title: 'Amarillo (Atención Preventiva)',
                      desc: 'La presión ha variado un poco o el nivel está disminuyendo. Conviene revisar antes de que falte agua.',
                    ),
                    const SizedBox(height: 6),
                    _buildColorCard(
                      context,
                      color: AppTheme.error,
                      bgColor: isDark ? const Color(0xFF450A0A) : const Color(0xFFFEE2E2),
                      title: 'Rojo (Alerta Inmediata)',
                      desc: 'Se detectó una falla o presión crítica. El personal de mantenimiento debe atender la zona indicada.',
                    ),
                    const SizedBox(height: 18),

                    _buildSectionHeader(
                      context,
                      icon: Icons.water_drop_rounded,
                      title: '2. Indicadores Principales Explicados',
                    ),
                    const SizedBox(height: 8),
                    _buildIndicatorCard(
                      context,
                      title: 'Nivel de Cisterna (%)',
                      desc: 'Indica cuánta agua tenemos almacenada. Entre 50% y 100% es óptimo. Menos del 25% activa la alarma de reserva.',
                    ),
                    const SizedBox(height: 6),
                    _buildIndicatorCard(
                      context,
                      title: 'Presión en "bar"',
                      desc: 'Es la fuerza con la que corre el agua en las tuberías. Lo ideal es entre 3.0 y 4.2 bar para que llegue bien a todos los pisos.',
                    ),
                    const SizedBox(height: 6),
                    _buildIndicatorCard(
                      context,
                      title: 'Bombas en Servicio',
                      desc: 'Muestra cuáles motores están encendidos impulsando el agua hacia los edificios del campus.',
                    ),
                    const SizedBox(height: 18),

                    _buildSectionHeader(
                      context,
                      icon: Icons.touch_app_rounded,
                      title: '3. Acciones Frecuentes',
                    ),
                    const SizedBox(height: 8),
                    _buildActionTip(
                      context,
                      icon: Icons.brightness_6_rounded,
                      text: 'Toca el ícono de Sol/Luna en la barra superior para cambiar a modo claro u oscuro según tu comodidad.',
                    ),
                    const SizedBox(height: 6),
                    _buildActionTip(
                      context,
                      icon: Icons.file_download_outlined,
                      text: 'El botón de descarga en el panel administrativo guarda todas las lecturas directamente en un archivo Excel.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Entendido, ¡gracias!',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context,
      {required IconData icon, required String title}) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorCard(
    BuildContext context, {
    required Color color,
    required Color bgColor,
    required String title,
    required String desc,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(90)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 3),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorCard(
    BuildContext context, {
    required String title,
    required String desc,
  }) {
    final theme = Theme.of(context);
    final isDark = AppTheme.isDark(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            desc,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTip(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
