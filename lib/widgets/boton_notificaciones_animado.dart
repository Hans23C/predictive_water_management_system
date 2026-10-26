// APARTADO: Botón animado para consultar notificaciones
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../theme/tema_aplicacion.dart';

/// Acción de notificaciones compartida por los encabezados de administración y mantenimiento.
class AnimatedNotificationButton extends StatefulWidget {
  final int count;
  final VoidCallback? onPressed;

  const AnimatedNotificationButton({super.key, this.count = 3, this.onPressed});

  @override
  State<AnimatedNotificationButton> createState() =>
      _AnimatedNotificationButtonState();
}

class _AnimatedNotificationButtonState extends State<AnimatedNotificationButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  );

  void _play() {
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => _play(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              tooltip: 'Notificaciones',
              onPressed: () {
                _play();
                widget.onPressed?.call();
              },
              icon: SizedBox(
                width: 30,
                height: 30,
                child: Lottie.asset(
                  'assets/lottie/notification.json',
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller.duration = composition.duration;
                    if (widget.count > 0 && !_controller.isAnimating) {
                      _controller.forward(from: 0);
                    }
                  },
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.notifications_active_outlined,
                    color: AppTheme.primary,
                    size: 25,
                  ),
                ),
              ),
            ),
            if (widget.count > 0)
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: AppTheme.error,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      );
}
