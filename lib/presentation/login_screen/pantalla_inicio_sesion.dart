// APARTADO: Pantalla de inicio de sesión responsiva y adaptativa
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/rutas_aplicacion.dart';
import '../../theme/tema_aplicacion.dart';
import '../../widgets/liquid_glass_container.dart';
import './widgets/credenciales_demostracion.dart';
import './widgets/formulario_inicio_sesion.dart';
import './widgets/encabezado_inicio_sesion.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  Future<void> Function(String, String)? _directLoginHandler;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillCredentials(String email, String password) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
    });
  }

  void _executeQuickLogin(String email, String password) {
    if (_directLoginHandler != null) {
      _directLoginHandler!(email, password);
    } else {
      _fillCredentials(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = AppTheme.isDark(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Orbes de luz ambiental líquida para estética moderna
          Positioned(
            top: -120,
            left: -80,
            child: IgnorePointer(
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (isDark ? const Color(0xFF0284C7) : const Color(0xFF38BDF8))
                          .withAlpha(isDark ? 50 : 35),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: -100,
            child: IgnorePointer(
              child: Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (isDark ? const Color(0xFF0D9488) : const Color(0xFF14B8A6))
                          .withAlpha(isDark ? 40 : 25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 280,
            right: -50,
            child: IgnorePointer(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (isDark ? const Color(0xFF6366F1) : const Color(0xFF818CF8))
                          .withAlpha(isDark ? 25 : 18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 700;

                if (isWide) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 580),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const LoginHeaderWidget(compact: true),
                            const SizedBox(height: 20),
                            LiquidGlassContainer(
                              borderRadius: 24,
                              blurSigma: 16,
                              padding: const EdgeInsets.all(28),
                              child: LoginFormWidget(
                                emailController: _emailController,
                                passwordController: _passwordController,
                                onRegisterLoginHandler: (fn) => _directLoginHandler = fn,
                              ),
                            ),
                            const SizedBox(height: 24),
                            DemoCredentialsWidget(
                              onSelectAccount: _fillCredentials,
                              onQuickLogin: _executeQuickLogin,
                            ),
                            const SizedBox(height: 18),
                            TextButton.icon(
                              onPressed: () => context.push(AppRoutes.onboardingScreen),
                              icon: const Icon(Icons.help_outline_rounded, size: 18),
                              label: Text(
                                '¿Primera vez aquí? Ver presentación guiada',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                // Diseño Móvil fluido
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const LoginHeaderWidget(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 14),
                            LiquidGlassContainer(
                              borderRadius: 22,
                              blurSigma: 16,
                              padding: const EdgeInsets.all(22),
                              child: LoginFormWidget(
                                emailController: _emailController,
                                passwordController: _passwordController,
                                onRegisterLoginHandler: (fn) => _directLoginHandler = fn,
                              ),
                            ),
                            const SizedBox(height: 20),
                            DemoCredentialsWidget(
                              onSelectAccount: _fillCredentials,
                              onQuickLogin: _executeQuickLogin,
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              onPressed: () => context.push(AppRoutes.onboardingScreen),
                              icon: const Icon(Icons.help_outline_rounded, size: 18),
                              label: Text(
                                '¿Primera vez aquí? Ver presentación guiada',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 36),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
