// APARTADO: Panel principal del personal de mantenimiento
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/rutas_aplicacion.dart';
import '../../theme/tema_aplicacion.dart';
import '../../widgets/barra_superior_aplicacion.dart';
import '../../widgets/boton_notificaciones_animado.dart';
import '../../widgets/boton_cerrar_sesion_animado.dart';
import '../../widgets/boton_registrar_incidente_animado.dart';
import '../../widgets/animaciones_sistema_agua.dart';
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
  // PENDIENTE: incorporar Riverpod o Bloc para administrar el estado en producción.
  String _userName = 'Técnico';
  bool _isRefreshing = false;

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
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _isRefreshing = false);
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Cerrar sesión',
          style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600),
        ),
        content: Text(
          '¿Está seguro que desea cerrar su sesión?',
          style: GoogleFonts.ibmPlexSans(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (mounted) context.go(AppRoutes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final firstName = _userName.split(' ').last;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: 'Panel de Mantenimiento',
        subtitle: 'Turno activo — $firstName',
        actions: [
          AnimatedNotificationButton(count: 3, onPressed: _showNotifications),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _handleRefresh,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          AnimatedLogoutButton(onPressed: _handleLogout),
        ],
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.primary,
          child: isTablet ? _TabletLayout() : _PhoneLayout(),
        ),
      ),
      floatingActionButton: AnimatedIncidentButton(
        onPressed: () => _showLogIncidentSheet(context),
      ),
    );
  }

  void _showNotifications() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [Icon(Icons.notifications_active_outlined, color: AppTheme.primary), SizedBox(width: 10), Flexible(child: Text('Alertas de mantenimiento'))]),
        content: const Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(dense: true, leading: Icon(Icons.error_rounded, color: AppTheme.error), title: Text('Alerta crítica'), subtitle: Text('BOM-003 — presión de 1.8 bar en Cafetería.')),
          Divider(height: 1),
          ListTile(dense: true, leading: Icon(Icons.warning_amber_rounded, color: AppTheme.warning), title: Text('Revisión recomendada'), subtitle: Text('BOM-002 — presión por debajo del nivel habitual.')),
          Divider(height: 1),
          ListTile(dense: true, leading: Icon(Icons.water_drop_outlined, color: AppTheme.info), title: Text('Cisterna principal'), subtitle: Text('Nivel de almacenamiento: 68%.')),
        ]),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar'))],
      ),
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

class _PhoneLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: const [
        MaintenanceHeroAlertsWidget(),
        SizedBox(height: 16),
        CisternLevelAnimation(),
        SizedBox(height: 12),
        WaterFlowAnimation(),
        SizedBox(height: 20),
        _SectionLabel(text: 'Estado de Bombas'),
        SizedBox(height: 10),
        MaintenancePumpListWidget(),
        SizedBox(height: 20),
        _SectionLabel(text: 'Presión por Zona — Hoy'),
        SizedBox(height: 10),
        MaintenancePressureChartWidget(),
        SizedBox(height: 20),
        _SectionLabel(text: 'Resumen de Turnos'),
        SizedBox(height: 10),
        MaintenanceSummaryCardsWidget(),
      ],
    );
  }
}

class _TabletLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 55,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 12, 100),
            children: const [
              MaintenanceHeroAlertsWidget(),
              SizedBox(height: 16),
              CisternLevelAnimation(),
              SizedBox(height: 12),
              WaterFlowAnimation(),
              SizedBox(height: 20),
              _SectionLabel(text: 'Estado de Bombas'),
              SizedBox(height: 10),
              MaintenancePumpListWidget(),
            ],
          ),
        ),
        Expanded(
          flex: 45,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 16, 24, 100),
            children: const [
              _SectionLabel(text: 'Presión por Zona'),
              SizedBox(height: 10),
              MaintenancePressureChartWidget(),
              SizedBox(height: 20),
              _SectionLabel(text: 'Resumen de Turnos'),
              SizedBox(height: 10),
              MaintenanceSummaryCardsWidget(),
            ],
          ),
        ),
      ],
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
      style: GoogleFonts.ibmPlexSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
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
    'Z-01 — Bloque A Ciencias',
    'Z-02 — Biblioteca Central',
    'Z-03 — Cafetería Norte',
    'Z-04 — Bloque B Ingeniería',
    'Z-05 — Residencias',
    'Z-06 — Campo Deportivo',
  ];

  static const List<String> _severities = [
    'Crítico',
    'Advertencia',
    'Informativo',
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
                  color: theme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Registrar incidente',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedZone,
              decoration: InputDecoration(
                labelText: 'Zona afectada',
                prefixIcon: const Icon(Icons.map_outlined, size: 20),
              ),
              items: _zones
                  .map(
                    (z) => DropdownMenuItem(
                      value: z,
                      child: Text(
                        z,
                        style: GoogleFonts.ibmPlexSans(fontSize: 14),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedZone = v),
              validator: (v) => v == null ? 'Seleccione una zona' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedSeverity,
              decoration: InputDecoration(
                labelText: 'Severidad',
                prefixIcon: const Icon(Icons.warning_amber_outlined, size: 20),
              ),
              items: _severities
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(
                        s,
                        style: GoogleFonts.ibmPlexSans(fontSize: 14),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedSeverity = v),
              validator: (v) => v == null ? 'Seleccione la severidad' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descripción del incidente',
                alignLabelWithHint: true,
              ),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Ingrese una descripción'
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
                            const Duration(milliseconds: 800),
                          );
                          if (context.mounted) {
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                              msg: 'Incidente registrado correctamente',
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
                        'Registrar incidente',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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
