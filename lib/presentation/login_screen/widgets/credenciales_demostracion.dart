// APARTADO: Componente de la aplicación: credenciales demostracion con acceso en 1 clic
// Diseñado para personas poco familiarizadas con contraseñas: permite entrar de inmediato tocando una tarjeta.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/tema_aplicacion.dart';
import '../../../widgets/liquid_glass_container.dart';

class DemoCredentialsWidget extends StatelessWidget {
  final void Function(String email, String password)? onSelectAccount;
  final void Function(String email, String password)? onQuickLogin;

  const DemoCredentialsWidget({
    this.onSelectAccount,
    this.onQuickLogin,
    super.key,
  });

  static const List<Map<String, String>> _demoAccounts = [
    {
      'role': 'Administrador General',
      'title': 'Ingresar como Administrador',
      'subtitle': 'Para supervisores y directores: ver gráficas generales de consumo y alertas del campus.',
      'tag': '1 Clic · Modo Director',
      'email': 'admin@aquacampus.edu.co',
      'password': 'Admin#2024',
      'icon': 'admin',
    },
    {
      'role': 'Personal de Mantenimiento',
      'title': 'Ingresar como Técnico',
      'subtitle': 'Para personal de campo: monitorear bombas de agua, presiones y reportes de fugas.',
      'tag': '1 Clic · Modo Operador',
      'email': 'mantenimiento@aquacampus.edu.co',
      'password': 'Mant#2024',
      'icon': 'maintenance',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = AppTheme.isDark(context);

    return LiquidGlassContainer(
      borderRadius: 22,
      blurSigma: 16,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF0284C7), const Color(0xFF38BDF8)]
                        : [const Color(0xFF087FAD), const Color(0xFF0EA5E9)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0EA5E9).withAlpha(45),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.touch_app_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Acceso Rápido en 1 Toque',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      '¿No quieres escribir? Toca una opción para entrar directamente:',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ...List.generate(_demoAccounts.length, (i) {
            final account = _demoAccounts[i];
            final isAdmin = account['icon'] == 'admin';
            final roleColor = isAdmin
                ? (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7))
                : (isDark ? const Color(0xFF34D399) : const Color(0xFF059669));

            return Padding(
              padding: EdgeInsets.only(
                bottom: i < _demoAccounts.length - 1 ? 14 : 0,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    if (onQuickLogin != null) {
                      onQuickLogin!(account['email']!, account['password']!);
                    } else if (onSelectAccount != null) {
                      onSelectAccount!(account['email']!, account['password']!);
                    }
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF132235).withAlpha(200)
                          : Colors.white.withAlpha(230),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: roleColor.withAlpha(isDark ? 110 : 80),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: roleColor.withAlpha(isDark ? 28 : 16),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: roleColor.withAlpha(30),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: roleColor.withAlpha(70),
                              width: 1.2,
                            ),
                          ),
                          child: Icon(
                            isAdmin
                                ? Icons.admin_panel_settings_rounded
                                : Icons.engineering_rounded,
                            size: 24,
                            color: roleColor,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      account['title']!,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: roleColor.withAlpha(25),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      account['tag']!,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: roleColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                account['subtitle']!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  color: theme.colorScheme.onSurfaceVariant,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: roleColor.withAlpha(20),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: roleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 14),
          // Nota de transparencia con opción de copiar si se desea
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
                ),
                const SizedBox(width: 6),
                Text(
                  'Datos cargados con lecturas simuladas del campus',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant.withAlpha(180),
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
