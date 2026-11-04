// APARTADO: Pantalla de Ajustes y Perfil de Mantenimiento con Foto de Perfil
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/rutas_aplicacion.dart';
import '../../theme/tema_aplicacion.dart';
import '../../widgets/barra_superior_aplicacion.dart';
import '../../widgets/guia_rapida_dialogo.dart';
import '../../widgets/liquid_glass_container.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const String _prefKeyAvatarIndex = 'hydro_profile_avatar_index';
  static const String _prefKeyTechnicianPhone = 'hydro_technician_phone';

  String _name = 'Ing. Jesus Vasquez Granda';
  String _role = 'personal_mantenimiento';
  String _email = 'mantenimiento@aquacampus.edu.co';
  String _phone = '+52 55 9876 5432';
  int _avatarIndex = 0;
  bool _soundAlerts = true;
  String _syncInterval = '1 minuto';

  // Íconos y colores para simular fotos de perfil personalizadas
  static const List<Map<String, dynamic>> _avatarPresets = [
    {'icon': Icons.engineering_rounded, 'color': Color(0xFF0284C7), 'name': 'Casco Técnico'},
    {'icon': Icons.person_rounded, 'color': Color(0xFF10B981), 'name': 'Operativo'},
    {'icon': Icons.account_circle_rounded, 'color': Color(0xFF6366F1), 'name': 'Supervisor'},
    {'icon': Icons.security_rounded, 'color': Color(0xFFF59E0B), 'name': 'Seguridad'},
    {'icon': Icons.water_drop_rounded, 'color': Color(0xFF06B6D4), 'name': 'Hidráulica'},
    {'icon': Icons.speed_rounded, 'color': Color(0xFFEC4899), 'name': 'Telemetría'},
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('user_name') ?? 'Ing. Jesus Vasquez Granda';
      _role = prefs.getString('user_role') ?? 'personal_mantenimiento';
      _email = prefs.getString('user_email') ?? 'mantenimiento@aquacampus.edu.co';
      _phone = prefs.getString(_prefKeyTechnicianPhone) ?? '+52 55 9876 5432';
      _avatarIndex = (prefs.getInt(_prefKeyAvatarIndex) ?? 0).clamp(0, _avatarPresets.length - 1);
    });
  }

  Future<void> _saveAvatarIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKeyAvatarIndex, index);
    setState(() => _avatarIndex = index);
  }

  void _showAvatarSelector() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Seleccionar Foto / Avatar de Perfil',
                style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Elige tu distintivo de técnico para identificación en reportes y bitácoras.',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: _avatarPresets.length,
                itemBuilder: (context, i) {
                  final item = _avatarPresets[i];
                  final isSelected = _avatarIndex == i;
                  final Color itemColor = item['color'];

                  return GestureDetector(
                    onTap: () {
                      _saveAvatarIndex(i);
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: itemColor.withAlpha(isSelected ? 40 : 15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? itemColor : theme.colorScheme.outlineVariant,
                          width: isSelected ? 2.5 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item['icon'], color: itemColor, size: 32),
                          const SizedBox(height: 6),
                          Text(
                            item['name'],
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = AppTheme.isDark(context);
    final avatarData = _avatarPresets[_avatarIndex];
    final Color avatarColor = avatarData['color'];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const AppBarWidget(
        title: 'Ajustes y Perfil Operativo',
        subtitle: 'Control de Personal y Preferencias del Sistema',
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 850;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 24 : 16,
                    vertical: 16,
                  ).copyWith(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Tarjeta de Perfil del Técnico Liquid Glass
                      LiquidGlassContainer(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Foto / Avatar con botón de edición
                                Stack(
                                  children: [
                                    Container(
                                      width: 76,
                                      height: 76,
                                      decoration: BoxDecoration(
                                        color: avatarColor.withAlpha(30),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: avatarColor, width: 2.5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: avatarColor.withAlpha(50),
                                            blurRadius: 16,
                                          ),
                                        ],
                                      ),
                                      child: Icon(avatarData['icon'], size: 40, color: avatarColor),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: _showAvatarSelector,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 1.5),
                                          ),
                                          child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            _name,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              color: theme.colorScheme.onSurface,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF0EA5E9)),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _role == 'administrador_general'
                                            ? 'Administrador General · Sistema Hídrico'
                                            : 'Técnico Especialista en Mantenimiento Hidráulico',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          color: theme.colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppTheme.success.withAlpha(25),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Turno Activo · En Guardia Campus',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.success,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            const Divider(height: 1),
                            const SizedBox(height: 14),

                            // Datos de Contacto y Licencia
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _profileStat('ID Operador', 'TEC-2024-HI'),
                                _profileStat('Teléfono', _phone),
                                _profileStat('Guardia', '07:00 - 15:00'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Centro de Aprendizaje y Ayuda para Principiantes
                      _sectionTitle('Centro de Ayuda y Aprendizaje'),
                      const SizedBox(height: 10),
                      LiquidGlassContainer(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withAlpha(25),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.school_rounded, color: theme.colorScheme.primary),
                              ),
                              title: Text(
                                'Ver Presentación y Tutorial Guiado',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                              ),
                              subtitle: Text(
                                'Vuelve a ver la explicación de 4 pasos sobre cómo funciona la app.',
                                style: GoogleFonts.plusJakartaSans(fontSize: 12),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15),
                              onTap: () => context.push(AppRoutes.onboardingScreen),
                            ),
                            const Divider(height: 1),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withAlpha(25),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.help_outline_rounded, color: Color(0xFF10B981)),
                              ),
                              title: Text(
                                'Guía Rápida: ¿Cómo interpretar los datos?',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                              ),
                              subtitle: Text(
                                'Explicación sencilla de qué significan los niveles, presiones y bombas.',
                                style: GoogleFonts.plusJakartaSans(fontSize: 12),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15),
                              onTap: () => GuiaRapidaDialogo.show(context),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Preferencias del Sistema Liquid Glass
                      _sectionTitle('Preferencias de Interfaz y Telemetría'),
                      const SizedBox(height: 10),
                      LiquidGlassContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          children: [
                            // Selector de Modo Oscuro / Claro
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                                color: isDark ? const Color(0xFFFACC15) : AppTheme.primary,
                              ),
                              title: Text(
                                'Modo Oscuro',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                isDark ? 'Activado · Protege tu vista' : 'Desactivado · Modo diurno',
                                style: GoogleFonts.plusJakartaSans(fontSize: 12),
                              ),
                              trailing: Switch(
                                value: isDark,
                                onChanged: (_) => AppTheme.toggleTheme(),
                              ),
                            ),
                            const Divider(height: 1),

                            // Frecuencia de Sincronización
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.sync_rounded, color: AppTheme.primary),
                              title: Text(
                                'Frecuencia de Telemetría ESP32',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                'Actualizar lecturas cada: $_syncInterval',
                                style: GoogleFonts.plusJakartaSans(fontSize: 12),
                              ),
                              trailing: DropdownButton<String>(
                                value: _syncInterval,
                                underline: const SizedBox(),
                                items: const [
                                  DropdownMenuItem(value: '30 seg', child: Text('30 seg')),
                                  DropdownMenuItem(value: '1 minuto', child: Text('1 min')),
                                  DropdownMenuItem(value: '5 minutos', child: Text('5 min')),
                                ],
                                onChanged: (v) => setState(() => _syncInterval = v!),
                              ),
                            ),
                            const Divider(height: 1),

                            // Alertas Sonoras
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.volume_up_rounded, color: AppTheme.secondary),
                              title: Text(
                                'Alarmas Sonoras en Presión Crítica',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                'Emitir aviso cuando la presión baje de 2.0 bar',
                                style: GoogleFonts.plusJakartaSans(fontSize: 12),
                              ),
                              trailing: Switch(
                                value: _soundAlerts,
                                onChanged: (v) => setState(() => _soundAlerts = v),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Gestión de Sesión
                      _sectionTitle('Seguridad y Sesión'),
                      const SizedBox(height: 10),
                      LiquidGlassContainer(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.mail_outline_rounded),
                              title: const Text('Correo Institucional'),
                              subtitle: Text(_email),
                            ),
                            const Divider(height: 1),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => AppBarWidget.showLogoutDialog(context),
                                icon: const Icon(Icons.logout_rounded, color: AppTheme.error),
                                label: Text(
                                  'Cerrar Sesión Segura',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.error,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppTheme.error),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _profileStat(String label, String value) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.ibmPlexMono(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
