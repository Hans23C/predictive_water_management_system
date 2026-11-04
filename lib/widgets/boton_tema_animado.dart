// APARTADO: Botón interactivo con animación fluida para alternar Modo Claro / Oscuro
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/tema_aplicacion.dart';

class AnimatedThemeToggleButton extends StatefulWidget {
  final double size;
  final EdgeInsetsGeometry? margin;

  const AnimatedThemeToggleButton({
    this.size = 38,
    this.margin,
    super.key,
  });

  @override
  State<AnimatedThemeToggleButton> createState() =>
      _AnimatedThemeToggleButtonState();
}

class _AnimatedThemeToggleButtonState extends State<AnimatedThemeToggleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _rotationAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.82)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.82, end: 1.14)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.14, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0);
    AppTheme.toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, themeMode, _) {
        final isDark = themeMode == ThemeMode.dark;

        return Container(
          margin: widget.margin,
          child: Tooltip(
            message: isDark
                ? 'Cambiar a Modo Claro (Diurno)'
                : 'Cambiar a Modo Oscuro (Nocturno)',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _handleTap,
                borderRadius: BorderRadius.circular(widget.size / 2),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnim.value,
                      child: Transform.rotate(
                        angle: _rotationAnim.value * 2 * math.pi,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? const Color(0xFF1E2D3D).withAlpha(180)
                          : const Color(0xFFE2E8F0).withAlpha(160),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF38BDF8).withAlpha(80)
                            : const Color(0xFF0EA5E9).withAlpha(60),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? const Color(0xFF38BDF8).withAlpha(40)
                              : const Color(0xFFF59E0B).withAlpha(35),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: ScaleTransition(scale: anim, child: child),
                        ),
                        child: isDark
                            ? const Icon(
                                Icons.light_mode_rounded,
                                key: ValueKey('light_icon'),
                                color: Color(0xFFFACC15),
                                size: 19,
                              )
                            : const Icon(
                                Icons.dark_mode_rounded,
                                key: ValueKey('dark_icon'),
                                color: Color(0xFF0F172A),
                                size: 19,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
