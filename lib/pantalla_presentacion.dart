// APARTADO: Pantalla de presentación (Splash) fluida, enriquecida y visualmente atractiva
// Incorpora animación del logo, resplandor líquido y redirección inteligente al Onboarding.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'routes/rutas_aplicacion.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _fadeController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _fadeController.forward();

    // Tiempo prudencial para apreciar la bienvenida (1.6 segundos) o tocar para continuar
    _redirectTimer = Timer(const Duration(milliseconds: 1650), _checkSessionAndNavigate);
  }

  Future<void> _checkSessionAndNavigate() async {
    if (!mounted) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding = prefs.getBool('visto_onboarding') ?? false;

      if (!mounted) return;

      // Si es la primera vez que abre la app, mostrar el Onboarding interactivo
      if (!hasSeenOnboarding) {
        context.go(AppRoutes.onboardingScreen);
        return;
      }

      final token = prefs.getString('session_token');
      final role = prefs.getString('user_role');

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
      if (mounted) context.go(AppRoutes.onboardingScreen);
    }
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07131F),
      body: InkWell(
        onTap: () {
          _redirectTimer?.cancel();
          _checkSessionAndNavigate();
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Fondo degradado oceánico profundo
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.15),
                  radius: 1.15,
                  colors: [
                    Color(0xFF0F3B5C),
                    Color(0xFF071B2B),
                    Color(0xFF020912),
                  ],
                  stops: [0.0, 0.58, 1.0],
                ),
              ),
            ),

            // Ondas de resplandor líquido animadas
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = 1.0 + (_pulseController.value * 0.08);
                return Center(
                  child: Container(
                    width: 220 * scale,
                    height: 220 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF38BDF8).withAlpha(
                            (35 + (20 * _pulseController.value)).toInt(),
                          ),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Contenido central animado con Logo y Lottie
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Contenedor del logo con efecto cristal líquido
                      Container(
                        width: 140,
                        height: 140,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF087FAD).withAlpha(35),
                          border: Border.all(
                            color: const Color(0xFF38BDF8).withAlpha(140),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0EA5E9).withAlpha(80),
                              blurRadius: 42,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Lottie.asset(
                            'assets/lottie/logo.json',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Image.asset(
                              'assets/images/logo_sin_fondo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.water_drop_rounded,
                                color: Color(0xFF38BDF8),
                                size: 68,
                              ),
                            ),
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
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 2.0,
                            ),
                          ),
                          Text(
                            'INTELLIGENT',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 28,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFF38BDF8),
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Frase de concientización corporativa
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36),
                        child: Text(
                          'Monitoreo Inteligente para el Cuidado y Preservación del Agua',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF94A3B8),
                            letterSpacing: 0.5,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Barra indicadora de carga sutil
                      SizedBox(
                        width: 140,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: const LinearProgressIndicator(
                            minHeight: 3.0,
                            backgroundColor: Color(0xFF1E2D3D),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Pie con versión institucional y toque para saltar
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'AquaCampus Telemetry System · v2.0\n(Toca la pantalla para continuar)',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    height: 1.4,
                    color: Colors.white.withAlpha(90),
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
