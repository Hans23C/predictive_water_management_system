// APARTADO: Animaciones hidráulicas realistas del sistema de agua
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/tema_aplicacion.dart';

/// Indicador animado e interactivo de cisterna con física de fluidos 2.5D.
/// Permite simular el llenado y vaciado dinámico con oleaje multicapa,
/// burbujas ascendentes y chorro de entrada superior.
class CisternLevelAnimation extends StatefulWidget {
  const CisternLevelAnimation({super.key, this.level = 0.68});

  final double level;

  @override
  State<CisternLevelAnimation> createState() => _CisternLevelAnimationState();
}

class _CisternLevelAnimationState extends State<CisternLevelAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _waveController;
  late final AnimationController _bubbleController;
  late double _currentLevel;
  bool _isFilling = false;

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.level.clamp(0.0, 1.0);

    // Controlador para las olas sinusoidales (desfase continuo)
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    // Controlador para las burbujas ascendentes
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant CisternLevelAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.level != widget.level) {
      _animateToLevel(widget.level);
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  void _animateToLevel(double target) {
    final clamped = target.clamp(0.05, 1.0);
    setState(() {
      _isFilling = clamped > _currentLevel;
      _currentLevel = clamped;
    });

    if (_isFilling) {
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (mounted) setState(() => _isFilling = false);
      });
    }
  }

  String _getLevelStatus(double level) {
    if (level >= 0.70) return 'Nivel Óptimo · Reserva Completa';
    if (level >= 0.40) return 'Nivel Normal · Operación Segura';
    if (level >= 0.20) return 'Nivel Medio · Se sugiere recarga';
    return 'Nivel Crítico · Reserva Mínima';
  }

  Color _getStatusColor(double level) {
    if (level >= 0.40) return AppTheme.success;
    if (level >= 0.20) return AppTheme.warning;
    return AppTheme.error;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = AppTheme.isDark(context);
    final statusText = _getLevelStatus(_currentLevel);
    final statusColor = _getStatusColor(_currentLevel);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(50) : const Color(0x0A087FAD),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera informativa con semáforo amigable
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: (isDark ? AppTheme.primaryLight : AppTheme.primary).withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.water_drop_rounded,
                  color: isDark ? AppTheme.primaryLight : AppTheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cisterna Principal de Almacenamiento',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 1),
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
                        Flexible(
                          child: Text(
                            statusText,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Porcentaje grande
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: _currentLevel),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, val, _) => Text(
                  '${(val * 100).round()}%',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppTheme.primaryLight : AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tanque visual con CustomPaint animado
          SizedBox(
            height: 170,
            width: double.infinity,
            child: Row(
              children: [
                // Tanque animado
                Expanded(
                  flex: 5,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_waveController, _bubbleController]),
                    builder: (context, _) => TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: _currentLevel, end: _currentLevel),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOutCubic,
                      builder: (context, animatedLevel, _) {
                        return CustomPaint(
                          size: Size.infinite,
                          painter: _RealisticCisternPainter(
                            level: animatedLevel,
                            wavePhase: _waveController.value,
                            bubblePhase: _bubbleController.value,
                            isFilling: _isFilling,
                            isDark: isDark,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Escala de gradación lateral y métricas
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildScaleIndicator('100%', '35,000 L', _currentLevel >= 0.95),
                      _buildScaleIndicator('75%', '26,250 L', _currentLevel >= 0.70),
                      _buildScaleIndicator('50%', '17,500 L', _currentLevel >= 0.45),
                      _buildScaleIndicator('25%', '8,750 L', _currentLevel >= 0.20),
                      _buildScaleIndicator('0%', 'Reserva baja', true),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Barra de controles interactivos para que cualquier usuario pueda probar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2D3D) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Probar llenado:',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                _buildActionButton(
                  label: '+ Llenar',
                  icon: Icons.arrow_upward_rounded,
                  color: AppTheme.success,
                  onTap: () => _animateToLevel((_currentLevel + 0.18).clamp(0.1, 1.0)),
                ),
                const SizedBox(width: 6),
                _buildActionButton(
                  label: '- Vaciar',
                  icon: Icons.arrow_downward_rounded,
                  color: AppTheme.warning,
                  onTap: () => _animateToLevel((_currentLevel - 0.18).clamp(0.1, 1.0)),
                ),
                const SizedBox(width: 6),
                _buildActionButton(
                  label: '68%',
                  icon: Icons.replay_rounded,
                  color: AppTheme.primary,
                  onTap: () => _animateToLevel(0.68),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScaleIndicator(String pct, String liters, bool reached) {
    final theme = Theme.of(context);
    final isDark = AppTheme.isDark(context);
    final color = reached
        ? (isDark ? AppTheme.primaryLight : AppTheme.primary)
        : theme.colorScheme.onSurfaceVariant.withAlpha(120);

    return Row(
      children: [
        Container(
          width: 8,
          height: 2,
          color: color,
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pct,
              style: GoogleFonts.ibmPlexMono(
                fontSize: 11,
                fontWeight: reached ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
            Text(
              liters,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 9.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withAlpha(80), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pintor Customizado de Cisterna con Oleaje Armónico 2.5D, Burbujas y Vertido
class _RealisticCisternPainter extends CustomPainter {
  final double level;
  final double wavePhase;
  final double bubblePhase;
  final bool isFilling;
  final bool isDark;

  _RealisticCisternPainter({
    required this.level,
    required this.wavePhase,
    required this.bubblePhase,
    required this.isFilling,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dimensiones del contenedor de la cisterna
    final tankRect = Rect.fromLTWH(
      12,
      18,
      size.width - 24,
      size.height - 24,
    );
    final tankRRect = RRect.fromRectAndRadius(tankRect, const Radius.circular(16));

    // Fondo del tanque (interior vacío)
    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF0F1A26) : const Color(0xFFE2E8F0);
    canvas.drawRRect(tankRRect, bgPaint);

    // Guardar estado del canvas para recortar el agua dentro del tanque
    canvas.save();
    canvas.clipRRect(tankRRect);

    // Calcular altura del agua
    final waterHeight = tankRect.height * level;
    final waterSurfaceY = tankRect.bottom - waterHeight;

    // --- CAPA TRASERA DE ONDA (Onda más oscura y profunda) ---
    final backWavePath = Path();
    backWavePath.moveTo(tankRect.left, waterSurfaceY);
    for (double x = tankRect.left; x <= tankRect.right; x += 4) {
      final normalizedX = (x - tankRect.left) / tankRect.width;
      final y = waterSurfaceY +
          math.sin((normalizedX * 2 * math.pi) + (wavePhase * 2 * math.pi)) * 3.5;
      backWavePath.lineTo(x, y);
    }
    backWavePath.lineTo(tankRect.right, tankRect.bottom);
    backWavePath.lineTo(tankRect.left, tankRect.bottom);
    backWavePath.close();

    final backWavePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF0284C7).withAlpha(140), const Color(0xFF075985).withAlpha(180)]
            : [const Color(0xFF0284C7).withAlpha(100), const Color(0xFF0369A1).withAlpha(140)],
      ).createShader(tankRect);
    canvas.drawPath(backWavePath, backWavePaint);

    // --- CAPA DELANTERA DE ONDA (Onda principal con gradiente líquido) ---
    final frontWavePath = Path();
    frontWavePath.moveTo(tankRect.left, waterSurfaceY);
    for (double x = tankRect.left; x <= tankRect.right; x += 4) {
      final normalizedX = (x - tankRect.left) / tankRect.width;
      // Desfase armónico para efecto de profundidad tridimensional
      final y = waterSurfaceY +
          math.cos((normalizedX * 2.5 * math.pi) + (wavePhase * 2 * math.pi) + 1.2) * 4.0;
      frontWavePath.lineTo(x, y);
    }
    frontWavePath.lineTo(tankRect.right, tankRect.bottom);
    frontWavePath.lineTo(tankRect.left, tankRect.bottom);
    frontWavePath.close();

    final frontWavePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [
                const Color(0xFF38BDF8).withAlpha(210),
                const Color(0xFF0284C7).withAlpha(230),
                const Color(0xFF075985).withAlpha(240),
              ]
            : [
                const Color(0xFF38BDF8).withAlpha(190),
                const Color(0xFF0EA5E9).withAlpha(210),
                const Color(0xFF0369A1).withAlpha(230),
              ],
      ).createShader(tankRect);
    canvas.drawPath(frontWavePath, frontWavePaint);

    // Línea brillante en la superficie del agua (crest shine)
    final crestPaint = Paint()
      ..color = Colors.white.withAlpha(isDark ? 160 : 200)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawPath(frontWavePath, crestPaint);

    // --- BURBUJAS PROCEDURALES ASCENDENTES ---
    final bubblePaint = Paint()
      ..color = Colors.white.withAlpha(isDark ? 140 : 180)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 9; i++) {
      final seed = i * 0.73;
      final cycle = (bubblePhase + seed) % 1.0;
      final bubbleX = tankRect.left + (tankRect.width * (0.15 + (i * 0.09) % 0.7));
      final bubbleY = tankRect.bottom - (waterHeight * cycle);

      // Oscilación horizontal natural mientras asciende
      final wiggleX = bubbleX + math.sin(cycle * math.pi * 4 + i) * 3;
      final bubbleRadius = 1.6 + (i % 3) * 0.8;

      if (bubbleY >= waterSurfaceY) {
        canvas.drawCircle(Offset(wiggleX, bubbleY), bubbleRadius, bubblePaint);
      }
    }

    // --- CHORRO DE ENTRADA SUPERIOR CUANDO SE ESTÁ LLENANDO ---
    if (isFilling || level < 0.25) {
      final streamX = tankRect.center.dx - 18;
      final streamRect = Rect.fromLTWH(streamX, 0, 8, waterSurfaceY);
      final streamPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF38BDF8), Colors.white],
        ).createShader(streamRect);
      canvas.drawRRect(
        RRect.fromRectAndRadius(streamRect, const Radius.circular(4)),
        streamPaint,
      );

      // Ondas concéntricas de salpicadura en el punto de contacto
      final splashCenter = Offset(streamX + 4, waterSurfaceY);
      canvas.drawCircle(
        splashCenter,
        6 + (wavePhase * 6),
        Paint()
          ..color = Colors.white.withAlpha((180 * (1 - wavePhase)).round())
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }

    // Reflejo de cristal frontal (brillo vertical diagonal)
    final glassShinePath = Path()
      ..moveTo(tankRect.left + 8, tankRect.top + 6)
      ..lineTo(tankRect.left + 22, tankRect.top + 6)
      ..lineTo(tankRect.left + 14, tankRect.bottom - 8)
      ..lineTo(tankRect.left + 4, tankRect.bottom - 8)
      ..close();
    canvas.drawPath(
      glassShinePath,
      Paint()..color = Colors.white.withAlpha(isDark ? 15 : 40),
    );

    canvas.restore(); // Termina clip

    // Borde exterior del tanque con efecto metálico/cristal
    final borderPaint = Paint()
      ..color = isDark ? const Color(0xFF38BDF8).withAlpha(120) : const Color(0xFF087FAD).withAlpha(100)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(tankRRect, borderPaint);

    // Boquilla / Tapa superior del tanque
    final topCap = RRect.fromRectAndRadius(
      Rect.fromLTWH(tankRect.center.dx - 22, 10, 44, 10),
      const Radius.circular(5),
    );
    final capPaint = Paint()
      ..color = isDark ? const Color(0xFF38BDF8) : const Color(0xFF087FAD);
    canvas.drawRRect(topCap, capPaint);
  }

  @override
  bool shouldRepaint(covariant _RealisticCisternPainter oldDelegate) {
    return oldDelegate.level != level ||
        oldDelegate.wavePhase != wavePhase ||
        oldDelegate.bubblePhase != bubblePhase ||
        oldDelegate.isFilling != isFilling ||
        oldDelegate.isDark != isDark;
  }
}

/// Tubería de cristal con flujo animado en bucle continuo,
/// gradiente de corriente, partículas de agua y manómetro de presión integrado.
class WaterFlowAnimation extends StatefulWidget {
  const WaterFlowAnimation({super.key, this.isFlowing = true});
  final bool isFlowing;

  @override
  State<WaterFlowAnimation> createState() => _WaterFlowAnimationState();
}

class _WaterFlowAnimationState extends State<WaterFlowAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flowController;
  late bool _activeFlow;

  @override
  void initState() {
    super.initState();
    _activeFlow = widget.isFlowing;
    _flowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (_activeFlow) _flowController.repeat();
  }

  @override
  void didUpdateWidget(covariant WaterFlowAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlowing != _activeFlow) {
      _setFlow(widget.isFlowing);
    }
  }

  void _setFlow(bool flowing) {
    setState(() => _activeFlow = flowing);
    if (flowing) {
      if (!_flowController.isAnimating) _flowController.repeat();
    } else {
      _flowController.stop();
    }
  }

  @override
  void dispose() {
    _flowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = AppTheme.isDark(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(50) : const Color(0x0A087FAD),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera con estado y botón interactivo
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: (_activeFlow ? AppTheme.success : theme.colorScheme.onSurfaceVariant)
                      .withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _activeFlow ? Icons.waves_rounded : Icons.pause_circle_outline_rounded,
                  size: 18,
                  color: _activeFlow ? AppTheme.success : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tubería de Distribución Principal',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      _activeFlow
                          ? 'Agua circulando activamente (3.8 bar de presión)'
                          : 'Paso cerrado · Flujo pausado',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: _activeFlow ? AppTheme.success : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Botón interactivo para pausar/activar el flujo
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _setFlow(!_activeFlow),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: (_activeFlow ? AppTheme.primary : theme.colorScheme.outlineVariant)
                          .withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: (_activeFlow ? AppTheme.primary : theme.colorScheme.outlineVariant),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _activeFlow ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          size: 14,
                          color: _activeFlow ? AppTheme.primary : theme.colorScheme.onSurface,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _activeFlow ? 'Pausar' : 'Reanudar',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _activeFlow ? AppTheme.primary : theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Tubería animada con CustomPaint
          SizedBox(
            height: 52,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _flowController,
              builder: (context, _) => CustomPaint(
                painter: _ModernFluidPipePainter(
                  flowPhase: _flowController.value,
                  isFlowing: _activeFlow,
                  isDark: isDark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Pie con leyenda informativa fácil de entender
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.speed_rounded, size: 14, color: AppTheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    'Caudal: ${_activeFlow ? "42.5 L/min" : "0.0 L/min"}',
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Text(
                'Presión de impulsión: ${_activeFlow ? "Estable (3.8 bar)" : "0.0 bar"}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Pintor de Tubería Hidráulica Translúcida con Corriente Líquida en Movimiento
class _ModernFluidPipePainter extends CustomPainter {
  final double flowPhase;
  final bool isFlowing;
  final bool isDark;

  _ModernFluidPipePainter({
    required this.flowPhase,
    required this.isFlowing,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final pipeHeight = 22.0;
    final pipeRect = Rect.fromLTWH(8, centerY - pipeHeight / 2, size.width - 16, pipeHeight);
    final pipeRRect = RRect.fromRectAndRadius(pipeRect, const Radius.circular(11));

    // Fondo del tubo de cristal
    final tubeBgPaint = Paint()
      ..color = isDark ? const Color(0xFF132233) : const Color(0xFFE2E8F0);
    canvas.drawRRect(pipeRRect, tubeBgPaint);

    if (isFlowing) {
      // Guardar para recortar el fluido dentro del tubo
      canvas.save();
      canvas.clipRRect(pipeRRect);

      // Flujo de líquido con gradiente horizontal dinámico
      final liquidPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: isDark
              ? [
                  const Color(0xFF0369A1),
                  const Color(0xFF38BDF8),
                  const Color(0xFF0284C7),
                  const Color(0xFF38BDF8),
                ]
              : [
                  const Color(0xFF0284C7),
                  const Color(0xFF38BDF8),
                  const Color(0xFF0EA5E9),
                  const Color(0xFF7DD3FC),
                ],
        ).createShader(pipeRect);
      canvas.drawRect(pipeRect, liquidPaint);

      // Gotas y pulsos de agua animados en movimiento a lo largo del tubo
      for (int i = 0; i < 7; i++) {
        final t = (i / 7.0 + flowPhase) % 1.0;
        final x = pipeRect.left + t * pipeRect.width;

        // Estela de velocidad (línea horizontal detrás de cada partícula)
        final trailPaint = Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.white.withAlpha(0),
              Colors.white.withAlpha(200),
            ],
          ).createShader(Rect.fromLTWH(x - 22, centerY - 2, 22, 4))
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(Offset(x - 20, centerY), Offset(x, centerY), trailPaint);

        // Partícula brillante
        canvas.drawCircle(
          Offset(x, centerY),
          3.2,
          Paint()..color = Colors.white,
        );
      }

      // Brillo longitudinal superior del tubo de cristal
      final shinePaint = Paint()
        ..color = Colors.white.withAlpha(isDark ? 50 : 90)
        ..strokeWidth = 2;
      canvas.drawLine(
        Offset(pipeRect.left + 8, pipeRect.top + 3),
        Offset(pipeRect.right - 8, pipeRect.top + 3),
        shinePaint,
      );

      canvas.restore();
    }

    // Borde exterior del tubo de cristal
    final tubeOutline = Paint()
      ..color = (isFlowing
              ? (isDark ? const Color(0xFF38BDF8) : const Color(0xFF087FAD))
              : (isDark ? const Color(0xFF334155) : const Color(0xFF94A3B8)))
          .withAlpha(140)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawRRect(pipeRRect, tubeOutline);

    // Abrazaderas metálicas decorativas en la tubería
    final bracketPaint = Paint()
      ..color = isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (final pct in [0.22, 0.50, 0.78]) {
      final bx = pipeRect.left + pipeRect.width * pct;
      canvas.drawLine(Offset(bx, pipeRect.top - 3), Offset(bx, pipeRect.bottom + 3), bracketPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ModernFluidPipePainter oldDelegate) {
    return oldDelegate.flowPhase != flowPhase ||
        oldDelegate.isFlowing != isFlowing ||
        oldDelegate.isDark != isDark;
  }
}
