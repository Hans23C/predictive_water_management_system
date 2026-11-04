// APARTADO: Componente de la aplicación: credenciales demostracion con acceso en 1 clic
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      'subtitle': 'Gobernanza del recurso hídrico, analítica predictiva y reportes',
      'email': 'admin@aquacampus.edu.co',
      'password': 'Admin#2024',
      'icon': 'admin',
    },
    {
      'role': 'Personal de Mantenimiento',
      'title': 'Ingresar como Mantenimiento',
      'subtitle': 'Control de bombeo, regulación de presiones y atención técnica',
      'email': 'mantenimiento@aquacampus.edu.co',
      'password': 'Mant#2024',
      'icon': 'maintenance',
    },
  ];

  void _copyToClipboard(BuildContext context, String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    Fluttertoast.showToast(
      msg: '$label copiado al portapapeles',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.primary,
      textColor: Colors.white,
      fontSize: 12.5,
    );
  }

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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF0284C7), const Color(0xFF38BDF8)]
                        : [const Color(0xFF087FAD), const Color(0xFF0EA5E9)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0EA5E9).withAlpha(40),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.vpn_key_rounded,
                  color: Colors.white,
                  size: 17,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Acceso Rápido en 1 Clic',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      'Selecciona un perfil para ingresar sin escribir credenciales',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
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
                bottom: i < _demoAccounts.length - 1 ? 12 : 0,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (onQuickLogin != null) {
                      onQuickLogin!(account['email']!, account['password']!);
                    } else if (onSelectAccount != null) {
                      onSelectAccount!(account['email']!, account['password']!);
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF131F2E).withAlpha(160)
                          : Colors.white.withAlpha(200),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: roleColor.withAlpha(isDark ? 90 : 60),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: roleColor.withAlpha(isDark ? 20 : 12),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: roleColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: roleColor.withAlpha(50),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            isAdmin
                                ? Icons.admin_panel_settings_rounded
                                : Icons.engineering_rounded,
                            size: 22,
                            color: roleColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                account['title']!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                account['subtitle']!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: theme.colorScheme.onSurfaceVariant,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () {
                            if (onQuickLogin != null) {
                              onQuickLogin!(account['email']!, account['password']!);
                            } else if (onSelectAccount != null) {
                              onSelectAccount!(account['email']!, account['password']!);
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: roleColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Entrar',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_rounded, size: 13),
                            ],
                          ),
                        ),
                        const SizedBox(width: 2),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 15),
                          color: theme.colorScheme.onSurfaceVariant,
                          tooltip: 'Copiar correo',
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(6),
                          onPressed: () => _copyToClipboard(
                            context,
                            account['email']!,
                            'Correo de ${account['role']}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),

          // Tarjeta de concientización hídrica profesional
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: (isDark ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7))
                  .withAlpha(isDark ? 22 : 14),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7))
                    .withAlpha(isDark ? 50 : 35),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.water_drop_rounded,
                  size: 20,
                  color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Preservar el agua no es solo una tarea técnica, es un compromiso con el futuro de nuestra comunidad.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark ? const Color(0xFFBAE6FD) : const Color(0xFF0369A1),
                      height: 1.35,
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
