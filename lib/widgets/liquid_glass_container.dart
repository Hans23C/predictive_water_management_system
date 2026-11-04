// APARTADO: Contenedor con efecto Liquid Glass (Glassmorphism hidrodinámico)
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'dart:ui';
import 'package:flutter/material.dart';

import '../theme/tema_aplicacion.dart';

class LiquidGlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blurSigma;
  final Color? customBgColor;
  final Border? customBorder;
  final VoidCallback? onTap;

  const LiquidGlassContainer({
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.blurSigma = 12,
    this.customBgColor,
    this.customBorder,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    final defaultBgColor = customBgColor ??
        (isDark
            ? const Color(0xFF132030).withAlpha(190)
            : Colors.white.withAlpha(210));

    final defaultBorder = customBorder ??
        Border.all(
          color: isDark
              ? Colors.white.withAlpha(25)
              : const Color(0xFF0EA5E9).withAlpha(45),
          width: 1.2,
        );

    final containerWidget = Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withAlpha(60)
                : const Color(0xFF087FAD).withAlpha(15),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: defaultBgColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: defaultBorder,
            ),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: containerWidget,
        ),
      );
    }

    return containerWidget;
  }
}
