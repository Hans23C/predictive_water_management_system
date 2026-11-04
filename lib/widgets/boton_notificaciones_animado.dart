// APARTADO: Botón animado para consultar notificaciones con Lottie
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../theme/tema_aplicacion.dart';

/// Acción de notificaciones compartida con animación Lottie (notification.json)
class AnimatedNotificationButton extends StatefulWidget {
  final int count;
  final VoidCallback? onPressed;
  final double size;
  final EdgeInsetsGeometry? margin;

  const AnimatedNotificationButton({
    super.key,
    this.count = 3,
    this.onPressed,
    this.size = 38,
    this.margin,
  });

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
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Container(
      margin: widget.margin,
      child: Tooltip(
        message: 'Centro de Alertas y Notificaciones',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _play();
              widget.onPressed?.call();
            },
            borderRadius: BorderRadius.circular(widget.size / 2),
            child: MouseRegion(
              onEnter: (_) => _play(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
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
                              ? const Color(0xFF38BDF8).withAlpha(30)
                              : const Color(0xFF0284C7).withAlpha(20),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Center(
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
                          color: isDark ? const Color(0xFF38BDF8) : AppTheme.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  if (widget.count > 0)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.error,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? const Color(0xFF131F2E) : Colors.white,
                            width: 1.5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x44DC2626),
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Center(
                          child: Text(
                            widget.count > 9 ? '9+' : '${widget.count}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
