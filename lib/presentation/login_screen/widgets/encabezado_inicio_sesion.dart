// APARTADO: Componente de la aplicación: encabezado inicio sesion
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/tema_aplicacion.dart';
import '../../../widgets/boton_tema_animado.dart';

class LoginHeaderWidget extends StatefulWidget {
  final bool compact;

  const LoginHeaderWidget({this.compact = false, super.key});

  @override
  State<LoginHeaderWidget> createState() => _LoginHeaderWidgetState();
}

class _LoginHeaderWidgetState extends State<LoginHeaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = widget.compact ? 190.0 : 255.0;
    final isDark = AppTheme.isDark(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            width: double.infinity,
            height: headerHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? const [
                        Color(0xFF031424),
                        Color(0xFF06233B),
                        Color(0xFF0C3B5E),
                        Color(0xFF0284C7),
                      ]
                    : const [
                        Color(0xFF04213F),
                        Color(0xFF063B69),
                        Color(0xFF087FAD),
                        Color(0xFF0EA5E9),
                      ],
                stops: const [0.0, 0.35, 0.75, 1.0],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33087FAD),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Círculos de luz ambiental decorativos
                Positioned(
                  top: -40,
                  right: -30,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withAlpha(15),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -20,
                  left: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF14B8A6).withAlpha(20),
                    ),
                  ),
                ),

                // Botón superior de alternancia de Modo Oscuro / Claro en la pantalla de bienvenida con animación fluida
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  right: 14,
                  child: const AnimatedThemeToggleButton(size: 38),
                ),

                // Contenido central animado
                Center(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _AnimatedBrandLogo(compact: widget.compact),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'HYDRO',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: widget.compact ? 22 : 26,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              Text(
                                'INTELLIGENT',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: widget.compact ? 22 : 26,
                                  fontWeight: FontWeight.w300,
                                  color: const Color(0xFF67E8F9),
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(25),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withAlpha(50),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.eco_rounded,
                                  size: 13,
                                  color: Color(0xFF67E8F9),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Cada gota cuenta · Sistema de Conservación y Telemetría',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedBrandLogo extends StatefulWidget {
  final bool compact;
  const _AnimatedBrandLogo({required this.compact});

  @override
  State<_AnimatedBrandLogo> createState() => _AnimatedBrandLogoState();
}

class _AnimatedBrandLogoState extends State<_AnimatedBrandLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.compact ? 78.0 : 100.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -3 * _controller.value),
        child: Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(25),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withAlpha(140), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF67E8F9).withAlpha(
                  40 + (_controller.value * 50).round(),
                ),
                blurRadius: 16 + _controller.value * 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/hydrointelligent_logo.png',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.water_drop_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
