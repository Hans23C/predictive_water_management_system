// APARTADO: Animaciones reutilizables del sistema de agua
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/tema_aplicacion.dart';

/// Indicador animado de cisterna reutilizable. [level] representa un nivel entre 0 y 1.
class CisternLevelAnimation extends StatefulWidget {
  const CisternLevelAnimation({super.key, this.level = 0.68});

  final double level;

  @override
  State<CisternLevelAnimation> createState() => _CisternLevelAnimationState();
}

class _CisternLevelAnimationState extends State<CisternLevelAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final level = widget.level.clamp(0.0, 1.0);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 104,
            height: 112,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CustomPaint(
                painter: _CisternPainter(
                  level: level,
                  phase: _controller.value,
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cisterna principal',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${(level * 100).round()}%',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 27,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Nivel de almacenamiento',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: level,
                    minHeight: 6,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CisternPainter extends CustomPainter {
  const _CisternPainter({required this.level, required this.phase});
  final double level;
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final tank = Rect.fromLTWH(
      size.width * .19,
      size.height * .08,
      size.width * .62,
      size.height * .84,
    );
    final radius = RRect.fromRectAndRadius(tank, const Radius.circular(12));
    canvas.drawRRect(radius, Paint()..color = AppTheme.primary.withAlpha(18));
    canvas.save();
    canvas.clipRRect(radius);
    final waterTop = tank.bottom - tank.height * level;
    final waterPath = Path()..moveTo(tank.left, waterTop);
    for (var i = 0; i <= 24; i++) {
      final x = tank.left + tank.width * i / 24;
      final y =
          waterTop +
          math.sin((i / 24 * math.pi * 2) + phase * math.pi * 2) * 2.2;
      waterPath.lineTo(x, y);
    }
    waterPath
      ..lineTo(tank.right, tank.bottom)
      ..lineTo(tank.left, tank.bottom)
      ..close();
    canvas.drawPath(
      waterPath,
      Paint()..color = AppTheme.primary.withAlpha(190),
    );
    canvas.restore();
    canvas.drawRRect(
      radius,
      Paint()
        ..color = AppTheme.primary.withAlpha(125)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final cap = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * .34, 2, size.width * .32, 7),
      const Radius.circular(4),
    );
    canvas.drawRRect(cap, Paint()..color = AppTheme.primary);
    for (var i = 1; i <= 3; i++) {
      final y = tank.bottom - tank.height * i / 4;
      canvas.drawLine(
        Offset(tank.right - 9, y),
        Offset(tank.right - 4, y),
        Paint()
          ..color = Colors.white.withAlpha(170)
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CisternPainter oldDelegate) =>
      oldDelegate.level != level || oldDelegate.phase != phase;
}

/// Tubería minimalista con marcas de agua en movimiento; [isFlowing] en falso pausa la animación.
class WaterFlowAnimation extends StatefulWidget {
  const WaterFlowAnimation({super.key, this.isFlowing = true});
  final bool isFlowing;

  @override
  State<WaterFlowAnimation> createState() => _WaterFlowAnimationState();
}

class _WaterFlowAnimationState extends State<WaterFlowAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  @override
  void initState() {
    super.initState();
    if (widget.isFlowing) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant WaterFlowAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlowing) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.water_drop_outlined,
                size: 18,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Flujo de distribución',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                widget.isFlowing ? 'ACTIVO' : 'PAUSADO',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: widget.isFlowing
                      ? AppTheme.success
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 42,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CustomPaint(
                painter: _PipePainter(
                  phase: _controller.value,
                  isFlowing: widget.isFlowing,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PipePainter extends CustomPainter {
  const _PipePainter({required this.phase, required this.isFlowing});
  final double phase;
  final bool isFlowing;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final pipePaint = Paint()
      ..color = AppTheme.primary.withAlpha(55)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(10, y), Offset(size.width - 10, y), pipePaint);
    canvas.drawLine(
      Offset(10, y),
      Offset(size.width - 10, y),
      Paint()
        ..color = AppTheme.primary.withAlpha(120)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
    for (var i = 0; i < 5; i++) {
      final t = (i / 5 + phase) % 1;
      final x = 12 + t * (size.width - 24);
      final alpha = isFlowing ? 230 : 90;
      canvas.drawCircle(
        Offset(x, y),
        3.2,
        Paint()..color = AppTheme.primary.withAlpha(alpha),
      );
    }
    for (final x in [size.width * .32, size.width * .68]) {
      canvas.drawLine(
        Offset(x, y - 8),
        Offset(x, y + 8),
        Paint()
          ..color = AppTheme.primary.withAlpha(110)
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PipePainter oldDelegate) =>
      oldDelegate.phase != phase || oldDelegate.isFlowing != isFlowing;
}
