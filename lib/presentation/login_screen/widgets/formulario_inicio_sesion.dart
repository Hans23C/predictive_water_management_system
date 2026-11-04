// APARTADO: Componente de la aplicación: formulario inicio sesion
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/rutas_aplicacion.dart';
import '../../../theme/tema_aplicacion.dart';
import 'pantalla_carga_inicio_sesion.dart';

class LoginFormWidget extends StatefulWidget {
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final void Function(Future<void> Function(String, String) loginFn)? onRegisterLoginHandler;

  const LoginFormWidget({
    this.emailController,
    this.passwordController,
    this.onRegisterLoginHandler,
    super.key,
  });

  @override
  State<LoginFormWidget> createState() => LoginFormWidgetState();
}

class LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _internalEmailController;
  late final TextEditingController _internalPasswordController;

  TextEditingController get _emailController =>
      widget.emailController ?? _internalEmailController;
  TextEditingController get _passwordController =>
      widget.passwordController ?? _internalPasswordController;

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  static const List<Map<String, String>> _mockUsers = [
    {
      'email': 'admin@aquacampus.edu.co',
      'password': 'Admin#2024',
      'role': 'administrador_general',
      'name': 'Ing. Rodolfo Lucas Parra',
    },
    {
      'email': 'mantenimiento@aquacampus.edu.co',
      'password': 'Mant#2024',
      'role': 'personal_mantenimiento',
      'name': 'Ing. Jesus Vasquez Granda',
    },
  ];

  @override
  void initState() {
    super.initState();
    _internalEmailController = TextEditingController();
    _internalPasswordController = TextEditingController();

    if (widget.onRegisterLoginHandler != null) {
      widget.onRegisterLoginHandler!(loginDirectly);
    }
  }

  @override
  void dispose() {
    _internalEmailController.dispose();
    _internalPasswordController.dispose();
    super.dispose();
  }

  /// Permite iniciar sesión directamente (usado por los botones de 1 clic)
  Future<void> loginDirectly(String email, String password) async {
    _emailController.text = email;
    _passwordController.text = password;
    await _handleLogin();
  }

  Future<void> _handleLogin() async {
    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Navigator.of(context).push<void>(
      PageRouteBuilder<void>(
        opaque: true,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => const LoginLoadingScreen(),
      ),
    );

    if (!mounted) return;

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    final user = _mockUsers
        .where((u) => u['email'] == email && u['password'] == password)
        .firstOrNull;

    if (!mounted) return;

    if (user == null) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Credenciales no reconocidas. Usa los botones de acceso rápido para ingresar directamente.';
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'session_token',
      'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
    await prefs.setString('user_role', user['role']!);
    await prefs.setString('user_name', user['name']!);
    await prefs.setString('user_email', user['email']!);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (user['role'] == 'administrador_general') {
      context.go(AppRoutes.adminDashboardScreen);
    } else {
      context.go(AppRoutes.maintenanceDashboardScreen);
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor escribe tu correo';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Por favor ingresa un correo válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor escribe tu contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = AppTheme.isDark(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      color: const Color(0xFF0EA5E9).withAlpha(40),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.lock_person_rounded,
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
                      'Iniciar Sesión',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -0.4,
                      ),
                    ),
                    Text(
                      'Ingresa tus credenciales o accede en 1 clic abajo',
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
          const SizedBox(height: 20),

          // Aviso de error accesible
          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF450A0A) : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppTheme.error.withAlpha(90),
                  width: 1.2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppTheme.error,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        color: isDark ? const Color(0xFFFCA5A5) : AppTheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _errorMessage = null),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Campo de correo institucional
          TextFormField(
            controller: _emailController,
            validator: _validateEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: 'Correo institucional',
              hintText: 'ejemplo@aquacampus.edu.co',
              filled: true,
              fillColor: isDark
                  ? const Color(0xFF131F2E).withAlpha(180)
                  : const Color(0xFFF1F5F9).withAlpha(220),
              prefixIcon: Icon(
                Icons.alternate_email_rounded,
                color: isDark ? AppTheme.primaryLight : AppTheme.primary,
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: theme.colorScheme.outlineVariant.withAlpha(isDark ? 50 : 80),
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF38BDF8) : AppTheme.primary,
                  width: 2,
                ),
              ),
            ),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          // Campo de contraseña
          TextFormField(
            controller: _passwordController,
            validator: _validatePassword,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(),
            decoration: InputDecoration(
              labelText: 'Contraseña de acceso',
              hintText: 'Ingresa tu clave',
              filled: true,
              fillColor: isDark
                  ? const Color(0xFF131F2E).withAlpha(180)
                  : const Color(0xFFF1F5F9).withAlpha(220),
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: isDark ? AppTheme.primaryLight : AppTheme.primary,
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: theme.colorScheme.outlineVariant.withAlpha(isDark ? 50 : 80),
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF38BDF8) : AppTheme.primary,
                  width: 2,
                ),
              ),
            ),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),

          // Enlace de ayuda
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Puedes usar los botones directos abajo para ingresar sin clave.',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: isDark ? AppTheme.primaryLight : AppTheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              ),
              child: Text(
                '¿Olvidaste tu contraseña?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Botón principal de Iniciar Sesión con gradiente hidro-luminoso
          Container(
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0284C7), const Color(0xFF0EA5E9), const Color(0xFF38BDF8)]
                    : [const Color(0xFF0369A1), const Color(0xFF0284C7), const Color(0xFF0EA5E9)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? const Color(0xFF0284C7) : const Color(0xFF0369A1))
                      .withAlpha(90),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isLoading ? null : _handleLogin,
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Iniciar Sesión',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
