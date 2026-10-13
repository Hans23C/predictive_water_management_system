import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class StatusBadgeWidget extends StatelessWidget {
  final String label;
  final String status;
  final double fontSize;

  const StatusBadgeWidget({
    required this.label,
    required this.status,
    this.fontSize = 11,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = AppTheme.statusContainerColor(status);
    final textColor = AppTheme.statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.ibmPlexSans(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
