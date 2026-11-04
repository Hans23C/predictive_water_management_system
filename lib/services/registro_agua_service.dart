// Servicio local para conservar lecturas y exportarlas a Excel.
// Las lecturas reales deben incorporarse llamando a registrarLectura desde MQTT/API.
import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LecturaAgua {
  final DateTime fecha;
  final String zona;
  final String sensor;
  final double valor;
  final String unidad;
  final String origen;

  const LecturaAgua({
    required this.fecha,
    required this.zona,
    required this.sensor,
    required this.valor,
    required this.unidad,
    this.origen = 'ESP32',
  });

  Map<String, dynamic> toJson() => {
        'fecha': fecha.toIso8601String(),
        'zona': zona,
        'sensor': sensor,
        'valor': valor,
        'unidad': unidad,
        'origen': origen,
      };

  factory LecturaAgua.fromJson(Map<String, dynamic> json) => LecturaAgua(
        fecha: DateTime.parse(json['fecha'] as String),
        zona: json['zona'] as String,
        sensor: json['sensor'] as String,
        valor: (json['valor'] as num).toDouble(),
        unidad: json['unidad'] as String,
        origen: (json['origen'] as String?) ?? 'ESP32',
      );
}

class RegistroAguaService {
  static const String _storageKey = 'hydrointelligent_lecturas_v1';
  static const List<String> zonas = [
    'Edificio A',
    'Edificio B',
    'Edificio C',
    'Edificio D',
    'Edificio E',
    'Cafetería',
  ];

  Future<List<LecturaAgua>> obtenerLecturas() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => LecturaAgua.fromJson(item as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.fecha.compareTo(b.fecha));
  }

  Future<void> registrarLectura(LecturaAgua lectura) async {
    final lecturas = await obtenerLecturas();
    lecturas.add(lectura);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(lecturas.map((item) => item.toJson()).toList()),
    );
    // Actualiza el libro de Excel cada vez que se registra una nueva lectura.
    await exportarExcel();
  }

  Future<File> exportarExcel() async {
    final lecturas = await obtenerLecturas();
    final excel = Excel.createExcel();
    final hoja = excel['Mediciones'];
    hoja.appendRow([
      TextCellValue('Fecha'),
      TextCellValue('Hora'),
      TextCellValue('Zona'),
      TextCellValue('Sensor'),
      TextCellValue('Valor'),
      TextCellValue('Unidad'),
      TextCellValue('Origen'),
    ]);

    for (final lectura in lecturas) {
      final f = lectura.fecha;
      hoja.appendRow([
        TextCellValue('${f.day.toString().padLeft(2, '0')}/${f.month.toString().padLeft(2, '0')}/${f.year}'),
        TextCellValue('${f.hour.toString().padLeft(2, '0')}:${f.minute.toString().padLeft(2, '0')}:${f.second.toString().padLeft(2, '0')}'),
        TextCellValue(lectura.zona),
        TextCellValue(lectura.sensor),
        DoubleCellValue(lectura.valor),
        TextCellValue(lectura.unidad),
        TextCellValue(lectura.origen),
      ]);
    }

    final resumen = excel['Zonas'];
    resumen.appendRow([
      TextCellValue('Zona'),
      TextCellValue('Cantidad de lecturas'),
      TextCellValue('Última lectura'),
    ]);
    for (final zona in zonas) {
      final deZona = lecturas.where((l) => l.zona == zona).toList();
      resumen.appendRow([
        TextCellValue(zona),
        IntCellValue(deZona.length),
        TextCellValue(deZona.isEmpty ? 'Sin registros' : deZona.last.fecha.toIso8601String()),
      ]);
    }

    final bytes = excel.save();
    if (bytes == null) throw Exception('No fue posible generar el archivo Excel.');
    final directory = await getApplicationDocumentsDirectory();
    final folder = Directory('${directory.path}${Platform.pathSeparator}HYDROINTELLIGENT');
    if (!await folder.exists()) await folder.create(recursive: true);
    final file = File('${folder.path}${Platform.pathSeparator}HYDROINTELLIGENT_REGISTROS.xlsx');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
