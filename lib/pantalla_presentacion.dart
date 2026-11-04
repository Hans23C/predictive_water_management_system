// APARTADO: Pantalla de presentación (Splash) fluida, optimizada y sin bloqueos
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'routes/rutas_aplicacion.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Redirección ultra rápida y sin trabas (1.3 segundos)
    _redirectTimer = Timer(const Duration(milliseconds: 1350), _checkSessionAndNavigate);
  }

  Future<void> _checkSessionAndNavigate() async {
    if (!mounted) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('session_token');
      final role = prefs.getString('user_role');

      if (!mounted) return;

      if (token != null && role != null) {
        if (role == 'administrador_general') {
          context.go(AppRoutes.adminDashboardScreen);
        } else {
          context.go(AppRoutes.maintenanceDashboardScreen);
        }
      } else {
        context.go(AppRoutes.loginScreen);
      }
    } catch (_) {
      if (mounted) context.go(AppRoutes.loginScreen);
    }
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07131F),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo degradado oceánico profundo
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.2),
                radius: 1.1,
                colors: [
                  Color(0xFF0E304A),
                  Color(0xFF071927),
                  Color(0xFF030A12),
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),

          // Contenido central animado con logo nítido
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Anillo de luz líquida y contenedor del logo
                    Container(
                      width: 130,
                      height: 130,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF087FAD).withAlpha(35),
                        border: Border.all(
                          color: const Color(0xFF38BDF8).withAlpha(120),
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x550EA5E9),
                            blurRadius: 36,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo_sin_fondo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.water_drop_rounded,
                          color: Color(0xFF38BDF8),
                          size: 64,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Título de la marca
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'HYDRO',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          'INTELLIGENT',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 26,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFF38BDF8),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Frase de concientización corporativa
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Monitoreo Predictivo para la Preservación y Eficiencia Hídrica',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF94A3B8),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Barra indicadora de carga sutil
                    SizedBox(
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: const LinearProgressIndicator(
                          minHeight: 2.5,
                          backgroundColor: Color(0xFF1E2D3D),
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Pie con versión institucional
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'AquaCampus Telemetry System · v2.0',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 10,
                  color: Colors.white.withAlpha(90),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
