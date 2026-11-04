// APARTADO: Pruebas automatizadas de la aplicación
// Este archivo contiene comprobaciones para validar la interfaz y su comportamiento.

import 'package:flutter_test/flutter_test.dart';
import 'package:predictive_water_management_system/main.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    // Construir la aplicación completa y comprobar que no lanza excepciones no controladas
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(MyApp), findsOneWidget);
  });
}
