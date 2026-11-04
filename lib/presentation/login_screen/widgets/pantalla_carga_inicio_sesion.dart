// APARTADO: Componente de la aplicación: pantalla carga inicio sesion
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginLoadingScreen extends StatefulWidget {
  const LoginLoadingScreen({super.key});

  @override
  State<LoginLoadingScreen> createState() => _LoginLoadingScreenState();
}

class _LoginLoadingScreenState extends State<LoginLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _reducedMotionTimer;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  void _startAnimation(LottieComposition composition) {
    if (_hasStarted || !mounted) return;
    _hasStarted = true;
    _controller.duration = composition.duration;

    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 0;
      _reducedMotionTimer = Timer(composition.duration, _closeScreen);
      return;
    }

    _controller.forward().whenComplete(_closeScreen);
  }

  void _closeScreen() {
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _reducedMotionTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final side = math.min(MediaQuery.sizeOf(context).width * .78, 360.0);

    return Scaffold(
      backgroundColor: const Color(0xFF061B2B),
      body: Semantics(
        label: 'Verificando acceso. Espera un momento.',
        liveRegion: true,
        child: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -.15),
              radius: 1.05,
              colors: [Color(0xFF123F58), Color(0xFF071E30), Color(0xFF03111D)],
              stops: [0, .58, 1],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ExcludeSemantics(
                  child: Lottie.asset(
                    'assets/lottie/login_loading.json',
                    controller: _controller,
                    width: side,
                    height: side,
                    fit: BoxFit.contain,
                    onLoaded: _startAnimation,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'VERIFICANDO ACCESO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Un momento, por favor',
                  style: TextStyle(
                    color: Color(0xFF9FC5D6),
                    fontSize: 13,
                    letterSpacing: .3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
