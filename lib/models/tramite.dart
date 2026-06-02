// lib/models/tramite.dart

class Tramite {
  final String id;
  final String nombre;
  final String entidad;
  final String categoria;
  final String descripcion;
  final List<String> requisitos;
  final String costo;
  final List<String> pasos;
  final String duracionEstimada;
  final String iconoEntidad;
  final int colorEntidad;

  const Tramite({
    required this.id,
    required this.nombre,
    required this.entidad,
    required this.categoria,
    required this.descripcion,
    required this.requisitos,
    required this.costo,
    required this.pasos,
    required this.duracionEstimada,
    required this.iconoEntidad,
    required this.colorEntidad,
  });
}

class Recordatorio {
  final String id;
  final String titulo;
  final String tramiteNombre;
  final DateTime fecha;
  bool completado;

  Recordatorio({
    required this.id,
    required this.titulo,
    required this.tramiteNombre,
    required this.fecha,
    this.completado = false,
  });
}
