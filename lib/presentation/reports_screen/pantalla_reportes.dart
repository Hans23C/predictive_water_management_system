// APARTADO: Pantalla bidireccional de Reportes (Mantenimiento reporta, Administrador responde)
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/tema_aplicacion.dart';
import '../../widgets/barra_superior_aplicacion.dart';
import '../../widgets/liquid_glass_container.dart';

class CampusReport {
  final String id;
  final String title;
  final String zone;
  final String description;
  final String severity;
  final String author;
  final String createdAt;
  String status; // 'Pendiente', 'En proceso', 'Resuelto'
  String? adminResponse;
  String? adminResponseDate;

  CampusReport({
    required this.id,
    required this.title,
    required this.zone,
    required this.description,
    required this.severity,
    required this.author,
    required this.createdAt,
    this.status = 'Pendiente',
    this.adminResponse,
    this.adminResponseDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'zone': zone,
        'description': description,
        'severity': severity,
        'author': author,
        'createdAt': createdAt,
        'status': status,
        'adminResponse': adminResponse,
        'adminResponseDate': adminResponseDate,
      };

  factory CampusReport.fromJson(Map<String, dynamic> json) => CampusReport(
        id: json['id'],
        title: json['title'],
        zone: json['zone'],
        description: json['description'],
        severity: json['severity'],
        author: json['author'],
        createdAt: json['createdAt'],
        status: json['status'] ?? 'Pendiente',
        adminResponse: json['adminResponse'],
        adminResponseDate: json['adminResponseDate'],
      );
}

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  static const String _prefKeyReports = 'hydro_campus_reports_v2';
  List<CampusReport> _reports = [];
  String _userRole = 'personal_mantenimiento';
  String _userName = 'Técnico';
  bool _isLoading = true;
  String _filter = 'todos'; // 'todos', 'pendientes', 'resueltos'

  @override
  void initState() {
    super.initState();
    _loadUserAndReports();
  }

  Future<void> _loadUserAndReports() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('user_role') ?? 'personal_mantenimiento';
    final name = prefs.getString('user_name') ?? 'Personal';

    final savedJson = prefs.getString(_prefKeyReports);
    List<CampusReport> loadedReports = [];

