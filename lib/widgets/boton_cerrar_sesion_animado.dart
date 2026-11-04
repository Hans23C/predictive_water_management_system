// APARTADO: Botón animado para cerrar sesión con Lottie
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedLogoutButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double size;
  final EdgeInsetsGeometry? margin;

  const AnimatedLogoutButton({
    super.key,
    required this.onPressed,
    this.size = 38,
    this.margin,
  });

  @override
  State<AnimatedLogoutButton> createState() => _AnimatedLogoutButtonState();
}

class _AnimatedLogoutButtonState extends State<AnimatedLogoutButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  void _animate() => _controller.forward(from: 0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: widget.margin,
      child: Tooltip(
        message: 'Cerrar sesión de forma segura',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _animate();
              widget.onPressed();
            },
            borderRadius: BorderRadius.circular(widget.size / 2),
            child: MouseRegion(
              onEnter: (_) => _animate(),
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? const Color(0xFF2A1515).withAlpha(190)
                      : const Color(0xFFFEE2E2).withAlpha(180),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFFEF4444).withAlpha(70)
                        : const Color(0xFFDC2626).withAlpha(50),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withAlpha(isDark ? 25 : 15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(5),
                child: Center(
                  child: Lottie.asset(
                    'assets/lottie/logout.json',
                    controller: _controller,
                    onLoaded: (composition) =>
                        _controller.duration = composition.duration,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFDC2626),
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
  }
}
