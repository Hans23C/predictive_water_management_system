// APARTADO: Botón animado para registrar incidentes
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/tema_aplicacion.dart';

/// Acción para registrar incidentes con pulso al pasar el cursor o pulsar.
class AnimatedIncidentButton extends StatefulWidget {
  final VoidCallback onPressed;
  const AnimatedIncidentButton({super.key, required this.onPressed});

  @override
  State<AnimatedIncidentButton> createState() => _AnimatedIncidentButtonState();
}

class _AnimatedIncidentButtonState extends State<AnimatedIncidentButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
    lowerBound: 0.0,
    upperBound: 1.0,
  );
  bool _hovered = false;

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) { setState(() => _hovered = true); _controller.repeat(reverse: true); },
      onExit: (_) { setState(() => _hovered = false); _controller.stop(); _controller.value = 0; },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: 1 + (_hovered ? _controller.value * .045 : 0),
          child: FloatingActionButton.extended(
            heroTag: 'maintenance-register-incident',
            onPressed: () { _controller.forward(from: 0); widget.onPressed(); },
            icon: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(35 + (_controller.value * 45).round()),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_alert_rounded, size: 21),
            ),
            label: Text('Registrar incidente', style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w700)),
            backgroundColor: const Color(0xFF087F8C),
            foregroundColor: Colors.white,
            elevation: _hovered ? 8 : 4,
          ),
        ),
      ),
    );
  }
}
