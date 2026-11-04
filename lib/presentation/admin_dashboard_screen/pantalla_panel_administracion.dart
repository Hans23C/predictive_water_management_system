// APARTADO: Panel principal del administrador responsivo y adaptativo
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/registro_agua_service.dart';

import '../../theme/tema_aplicacion.dart';
import '../../widgets/barra_superior_aplicacion.dart';
import '../../widgets/animaciones_sistema_agua.dart';
import './widgets/lista_alertas_administracion.dart';
import './widgets/grafica_consumo_administracion.dart';
import './widgets/rejilla_indicadores_administracion.dart';
import './widgets/estado_zonas_administracion.dart';
import './widgets/analisis_clustering_zonas.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _userName = 'Administrador';
  final RegistroAguaService _registroService = RegistroAguaService();

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _userName = prefs.getString('user_name') ?? 'Administrador';
      });
    }
  }

  Future<void> _exportarExcel() async {
    try {
      final archivo = await _registroService.exportarExcel();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Excel guardado en: ${archivo.path}'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(label: 'OK', onPressed: () {}),
        behavior: SnackBarBehavior.floating,
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No se pudo exportar: $e'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) setState(() {});
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstName = _userName.split(' ').last;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: 'HYDROINTELLIGENT',
        subtitle: '$_greeting, $firstName',
        actions: [
          AppBarActionButton(
            tooltip: 'Exportar registros a Excel',
            onPressed: _exportarExcel,
            icon: Icons.file_download_outlined,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Fluttertoast.showToast(
            msg: 'Configuración de zonas disponible próximamente',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: AppTheme.primary,
            textColor: Colors.white,
          );
        },
        icon: const Icon(Icons.tune_rounded),
        label: Text(
          'Configurar zonas',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildMobileContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _AvisoDatosDemostracion(),
        const SizedBox(height: 14),
        _SectionHeader(
          title: 'Indicadores del Campus',
          subtitle: 'Actualizado: ${_formattedNow()}',
        ),
        const SizedBox(height: 12),
        const AdminKpiGridWidget(),
        const SizedBox(height: 16),
        const CisternLevelAnimation(),
        const SizedBox(height: 14),
        const WaterFlowAnimation(),
        const SizedBox(height: 24),
        const _SectionHeader(title: 'Consumo Diario — Últimas 2 semanas'),
        const SizedBox(height: 12),
        const AdminConsumptionChartWidget(),
        const SizedBox(height: 24),
        const _SectionHeader(title: 'Estado de Zonas'),
        const SizedBox(height: 12),
        const AdminZoneStatusWidget(),
        const SizedBox(height: 20),
        const _SectionHeader(title: 'Análisis de Agrupamiento (K-Means)'),
        const SizedBox(height: 12),
        const AnalisisClusteringZonas(),
        const SizedBox(height: 24),
        const _SectionHeader(title: 'Alertas Recientes'),
        const SizedBox(height: 12),
        const AdminAlertsFeedWidget(),
      ],
    );
  }

  Widget _buildWideContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _AvisoDatosDemostracion(),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Columna Izquierda: Métricas, Tanque, Flujo y Consumo
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionHeader(
                    title: 'Indicadores del Campus',
                    subtitle: 'Actualizado: ${_formattedNow()}',
                  ),
                  const SizedBox(height: 12),
                  const AdminKpiGridWidget(),
                  const SizedBox(height: 16),
                  const CisternLevelAnimation(),
                  const SizedBox(height: 14),
                  const WaterFlowAnimation(),
                  const SizedBox(height: 24),
                  const _SectionHeader(title: 'Consumo Diario — Últimas 2 semanas'),
                  const SizedBox(height: 12),
                  const AdminConsumptionChartWidget(),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Columna Derecha: Zonas, Clustering y Alertas
            const Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionHeader(title: 'Estado de Zonas'),
                  SizedBox(height: 12),
                  AdminZoneStatusWidget(),
                  SizedBox(height: 20),
                  _SectionHeader(title: 'Análisis de Agrupamiento (K-Means)'),
                  SizedBox(height: 12),
                  AnalisisClusteringZonas(),
                  SizedBox(height: 24),
                  _SectionHeader(title: 'Alertas Recientes'),
                  SizedBox(height: 12),
                  AdminAlertsFeedWidget(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AvisoDatosDemostracion extends StatelessWidget {
  const _AvisoDatosDemostracion();

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
              'Modo Demostración Activo: Las lecturas visualizadas simulan el flujo del campus. Los valores en vivo se actualizarán al enlazar los sensores ESP32.',
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionHeader({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 1),
          Text(
            subtitle!,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

String _formattedNow() {
  final now = DateTime.now();
  return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
}
