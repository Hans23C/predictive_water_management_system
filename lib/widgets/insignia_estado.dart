// APARTADO: Componente de la aplicación: insignia estado
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/tema_aplicacion.dart';

class StatusBadgeWidget extends StatelessWidget {
  final String label;
  final String status;
  final double fontSize;
  final bool showDot;

  const StatusBadgeWidget({
    required this.label,
    required this.status,
    this.fontSize = 11,
    this.showDot = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = AppTheme.statusContainerColor(status);
    final textColor = AppTheme.statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.withAlpha(50),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: textColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: textColor.withAlpha(120),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
