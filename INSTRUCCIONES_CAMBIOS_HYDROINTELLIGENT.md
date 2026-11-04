# HYDROINTELLIGENT - cambios incluidos

## Cambios realizados
- Se actualizaron las seis zonas: Edificio A, Edificio B, Edificio C, Edificio D, Edificio E y Cafetería.
- Se simplificó el panel de zonas con un estilo institucional, sin tarjetas decorativas excesivas.
- Se añadió un módulo de agrupamiento K-means (K=3) en el dashboard administrativo.
- Se añadieron indicadores que no muestran cifras inventadas como si fueran mediciones reales.
- Se añadió almacenamiento local de lecturas y exportación a `HYDROINTELLIGENT_REGISTROS.xlsx`.

## Instalar dependencias
Desde la carpeta del proyecto ejecutar:

```bash
flutter pub get
```

Se agregaron `excel` y `path_provider`.

## Archivo Excel
El libro se crea en la carpeta de documentos de la aplicación, dentro de `HYDROINTELLIGENT/HYDROINTELLIGENT_REGISTROS.xlsx`.
Contiene las hojas `Mediciones` y `Zonas`. Al llamar a `registrarLectura`, se guarda la lectura localmente y se actualiza el Excel. También se puede exportar manualmente desde el botón de descarga del panel administrativo.

## Conectar las lecturas del ESP32
El ZIP recibido no incluye un cliente MQTT en Flutter ni un formato definitivo de topics para los sensores de agua. Por eso no se inventó una conexión que pudiera fallar ni se presentan los datos de ejemplo como reales. Cuando el receptor MQTT reciba una medición, debe invocar el servicio de esta forma:

```dart
final registro = RegistroAguaService();
await registro.registrarLectura(
  LecturaAgua(
    fecha: DateTime.now(),
    zona: 'Edificio A', // Edificio A-E o Cafetería
    sensor: 'presion',
    valor: 3.8,
    unidad: 'bar',
    origen: 'ESP32',
  ),
);
```

La misma llamada se utiliza para nivel, caudal, humedad u otra variable, cambiando `sensor`, `valor` y `unidad`.

## Clustering
El módulo ejecuta K-means con tres grupos. Por ahora muestra un conjunto de datos ilustrativo para que la interfaz y el algoritmo estén integrados. Debe alimentarse con las lecturas reales de consumo, presión y estado de sensores cuando se defina el mensaje MQTT de cada zona. La interfaz lo identifica expresamente como demostración.

## Nota de validación
En el entorno de edición no está instalado Flutter/Dart, por lo que no fue posible ejecutar `flutter pub get`, `flutter analyze` ni compilar la aplicación. Después de descargar el ZIP, ejecutar esos comandos en tu equipo.
