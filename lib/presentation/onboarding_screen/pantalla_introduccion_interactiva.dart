// APARTADO: Pantalla de Introducción Guiada e Interactiva (Onboarding)
// Diseñada especialmente para personas no familiarizadas con aplicaciones móviles.
// Explica el propósito del sistema con lenguaje cotidiano, ilustraciones amigables y controles claros.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/rutas_aplicacion.dart';
import '../../theme/tema_aplicacion.dart';
import '../../widgets/liquid_glass_container.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingItem> _items = const [
    _OnboardingItem(
      title: '¡Te damos la bienvenida a HydroIntelligent!',
      subtitle: 'El cuidado del agua de tu campus en la palma de tu mano.',
      description:
          'Monitoreamos tinacos, cisternas y tuberías en tiempo real. Ahora podrás saber cuánta agua hay y si el suministro está garantizado sin necesidad de subir a revisar techos o cuartos de máquinas.',
      icon: Icons.water_drop_rounded,
      iconColor: Color(0xFF38BDF8),
      badgeText: 'Fácil de usar · Sin complicaciones',
      lottieAsset: 'assets/lottie/logo.json',
    ),
    _OnboardingItem(
      title: 'Entiende todo con colores tipo semáforo',
      subtitle: 'Verde es normal, amarillo atención y rojo urgente.',
      description:
          'No te preocupes por números complicados. Si una bomba se apaga o la cisterna baja de nivel, la app te avisará con colores claros y alertas sencillas para actuar a tiempo.',
      icon: Icons.traffic_rounded,
      iconColor: Color(0xFF10B981),
      badgeText: 'Visual · Para todos los niveles',
      lottieAsset: 'assets/lottie/notification.json',
    ),
    _OnboardingItem(
      title: 'Detectamos fugas antes de que se desperdicie agua',
      subtitle: 'La inteligencia artificial cuida cada gota por ti.',
      description:
          'Comparamos el consumo de agua entre edificios. Si un sanitario tiene una fuga o se rompe una tubería oculta, el sistema te mostrará qué edificio necesita revisión.',
      icon: Icons.shield_rounded,
      iconColor: Color(0xFFF59E0B),
      badgeText: 'Ahorro y Prevención Inteligente',
      lottieAsset: 'assets/lottie/logo.json',
    ),
    _OnboardingItem(
      title: 'Acceso directo en 1 toque y soporte continuo',
      subtitle: 'Sin necesidad de memorizar contraseñas.',
      description:
          '¿Solo quieres probar la app? Toca los botones de acceso rápido de demostración en el inicio de sesión. Además, cuentas con botones de ayuda en cada pantalla para resolver dudas al instante.',
      icon: Icons.touch_app_rounded,
      iconColor: Color(0xFF6366F1),
      badgeText: 'Acceso Instantáneo',
      lottieAsset: 'assets/lottie/login_loading.json',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('visto_onboarding', true);

    if (!mounted) return;

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
  }

  void _nextPage() {
    if (_currentPage < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);
    final theme = Theme.of(context);
    final isLastPage = _currentPage == _items.length - 1;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo degradado sutil con efecto de agua ambiental
          Positioned(
            top: -100,
            left: -60,
            child: IgnorePointer(
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (isDark ? const Color(0xFF0284C7) : const Color(0xFF38BDF8))
                          .withAlpha(isDark ? 55 : 30),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -60,
            child: IgnorePointer(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (isDark ? const Color(0xFF0D9488) : const Color(0xFF14B8A6))
                          .withAlpha(isDark ? 50 : 25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Barra superior del onboarding con botón Saltar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo institucional pequeño
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.primary.withAlpha(30),
                            ),
                            child: Icon(
                              Icons.water_drop_rounded,
                              color: theme.colorScheme.primary,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'HYDROINTELLIGENT',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      // Botón para saltar la intro
                      TextButton(
                        onPressed: _completeOnboarding,
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.onSurfaceVariant,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Saltar intro',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Carrusel de diapositivas
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 580),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              // Contenedor visual destacado con animación Lottie o icono
                              LiquidGlassContainer(
                                borderRadius: 32,
                                blurSigma: 14,
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  children: [
                                    // Insignia temática
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: item.iconColor.withAlpha(30),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: item.iconColor.withAlpha(80),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        item.badgeText,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: item.iconColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    // Lottie animado con fallback
                                    SizedBox(
                                      width: 180,
                                      height: 180,
                                      child: Lottie.asset(
                                        item.lottieAsset,
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) => Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: item.iconColor.withAlpha(25),
                                          ),
                                          child: Icon(
                                            item.icon,
                                            size: 80,
                                            color: item.iconColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 28),

                              // Título principal claro y grande
                              Text(
                                item.title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: theme.colorScheme.onSurface,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Subtítulo con mensaje clave
                              Text(
                                item.subtitle,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Descripción con lenguaje cotidiano
                              Text(
                                item.description,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  height: 1.5,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Controles de navegación inferiores (Indicador + Botón Siguiente)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 580),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Puntos indicadores de página
                        Row(
                          children: List.generate(_items.length, (index) {
                            final isActive = index == _currentPage;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: isActive ? 28 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant.withAlpha(70),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),

                        // Botón de acción principal ("Siguiente" / "¡Comenzar ahora!")
                        ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: isLastPage ? 28 : 22,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 3,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isLastPage ? '¡Comenzar ahora!' : 'Siguiente',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                isLastPage
                                    ? Icons.check_circle_rounded
                                    : Icons.arrow_forward_rounded,
                                size: 18,
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
          ),
        ],
      ),
    );
  }
}

class _OnboardingItem {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color iconColor;
  final String badgeText;
  final String lottieAsset;

  const _OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.badgeText,
    required this.lottieAsset,
  });
}
