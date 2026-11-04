// APARTADO: Panel principal del personal de mantenimiento responsivo y adaptativo
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/tema_aplicacion.dart';
import '../../widgets/barra_superior_aplicacion.dart';
import '../../widgets/boton_registrar_incidente_animado.dart';
import '../../widgets/animaciones_sistema_agua.dart';
import '../../widgets/guia_rapida_dialogo.dart';
import 'widgets/resumen_alertas_mantenimiento.dart';
import 'widgets/grafica_presion_mantenimiento.dart';
import 'widgets/lista_bombas_mantenimiento.dart';
import 'widgets/tarjetas_resumen_mantenimiento.dart';

class MaintenanceDashboardScreen extends StatefulWidget {
  const MaintenanceDashboardScreen({super.key});

  @override
  State<MaintenanceDashboardScreen> createState() =>
      _MaintenanceDashboardScreenState();
}

class _MaintenanceDashboardScreenState
    extends State<MaintenanceDashboardScreen> {
  String _userName = 'Técnico';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _userName = prefs.getString('user_name') ?? 'Técnico';
      });
    }
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstName = _userName.split(' ').last;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: 'Panel de Mantenimiento',
        subtitle: 'Turno activo — $firstName',
        actions: [
          AppBarActionButton(
            tooltip: 'Guía de ayuda',
            onPressed: () => GuiaRapidaDialogo.show(context),
            icon: Icons.help_outline_rounded,
          ),
          AppBarActionButton(
            icon: Icons.refresh_rounded,
            onPressed: _handleRefresh,
            tooltip: 'Actualizar telemetría',
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: theme.colorScheme.primary,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 800;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1240),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 24 : 16,
                      vertical: 16,
                    ).copyWith(bottom: 100),
                    child: isWide
                        ? _buildWideContent(context)
                        : _buildMobileContent(context),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: AnimatedIncidentButton(
        onPressed: () => _showLogIncidentSheet(context),
      ),
    );
  }

  Widget _buildMobileContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        _AvisoLecturasDemostracion(),
        SizedBox(height: 14),
        MaintenanceHeroAlertsWidget(),
        SizedBox(height: 16),
        CisternLevelAnimation(),
        SizedBox(height: 14),
        WaterFlowAnimation(),
        SizedBox(height: 20),
        _SectionLabel(text: 'Estado y Telemetría de Bombas'),
        SizedBox(height: 10),
        MaintenancePumpListWidget(),
        SizedBox(height: 20),
        _SectionLabel(text: 'Presión por Zona — Turno Actual'),
        SizedBox(height: 10),
        MaintenancePressureChartWidget(),
        SizedBox(height: 20),
        _SectionLabel(text: 'Resumen Operativo del Turno'),
        SizedBox(height: 10),
        MaintenanceSummaryCardsWidget(),
      ],
    );
  }

  Widget _buildWideContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _AvisoLecturasDemostracion(),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Columna Izquierda: Alertas críticas, Cisterna y Bombas
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  MaintenanceHeroAlertsWidget(),
                  SizedBox(height: 16),
                  CisternLevelAnimation(),
                  SizedBox(height: 14),
                  WaterFlowAnimation(),
                  SizedBox(height: 20),
                  _SectionLabel(text: 'Estado y Telemetría de Bombas'),
                  SizedBox(height: 10),
                  MaintenancePumpListWidget(),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Columna Derecha: Presiones y Resumen
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  _SectionLabel(text: 'Presión por Zona — Turno Actual'),
                  SizedBox(height: 10),
                  MaintenancePressureChartWidget(),
                  SizedBox(height: 20),
                  _SectionLabel(text: 'Resumen Operativo del Turno'),
                  SizedBox(height: 10),
                  MaintenanceSummaryCardsWidget(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showLogIncidentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _LogIncidentSheet(),
    );
  }
}

class _AvisoLecturasDemostracion extends StatelessWidget {
  const _AvisoLecturasDemostracion();

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2E2007) : const Color(0xFFFFFBEB),
        border: Border.all(
          color: isDark ? const Color(0xFF854D0E) : const Color(0xFFFDE68A),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: isDark ? const Color(0xFFFDE047) : const Color(0xFFB45309),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Modo Demostración Activo: Información de presiones y caudales simulada. Al conectar el ESP32 se mostrará la telemetría viva del campus.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                color: isDark ? const Color(0xFFFEF08A) : const Color(0xFF92400E),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 16.5,
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}

class _LogIncidentSheet extends StatefulWidget {
  @override
  State<_LogIncidentSheet> createState() => _LogIncidentSheetState();
}

class _LogIncidentSheetState extends State<_LogIncidentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  String? _selectedZone;
  String? _selectedSeverity;
  bool _isSubmitting = false;

  static const List<String> _zones = [
    'Z-01 — Edificio A',
    'Z-02 — Edificio B',
    'Z-03 — Edificio C',
    'Z-04 — Edificio D',
    'Z-05 — Edificio E',
    'Z-06 — Cafetería',
  ];

  static const List<String> _severities = [
    'Crítico (Atención urgente)',
    'Advertencia (Revisión preventiva)',
    'Informativo (Bitácora rutinaria)',
  ];

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Registrar Incidente en el Campus',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Reporta cualquier anomalía de tuberías, bombas o fugas',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedZone,
              decoration: const InputDecoration(
                labelText: 'Zona del campus afectada',
                prefixIcon: Icon(Icons.map_outlined, size: 20),
              ),
              items: _zones
                  .map(
                    (z) => DropdownMenuItem(
                      value: z,
                      child: Text(
                        z,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13.5),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedZone = v),
              validator: (v) => v == null ? 'Por favor selecciona la zona' : null,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _selectedSeverity,
              decoration: const InputDecoration(
                labelText: 'Nivel de urgencia',
                prefixIcon: Icon(Icons.warning_amber_outlined, size: 20),
              ),
              items: _severities
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(
                        s,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13.5),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedSeverity = v),
              validator: (v) => v == null ? 'Por favor selecciona el nivel' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '¿Qué ocurrió? (Descripción breve)',
                alignLabelWithHint: true,
                hintText: 'Ej. Fuga en llave de paso del piso 2 o bomba haciendo ruido.',
              ),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Por favor describe brevemente el problema'
                  : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isSubmitting = true);
                          await Future.delayed(
                            const Duration(milliseconds: 700),
                          );
                          if (context.mounted) {
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                              msg: 'Incidente registrado exitosamente',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: AppTheme.success,
                              textColor: Colors.white,
                            );
                          }
                        }
                      },
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'Guardar Reporte',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
