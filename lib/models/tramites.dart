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
  final String? usuarioId;
  final String? estado;
  final DateTime? fechaCreacion;

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
    this.usuarioId,
    this.estado,
    this.fechaCreacion,
  });

  // Método para convertir a JSON (útil para base de datos)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'entidad': entidad,
      'categoria': categoria,
      'descripcion': descripcion,
      'requisitos': requisitos,
      'costo': costo,
      'pasos': pasos,
      'duracionEstimada': duracionEstimada,
      'iconoEntidad': iconoEntidad,
      'colorEntidad': colorEntidad,
      if (usuarioId != null) 'usuarioId': usuarioId,
      if (estado != null) 'estado': estado,
      if (fechaCreacion != null)
        'fechaCreacion': fechaCreacion!.toIso8601String(),
    };
  }

  // Alias para compatibilidad
  Map<String, dynamic> toMap() => toJson();

  // Método para crear desde JSON
  factory Tramite.fromJson(Map<String, dynamic> json) {
    return Tramite(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      entidad: json['entidad'] as String,
      categoria: json['categoria'] as String,
      descripcion: json['descripcion'] as String,
      requisitos: json['requisitos'] is List
          ? List<String>.from(json['requisitos'])
          : (json['requisitos'] as String? ?? '')
              .split('|')
              .where((e) => e.isNotEmpty)
              .toList(),
      costo: json['costo'] as String,
      pasos: json['pasos'] is List
          ? List<String>.from(json['pasos'])
          : (json['pasos'] as String? ?? '')
              .split('|')
              .where((e) => e.isNotEmpty)
              .toList(),
      duracionEstimada: json['duracionEstimada'] as String,
      iconoEntidad: json['iconoEntidad'] as String,
      colorEntidad: json['colorEntidad'] as int? ?? 0xFF2196F3,
      usuarioId: json['usuarioId'] as String?,
      estado: json['estado'] as String?,
      fechaCreacion: json['fechaCreacion'] != null
          ? (json['fechaCreacion'] is DateTime
              ? json['fechaCreacion'] as DateTime
              : DateTime.tryParse(json['fechaCreacion'] as String))
          : null,
    );
  }

  // Alias para compatibilidad
  factory Tramite.fromMap(Map<String, dynamic> map) => Tramite.fromJson(map);

  // Copy with
  Tramite copyWith({
    String? id,
    String? nombre,
    String? entidad,
    String? categoria,
    String? descripcion,
    List<String>? requisitos,
    String? costo,
    List<String>? pasos,
    String? duracionEstimada,
    String? iconoEntidad,
    int? colorEntidad,
    String? usuarioId,
    String? estado,
    DateTime? fechaCreacion,
  }) {
    return Tramite(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      entidad: entidad ?? this.entidad,
      categoria: categoria ?? this.categoria,
      descripcion: descripcion ?? this.descripcion,
      requisitos: requisitos ?? this.requisitos,
      costo: costo ?? this.costo,
      pasos: pasos ?? this.pasos,
      duracionEstimada: duracionEstimada ?? this.duracionEstimada,
      iconoEntidad: iconoEntidad ?? this.iconoEntidad,
      colorEntidad: colorEntidad ?? this.colorEntidad,
      usuarioId: usuarioId ?? this.usuarioId,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'tramiteNombre': tramiteNombre,
      'fecha': fecha.toIso8601String(),
      'completado': completado,
    };
  }

  // Alias para compatibilidad
  Map<String, dynamic> toMap() => toJson();

  factory Recordatorio.fromJson(Map<String, dynamic> json) {
    return Recordatorio(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      tramiteNombre: json['tramiteNombre'] as String,
      fecha: json['fecha'] is DateTime
          ? json['fecha'] as DateTime
          : DateTime.parse(json['fecha'] as String),
      completado: json['completado'] as bool? ?? false,
    );
  }

  // Alias para compatibilidad
  factory Recordatorio.fromMap(Map<String, dynamic> map) =>
      Recordatorio.fromJson(map);

  // Copy with
  Recordatorio copyWith({
    String? id,
    String? titulo,
    String? tramiteNombre,
    DateTime? fecha,
    bool? completado,
  }) {
    return Recordatorio(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      tramiteNombre: tramiteNombre ?? this.tramiteNombre,
      fecha: fecha ?? this.fecha,
      completado: completado ?? this.completado,
    );
  }
}
