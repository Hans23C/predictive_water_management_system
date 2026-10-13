import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar_widget.dart';
import './widgets/admin_alerts_feed_widget.dart';
import './widgets/admin_consumption_chart_widget.dart';
import './widgets/admin_kpi_grid_widget.dart';
import './widgets/admin_zone_status_widget.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // TODO: Replace with [Riverpod/Bloc] for production state management
  String _userName = 'Administrador';
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
        _userName = prefs.getString('user_name') ?? 'Administrador';
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

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final firstName = _userName.split(' ').last;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: 'AquaCampus',
        subtitle: '$_greeting, $firstName',
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
                color: theme.colorScheme.onSurface,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.error,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: _handleLogout,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.primary,
          child: isTablet
              ? _TabletLayout(isRefreshing: _isRefreshing)
              : _PhoneLayout(isRefreshing: _isRefreshing),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Fluttertoast.showToast(
            msg: 'Configuración de zonas — próximamente',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: AppTheme.primary,
            textColor: Colors.white,
          );
        },
        icon: const Icon(Icons.tune_rounded),
        label: Text(
          'Configurar zonas',
          style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _PhoneLayout extends StatelessWidget {
  final bool isRefreshing;

  const _PhoneLayout({required this.isRefreshing});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        _SectionHeader(
          title: 'Indicadores del Campus',
          subtitle: 'Actualizado: ${_formattedNow()}',
        ),
        const SizedBox(height: 12),
        const AdminKpiGridWidget(),
        const SizedBox(height: 24),
        const _SectionHeader(title: 'Consumo Diario — Últimas 2 semanas'),
        const SizedBox(height: 12),
        const AdminConsumptionChartWidget(),
        const SizedBox(height: 24),
        const _SectionHeader(title: 'Estado de Zonas'),
        const SizedBox(height: 12),
        const AdminZoneStatusWidget(),
        const SizedBox(height: 24),
        const _SectionHeader(title: 'Alertas Recientes'),
        const SizedBox(height: 12),
        const AdminAlertsFeedWidget(),
      ],
    );
  }
}

class _TabletLayout extends StatelessWidget {
  final bool isRefreshing;

  const _TabletLayout({required this.isRefreshing});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 12, 100),
            children: [
              _SectionHeader(
                title: 'Indicadores del Campus',
                subtitle: 'Actualizado: ${_formattedNow()}',
              ),
              const SizedBox(height: 12),
              const AdminKpiGridWidget(),
              const SizedBox(height: 24),
              const _SectionHeader(title: 'Consumo Diario — Últimas 2 semanas'),
              const SizedBox(height: 12),
              const AdminConsumptionChartWidget(),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 16, 24, 100),
            children: const [
              _SectionHeader(title: 'Estado de Zonas'),
              SizedBox(height: 12),
              AdminZoneStatusWidget(),
              SizedBox(height: 24),
              _SectionHeader(title: 'Alertas Recientes'),
              SizedBox(height: 12),
              AdminAlertsFeedWidget(),
            ],
          ),
        ),
      ],
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
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

String _formattedNow() {
  final now = DateTime.now();
  return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
}
