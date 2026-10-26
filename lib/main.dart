// APARTADO: Punto de entrada de la aplicación
// Este archivo está identificado en español para facilitar su ubicación y mantenimiento.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import '../widgets/componente_error_personalizado.dart';
import 'pantalla_presentacion.dart'; // 👈 importamos el SplashScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool hasShownError = false;

  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (!hasShownError) {
      hasShownError = true;
      Future.delayed(Duration(seconds: 5), () {
        hasShownError = false;
      });
      return CustomErrorWidget(errorDetails: details);
    }
    return SizedBox.shrink();
  };

  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]).then((value) {
    GoRouter.optionURLReflectsImperativeAPIs = true;
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        // 👇 Se muestra la pantalla de presentación antes de cargar las rutas.
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(
            nextScreen: MaterialApp.router(
              // Oculta la etiqueta DEBUG en la aplicación principal.
              debugShowCheckedModeBanner: false,
              title: 'aquacampus',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.light,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(1.0),
                  ),
                  child: child!,
                );
              },
              routerConfig: appRouter,
            ),
          ),
        );
      },
    );
  }
}
