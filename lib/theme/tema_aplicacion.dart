// APARTADO: Colores, tipografía y estilos globales de la aplicación
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  // Clave de persistencia para el tema
  static const String _prefKeyTheme = 'hydro_theme_mode_v2';

  // Notificador global para alternar tema dinámicamente en toda la aplicación
  static final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  /// Inicializa la preferencia de tema guardada en el dispositivo
  static Future<void> initTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_prefKeyTheme);
      if (isDark != null) {
        themeModeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
      }
    } catch (_) {
      // Valor predeterminado en caso de fallo
    }
  }

  /// Alterna entre modo claro y modo oscuro guardando la preferencia
  static Future<void> toggleTheme() async {
    final nextMode = themeModeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    themeModeNotifier.value = nextMode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefKeyTheme, nextMode == ThemeMode.dark);
    } catch (_) {}
  }

  /// Consulta si el contexto actual está usando tema oscuro
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  // Paleta principal: tonos verde azulado, cian y agua.
  static const Color primary = Color(0xFF087FAD);
  static const Color primaryLight = Color(0xFF38BDF8);
  static const Color primaryContainer = Color(0xFFCDEFF7);
  static const Color secondary = Color(0xFF12A9B7);
  static const Color secondaryContainer = Color(0xFFD5F7F7);

  // Colores semánticos para estados y alertas.
  static const Color success = Color(0xFF16A34A);
  static const Color successContainer = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFDC2626);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF0284C7);
  static const Color infoContainer = Color(0xFFE0F2FE);

  // Superficies claras.
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF1F5F9);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color outlineLight = Color(0xFFCBD5E1);
  static const Color outlineVariantLight = Color(0xFFE2E8F0);

  // Superficies oscuras refinadas para monitoreo y control industrial.
  static const Color surfaceDark = Color(0xFF131F2E);
  static const Color surfaceVariantDark = Color(0xFF1A2B3C);
  static const Color backgroundDark = Color(0xFF0A121C);
  static const Color outlineDark = Color(0xFF2E4154);
  static const Color outlineVariantDark = Color(0xFF1E2D3D);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: primary,
          onPrimary: Colors.white,
          primaryContainer: primaryContainer,
          onPrimaryContainer: Color(0xFF003848),
          secondary: secondary,
          onSecondary: Colors.white,
          secondaryContainer: secondaryContainer,
          onSecondaryContainer: Color(0xFF003D34),
          surface: surfaceLight,
          onSurface: Color(0xFF0F172A),
          surfaceContainerHighest: surfaceVariantLight,
          onSurfaceVariant: Color(0xFF475569),
          error: error,
          onError: Colors.white,
          errorContainer: errorContainer,
          onErrorContainer: Color(0xFF7F1D1D),
          outline: outlineLight,
          outlineVariant: outlineVariantLight,
        ),
        scaffoldBackgroundColor: backgroundLight,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          const TextTheme(
            displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w300),
            displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w300),
            displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
            headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
            headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: surfaceLight,
          foregroundColor: const Color(0xFF0F172A),
          elevation: 0,
          scrolledUnderElevation: 1,
          surfaceTintColor: primary,
          centerTitle: false,
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
        cardTheme: CardThemeData(
          color: surfaceLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: outlineVariantLight, width: 1),
          ),
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: outlineLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: outlineVariantLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: error),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: const TextStyle(color: Color(0xFF475569)),
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: surfaceLight,
          indicatorColor: primaryContainer,
          surfaceTintColor: primary,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: primary,
              );
            }
            return GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: primary, size: 24);
            }
            return const IconThemeData(color: Color(0xFF64748B), size: 24);
          }),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: primaryLight,
          onPrimary: Color(0xFF032231),
          primaryContainer: Color(0xFF0B3A4F),
          onPrimaryContainer: Color(0xFFBAE6FD),
          secondary: Color(0xFF2DD4BF),
          onSecondary: Color(0xFF042F2E),
          secondaryContainer: Color(0xFF115E59),
          onSecondaryContainer: Color(0xFF99F6E4),
          surface: surfaceDark,
          onSurface: Color(0xFFF1F5F9),
          surfaceContainerHighest: surfaceVariantDark,
          onSurfaceVariant: Color(0xFF94A3B8),
          error: Color(0xFFF87171),
          onError: Color(0xFF450A0A),
          errorContainer: Color(0xFF7F1D1D),
          onErrorContainer: Color(0xFFFEE2E2),
          outline: outlineDark,
          outlineVariant: outlineVariantDark,
        ),
        scaffoldBackgroundColor: backgroundDark,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          const TextTheme(
            displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w300, color: Color(0xFFF1F5F9)),
            displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w300, color: Color(0xFFF1F5F9)),
            displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: Color(0xFFF1F5F9)),
            headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
            headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
            headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
            titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
            titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
            titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
            bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFFE2E8F0)),
            bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFFE2E8F0)),
            bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF94A3B8)),
            labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
            labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFCBD5E1)),
            labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8)),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: surfaceDark,
          foregroundColor: const Color(0xFFF1F5F9),
          elevation: 0,
          scrolledUnderElevation: 1,
          surfaceTintColor: primaryLight,
          centerTitle: false,
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFF1F5F9),
          ),
        ),
        cardTheme: CardThemeData(
          color: surfaceDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: outlineVariantDark, width: 1),
          ),
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceVariantDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: outlineDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: outlineVariantDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primaryLight, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFF87171)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
          hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryLight,
            foregroundColor: const Color(0xFF032231),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: surfaceDark,
          indicatorColor: const Color(0xFF0B3A4F),
          surfaceTintColor: primaryLight,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: primaryLight,
              );
            }
            return GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF94A3B8),
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: primaryLight, size: 24);
            }
            return const IconThemeData(color: Color(0xFF94A3B8), size: 24);
          }),
        ),
      );

  // Métodos auxiliares para los colores semánticos con contraste adaptativo.
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
      case 'operativo':
        return success;
      case 'warning':
      case 'advertencia':
        return warning;
      case 'critical':
      case 'crítico':
        return error;
      case 'offline':
      case 'inactivo':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }

  static Color statusContainerColor(String status, [BuildContext? context]) {
    final dark = context != null && isDark(context);
    switch (status.toLowerCase()) {
      case 'normal':
      case 'operativo':
        return dark ? const Color(0xFF052E16) : successContainer;
      case 'warning':
      case 'advertencia':
        return dark ? const Color(0xFF451A03) : warningContainer;
      case 'critical':
      case 'crítico':
        return dark ? const Color(0xFF450A0A) : errorContainer;
      case 'offline':
      case 'inactivo':
        return dark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6);
      default:
        return dark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6);
    }
  }
}
