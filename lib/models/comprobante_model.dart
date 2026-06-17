class Comprobante {
  final String id;
  final String tramiteId;
  final String usuarioId;
  final String entidad;
  final String concepto;
  final String monto;
  final String moneda;
  final String metodoPago;
  final String? qrCodeData;
  final String? archivoUrl; // PDF o imagen
  final DateTime fechaEmision;
  final String estado; // 'pendiente', 'pagado', 'cancelado'
  final String? referenciaBancaria;

  Comprobante({
    String? id,
    required this.tramiteId,
    required this.usuarioId,
    required this.entidad,
    required this.concepto,
    required this.monto,
    this.moneda = 'BOB',
    required this.metodoPago,
    this.qrCodeData,
    this.archivoUrl,
    DateTime? fechaEmision,
    this.estado = 'pendiente',
    this.referenciaBancaria,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        fechaEmision = fechaEmision ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tramiteId': tramiteId,
      'usuarioId': usuarioId,
      'entidad': entidad,
      'concepto': concepto,
      'monto': monto,
      'moneda': moneda,
      'metodoPago': metodoPago,
      'qrCodeData': qrCodeData,
      'archivoUrl': archivoUrl,
      'fechaEmision': fechaEmision.toIso8601String(),
      'estado': estado,
      'referenciaBancaria': referenciaBancaria,
    };
  }

  // Alias para compatibilidad
  Map<String, dynamic> toMap() => toJson();

  factory Comprobante.fromJson(Map<String, dynamic> json) {
    return Comprobante(
      id: json['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      tramiteId: json['tramiteId'] as String,
      usuarioId: json['usuarioId'] as String,
      entidad: json['entidad'] as String,
      concepto: json['concepto'] as String,
      monto: json['monto'] as String,
      moneda: json['moneda'] as String? ?? 'BOB',
      metodoPago: json['metodoPago'] as String,
      qrCodeData: json['qrCodeData'] as String?,
      archivoUrl: json['archivoUrl'] as String?,
      fechaEmision: json['fechaEmision'] != null
          ? (json['fechaEmision'] is DateTime
              ? json['fechaEmision'] as DateTime
              : DateTime.parse(json['fechaEmision'] as String))
          : DateTime.now(),
      estado: json['estado'] as String? ?? 'pendiente',
      referenciaBancaria: json['referenciaBancaria'] as String?,
    );
  }

  // Alias para compatibilidad
  factory Comprobante.fromMap(Map<String, dynamic> map) =>
      Comprobante.fromJson(map);

  // Copy with
  Comprobante copyWith({
    String? id,
    String? tramiteId,
    String? usuarioId,
    String? entidad,
    String? concepto,
    String? monto,
    String? moneda,
    String? metodoPago,
    String? qrCodeData,
    String? archivoUrl,
    DateTime? fechaEmision,
    String? estado,
    String? referenciaBancaria,
  }) {
    return Comprobante(
      id: id ?? this.id,
      tramiteId: tramiteId ?? this.tramiteId,
      usuarioId: usuarioId ?? this.usuarioId,
      entidad: entidad ?? this.entidad,
      concepto: concepto ?? this.concepto,
      monto: monto ?? this.monto,
      moneda: moneda ?? this.moneda,
      metodoPago: metodoPago ?? this.metodoPago,
      qrCodeData: qrCodeData ?? this.qrCodeData,
      archivoUrl: archivoUrl ?? this.archivoUrl,
      fechaEmision: fechaEmision ?? this.fechaEmision,
      estado: estado ?? this.estado,
      referenciaBancaria: referenciaBancaria ?? this.referenciaBancaria,
    );
  }

  bool get estaPagado => estado == 'pagado';

  // Getters útiles
  String get fechaFormateada {
    final day = fechaEmision.day.toString().padLeft(2, '0');
    final month = fechaEmision.month.toString().padLeft(2, '0');
    final year = fechaEmision.year;
    final hour = fechaEmision.hour.toString().padLeft(2, '0');
    final minute = fechaEmision.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  String get estadoFormateado {
    switch (estado.toLowerCase()) {
      case 'pagado':
        return '✅ Pagado';
      case 'pendiente':
        return '⏳ Pendiente';
      case 'cancelado':
        return '❌ Cancelado';
      case 'procesando':
        return '🔄 Procesando';
      default:
        return estado;
    }
  }
}
