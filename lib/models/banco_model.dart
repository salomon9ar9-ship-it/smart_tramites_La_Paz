// lib/models/banco_model.dart

class Banco {
  final String id;
  final String nombre;
  final String codigo;
  final String? qrCodeUrl;
  final String? logoUrl;
  final bool activo;

  const Banco({
    String? id,
    required this.nombre,
    required this.codigo,
    this.qrCodeUrl,
    this.logoUrl,
    this.activo = true,
  }) : id = id ?? codigo;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'codigo': codigo,
      'qrCodeUrl': qrCodeUrl,
      'logoUrl': logoUrl,
      'activo': activo,
    };
  }

  factory Banco.fromJson(Map<String, dynamic> json) {
    return Banco(
      id: json['id'],
      nombre: json['nombre'],
      codigo: json['codigo'],
      qrCodeUrl: json['qrCodeUrl'],
      logoUrl: json['logoUrl'],
      activo: json['activo'] ?? true,
    );
  }
}

// Lista de bancos bolivianos predefinidos
const List<Banco> bancosBolivianos = [
  Banco(nombre: 'Banco Unión', codigo: 'UNION'),
  Banco(nombre: 'Banco Sol', codigo: 'SOL'),
  Banco(nombre: 'Banco FIE', codigo: 'FIE'),
  Banco(nombre: 'Banco BNB', codigo: 'BNB'),
  Banco(nombre: 'Banco Mercantil Santa Cruz', codigo: 'BMSC'),
  Banco(nombre: 'Banco Ganadero', codigo: 'GANADERO'),
  Banco(nombre: 'Banco BCP', codigo: 'BCP'),
  Banco(nombre: 'Banco Bisa', codigo: 'BISA'),
  Banco(nombre: 'Banco Nacional de Bolivia', codigo: 'BNB'),
  Banco(nombre: 'Banco Crecer', codigo: 'CRECER'),
  Banco(nombre: 'Banco Fassil', codigo: 'FASSIL'),
  Banco(nombre: 'Banco Prodem', codigo: 'PRODEM'),
];