    if (savedJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(savedJson);
        loadedReports = decoded.map((e) => CampusReport.fromJson(e)).toList();
      } catch (_) {}
    }

    // Datos iniciales de demostración si no hay reportes guardados
    if (loadedReports.isEmpty) {
      loadedReports = [
        CampusReport(
          id: 'REP-001',
          title: 'Presión baja en bomba BOM-003 por posible obstrucción',
          zone: 'Cafetería Central',
          description:
              'La presión no sube de 1.8 bar en horas pico. Se detectó vibración anormal en el cuerpo de la bomba.',
          severity: 'Crítico',
          author: 'Ing. Jesus Vasquez Granda',
          createdAt: 'Hoy, 08:30 AM',
          status: 'En proceso',
          adminResponse:
              'Autorizada la sustitución del sello mecánico y limpieza de filtro. Refacción disponible en bodega central.',
          adminResponseDate: 'Hoy, 09:15 AM (Ing. Rodolfo Lucas)',
        ),
        CampusReport(
          id: 'REP-002',
          title: 'Fuga ligera en válvula reguladora de segundo piso',
          zone: 'Edificio B (Laboratorios)',
          description:
              'Goteo constante de aproximadamente 2 litros por hora en la tubería de derivación hacia laboratorio de fluidos.',
          severity: 'Advertencia',
          author: 'Ing. Jesus Vasquez Granda',
          createdAt: 'Ayer, 04:45 PM',
          status: 'Resuelto',
          adminResponse:
              'Recibido y archivado. Reparado con cambio de empaque de teflón. Presión estabilizada.',
          adminResponseDate: 'Ayer, 06:00 PM (Ing. Rodolfo Lucas)',
        ),
      ];
    }

    if (mounted) {
      setState(() {
        _userRole = role;
        _userName = name;
        _reports = loadedReports;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveReports() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_reports.map((r) => r.toJson()).toList());
    await prefs.setString(_prefKeyReports, encoded);
  }

  void _createNewReportModal() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CreateReportSheet(
        authorName: _userName,
        onSubmit: (newReport) {
          setState(() {
            _reports.insert(0, newReport);
          });
          _saveReports();
        },
      ),
    );
  }

  void _respondReportModal(CampusReport report) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AdminResponseSheet(
        report: report,
        adminName: _userName,
        onSubmit: (response, newStatus) {
          setState(() {
            report.adminResponse = response;
            report.status = newStatus;
            report.adminResponseDate = 'Hoy, ${TimeOfDay.now().format(context)} ($_userName)';
          });
          _saveReports();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAdmin = _userRole == 'administrador_general';

    final filteredReports = _reports.where((r) {
      if (_filter == 'pendientes') return r.status == 'Pendiente';
      if (_filter == 'resueltos') return r.status == 'Resuelto';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: 'Reportes de Incidencias',
        subtitle: isAdmin
            ? 'Panel de Administración · Responder y autorizar'
            : 'Personal de Mantenimiento · Registrar y dar seguimiento',
      ),
      body: SafeArea(
        top: false,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
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
                            // Tarjeta de Rol Liquid Glass
                            LiquidGlassContainer(
                              padding: const EdgeInsets.all(18),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: (isAdmin ? AppTheme.primary : AppTheme.secondary)
                                          .withAlpha(25),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      isAdmin
                                          ? Icons.admin_panel_settings_rounded
                                          : Icons.engineering_rounded,
                                      color: isAdmin ? AppTheme.primary : AppTheme.secondary,
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isAdmin
                                              ? 'Vista de Administrador: Responder Reportes'
                                              : 'Vista de Mantenimiento: Enviar Reportes',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w700,
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        ),
                                        Text(
                                          isAdmin
                                              ? 'Revisa los reportes subidos por el personal técnico y autoriza soluciones en tiempo real.'
                                              : 'Sube cualquier anomalía del sistema de agua y observa la respuesta oficial del Administrador.',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            color: theme.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!isAdmin) ...[
                                    const SizedBox(width: 8),
                                    FilledButton.icon(
                                      onPressed: _createNewReportModal,
                                      icon: const Icon(Icons.add_rounded, size: 18),
                                      label: const Text('Nuevo'),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Barra de filtros
                            Row(
                              children: [
                                _filterChip('Todos (${_reports.length})', 'todos'),
                                const SizedBox(width: 8),
                                _filterChip('Pendientes', 'pendientes'),
                                const SizedBox(width: 8),
                                _filterChip('Resueltos', 'resueltos'),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Lista de reportes
                            if (filteredReports.isEmpty)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Text(
                                    'No hay reportes en esta categoría.',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredReports.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 14),
                                itemBuilder: (context, i) =>
                                    _buildReportCard(context, filteredReports[i], isAdmin),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: !isAdmin
          ? FloatingActionButton.extended(
              onPressed: _createNewReportModal,
              icon: const Icon(Icons.add_comment_rounded),
              label: Text(
                'Crear Reporte',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
              ),
            )
          : null,
    );
  }

  Widget _filterChip(String label, String value) {
    final isSelected = _filter == value;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withAlpha(25) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, CampusReport report, bool isAdmin) {
    final theme = Theme.of(context);
    final isDark = AppTheme.isDark(context);

    Color statusColor;
    if (report.status == 'Resuelto') {
      statusColor = AppTheme.success;
    } else if (report.status == 'En proceso') {
      statusColor = AppTheme.primary;
    } else {
      statusColor = AppTheme.warning;
    }

    return LiquidGlassContainer(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabecera: ID, Zona y Estado
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  report.id,
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  report.zone,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withAlpha(80)),
                ),
                child: Text(
                  report.status,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Título y Descripción del problema
          Text(
            report.title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            report.description,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          // Pie del reporte original: Autor y Fecha
          Row(
            children: [
              Icon(Icons.person_pin_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                'Reportado por: ${report.author} · ${report.createdAt}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          // Respuesta Oficial del Administrador
          if (report.adminResponse != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF132A3E) : const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: (isDark ? const Color(0xFF38BDF8) : AppTheme.primary).withAlpha(80),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        size: 16,
                        color: isDark ? const Color(0xFF38BDF8) : AppTheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Respuesta Oficial de la Administración',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? const Color(0xFF38BDF8) : AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    report.adminResponse!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (report.adminResponseDate != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      report.adminResponseDate!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Botón de Administrador para Responder / Actualizar
          if (isAdmin) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: () => _respondReportModal(report),
                icon: const Icon(Icons.reply_rounded, size: 16),
                label: Text(
                  report.adminResponse == null ? 'Responder a Reporte' : 'Actualizar Respuesta',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Modal para que el personal de mantenimiento suba un nuevo reporte
class _CreateReportSheet extends StatefulWidget {
  final String authorName;
  final void Function(CampusReport) onSubmit;

  const _CreateReportSheet({required this.authorName, required this.onSubmit});

  @override
  State<_CreateReportSheet> createState() => _CreateReportSheetState();
}

class _CreateReportSheetState extends State<_CreateReportSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedZone = 'Edificio A';
  String _selectedSeverity = 'Advertencia';

  static const List<String> _zones = [
    'Edificio A',
    'Edificio B',
    'Edificio C',
    'Edificio D',
    'Edificio E',
    'Cafetería Central',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
              const SizedBox(height: 18),
              Text(
                'Crear Reporte de Mantenimiento',
                style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'El Administrador recibirá este reporte para autorizar refacciones y personal',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedZone,
                decoration: const InputDecoration(labelText: 'Edificio o Zona afectada'),
                items: _zones.map((z) => DropdownMenuItem(value: z, child: Text(z))).toList(),
                onChanged: (v) => setState(() => _selectedZone = v!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedSeverity,
                decoration: const InputDecoration(labelText: 'Severidad del Problema'),
                items: const [
                  DropdownMenuItem(value: 'Leve', child: Text('🟢 Leve (Monitoreo regular)')),
                  DropdownMenuItem(value: 'Advertencia', child: Text('🟡 Advertencia (Atención sugerida)')),
                  DropdownMenuItem(value: 'Crítica', child: Text('🔴 Crítica (Atención inmediata)')),
                ],
                onChanged: (v) => setState(() => _selectedSeverity = v!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título breve del problema',
                  hintText: 'Ej. Fuga en codo o baja presión en bomba 2',
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Ingresa un título' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción detallada',
                  hintText: 'Describe síntomas, ruidos, bar observado y piezas requeridas.',
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Ingresa la descripción' : null,
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final report = CampusReport(
                      id: 'REP-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                      title: _titleController.text.trim(),
                      zone: _selectedZone,
                      description: _descController.text.trim(),
                      severity: _selectedSeverity,
                      author: widget.authorName,
                      createdAt: 'Hoy, ${TimeOfDay.now().format(context)}',
                    );
                    widget.onSubmit(report);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reporte enviado al Administrador exitosamente.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: const Text('Enviar Reporte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Modal para que el Administrador responda al reporte
class _AdminResponseSheet extends StatefulWidget {
  final CampusReport report;
  final String adminName;
  final void Function(String response, String status) onSubmit;

  const _AdminResponseSheet({
    required this.report,
    required this.adminName,
    required this.onSubmit,
  });

  @override
  State<_AdminResponseSheet> createState() => _AdminResponseSheetState();
}

class _AdminResponseSheetState extends State<_AdminResponseSheet> {
  final _responseController = TextEditingController();
  late String _status;

  @override
  void initState() {
    super.initState();
    _responseController.text = widget.report.adminResponse ?? '';
    _status = widget.report.status;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
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
            const SizedBox(height: 18),
            Text(
              'Responder a Incidencia: ${widget.report.id}',
              style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            Text(
              'Zona: ${widget.report.zone} · ${widget.report.title}',
              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: const InputDecoration(labelText: 'Actualizar Estado del Reporte'),
              items: const [
                DropdownMenuItem(value: 'Pendiente', child: Text('Pendiente')),
                DropdownMenuItem(value: 'En proceso', child: Text('En Proceso / Autorizado')),
                DropdownMenuItem(value: 'Resuelto', child: Text('Resuelto / Cerrado')),
              ],
              onChanged: (v) => setState(() => _status = v!),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _responseController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Respuesta oficial para Mantenimiento',
                hintText: 'Ej. Autorizada compra de repuestos. Proceder con el corte de agua programado a las 14:00.',
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () {
                if (_responseController.text.trim().isNotEmpty) {
                  widget.onSubmit(_responseController.text.trim(), _status);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Respuesta enviada al técnico correctamente.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('Guardar y Notificar a Mantenimiento'),
            ),
          ],
        ),
      ),
    );
  }
}
