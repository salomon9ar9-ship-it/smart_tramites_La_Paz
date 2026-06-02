# SmartTrámites La Paz 📋

Aplicación móvil Flutter para optimización de trámites administrativos en La Paz, Bolivia.

## 🚀 Cómo ejecutar

### Requisitos previos
- Flutter SDK (≥ 3.0.0) instalado: https://docs.flutter.dev/get-started/install
- Android Studio o VS Code con extensión Flutter
- Dispositivo Android/iOS o emulador configurado

### Pasos para ejecutar

1. **Abre la carpeta en VS Code:**
   ```
   Archivo > Abrir Carpeta > selecciona la carpeta "smarttramites"
   ```

2. **Instala las dependencias:**
   ```bash
   flutter pub get
   ```

3. **Ejecuta la aplicación:**
   ```bash
   flutter run
   ```
   O presiona **F5** en VS Code con un emulador activo.

### Si hay problemas con dependencias
```bash
flutter clean
flutter pub get
flutter run
```

## 📱 Funcionalidades incluidas

| Función | Descripción |
|---|---|
| 🏠 Inicio | Lista todos los trámites con filtro por entidad |
| 🔍 Búsqueda | Busca por nombre, entidad o categoría |
| 🏛️ Entidades | Ver trámites agrupados por institución |
| 🔔 Recordatorios | Agregar y gestionar alertas de fechas |
| 📄 Detalle | Requisitos, pasos y costos de cada trámite |
| 📱 QR Simulado | Genera comprobante QR demostrativo |

## 🏛️ Entidades cubiertas
- **SEGIP** – Cédula de identidad, certificados
- **Alcaldía de La Paz** – Licencias, permisos, construcción
- **Bancos** – Cuentas, certificaciones
- **Impuestos Nacionales** – NIT, declaraciones
- **Tránsito** – Licencias de conducir, registro de vehículos

## 📂 Estructura del proyecto
```
lib/
├── main.dart              # Punto de entrada + navegación
├── theme/
│   └── app_theme.dart     # Colores y estilos
├── models/
│   └── tramite.dart       # Modelos de datos
├── data/
│   └── tramites_data.dart # Base de datos de trámites
├── screens/
│   ├── home_screen.dart           # Pantalla principal
│   ├── busqueda_screen.dart       # Búsqueda
│   ├── entidades_screen.dart      # Por entidad
│   ├── recordatorios_screen.dart  # Recordatorios
│   ├── detalle_tramite_screen.dart# Detalle completo
│   └── qr_screen.dart             # Comprobante QR
└── widgets/
    ├── tramite_card.dart  # Tarjeta de trámite
    └── entidad_chip.dart  # Chip de filtro
```

## 👥 Integrantes
- Mamani Apaza Eber David
- Rodriguez Mamani Moises
- Rojas Poma Andres Alexis
- Soldado Quispe Carlos Daniel
- Villegas Apaza Salomon Richard

**Docente:** Grover Condori Acarapi  
**Materia:** Sistemas Operativos Móviles y Embebidos  
**Universidad:** UNIFRANZ La Paz - 2026
