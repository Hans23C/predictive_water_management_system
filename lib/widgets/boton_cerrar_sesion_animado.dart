// APARTADO: Botón animado para cerrar sesión
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedLogoutButton extends StatefulWidget {
  final VoidCallback onPressed;
  const AnimatedLogoutButton({super.key, required this.onPressed});

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
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => _animate(),
        child: IconButton(
          tooltip: 'Cerrar sesión',
          onPressed: () { _animate(); widget.onPressed(); },
          icon: SizedBox(
            width: 30,
            height: 30,
            child: Lottie.asset(
              'assets/lottie/logout.json',
              controller: _controller,
              onLoaded: (composition) => _controller.duration = composition.duration,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.logout_rounded),
            ),
          ),
        ),
      );
}
