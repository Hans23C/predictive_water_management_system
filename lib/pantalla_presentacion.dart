// APARTADO: Pantalla de presentación e inicio de la aplicación
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({super.key, required this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigationTimer?.cancel();
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    _navigationTimer = Timer(
      Duration(milliseconds: reduceMotion ? 300 : 3450),
      _continue,
    );
    if (reduceMotion && _controller.value != 1) _controller.value = 1;
  }

  void _continue() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (_, animation, __) => widget.nextScreen,
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return Scaffold(
      backgroundColor: const Color(0xFF03111F),
      body: Semantics(
        label: 'HYDROINTELLIGENT, gestión inteligente del agua. Cargando aplicación.',
        liveRegion: true,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.12),
                  radius: 0.9,
                  colors: [
                    Color(0xFF0B3550),
                    Color(0xFF061C30),
                    Color(0xFF020A13),
                  ],
                  stops: [0, .52, 1],
                ),
              ),
            ),
            if (!reduceMotion)
              AnimatedBuilder(
                animation: _controller,
                builder: (_, __) => CustomPaint(
                  painter: _WaterParticlePainter(progress: _controller.value),
                ),
              ),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final reveal = Curves.easeOutBack.transform(
                    ((_controller.value - .12) / .42).clamp(0.0, 1.0),
                  );
                  final glow = Curves.easeInOut.transform(
                    ((_controller.value - .25) / .35).clamp(0.0, 1.0),
                  );
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: math.min(
                          MediaQuery.sizeOf(context).width * .62,
                          300,
                        ),
                        height: math.min(
                          MediaQuery.sizeOf(context).width * .62,
                          300,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.scale(
                              scale: .45 + glow * .95,
                              child: Opacity(
                                opacity: (1 - glow).clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(
                                        0xFF43D9FF,
                                      ).withValues(alpha: .8),
                                      width: 1.5,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x553AD8FF),
                                        blurRadius: 36,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Transform.rotate(
                              angle: (1 - reveal) * -.16,
                              child: Transform.scale(
                                scale: .72 + .28 * reveal,
                                child: Opacity(
                                  opacity: reveal,
                                  child: Container(
                                    padding: const EdgeInsets.all(22),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF19C8F4,
                                          ).withValues(alpha: .18 * glow),
                                          blurRadius: 60 * glow,
                                          spreadRadius: 8 * glow,
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'assets/images/logo_sin_fondo.png',
                                      fit: BoxFit.contain,
                                      filterQuality: FilterQuality.high,
                                      excludeFromSemantics: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Opacity(
                        opacity: Curves.easeOut.transform(
                          ((_controller.value - .58) / .2).clamp(0.0, 1.0),
                        ),
                        child: const Text(
                          'AQUACAMPUS',
                          style: TextStyle(
                            color: Color(0xFFF1FBFF),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 9),
                      Opacity(
                        opacity: Curves.easeOut.transform(
                          ((_controller.value - .68) / .18).clamp(0.0, 1.0),
                        ),
                        child: const Text(
                          'CADA GOTA CUENTA',
                          style: TextStyle(
                            color: Color(0xFF74D9F3),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            if (!reduceMotion)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 38),
                  child: SizedBox(
                    width: 54,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (_, __) => LinearProgressIndicator(
                          value: _controller.value,
                          minHeight: 2,
                          backgroundColor: const Color(0xFF24475D),
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF54DFFF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WaterParticlePainter extends CustomPainter {
  const _WaterParticlePainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (var ring = 0; ring < 3; ring++) {
      final phase = (progress * 1.3 + ring / 3) % 1;
      final radius = 36 + phase * math.min(size.width, size.height) * .58;
      final alpha = ((1 - phase) * 95).round().clamp(0, 255);
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = const Color(0xFF3DD8FF).withAlpha(alpha),
      );
    }
    for (var i = 0; i < 30; i++) {
      final seed = i * 2.399963;
      final phase = (progress * (.12 + (i % 5) * .025) + i / 30) % 1;
      final radius = 45 + phase * math.min(size.width, size.height) * .48;
      final point =
          center + Offset(math.cos(seed) * radius, math.sin(seed) * radius);
      final alpha = ((1 - phase) * 150).round().clamp(0, 255);
      canvas.drawCircle(
        point,
        1 + (i % 3) * .45,
        Paint()..color = const Color(0xFF7DEAFF).withAlpha(alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaterParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
