// lib/models/departamento_model.dart

class Departamento {
  final String codigo;
  final String nombre;
  final String sigla;

  const Departamento({
    required this.codigo,
    required this.nombre,
    required this.sigla,
  });

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'nombre': nombre,
        'sigla': sigla,
      };

  factory Departamento.fromJson(Map<String, dynamic> json) {
    return Departamento(
      codigo: json['codigo'],
      nombre: json['nombre'],
      sigla: json['sigla'],
    );
  }
}

// Departamentos de Bolivia con sus siglas para CI
const List<Departamento> departamentosBolivia = [
  Departamento(codigo: '01', nombre: 'Chuquisaca', sigla: 'CH'),
  Departamento(codigo: '02', nombre: 'La Paz', sigla: 'LP'),
  Departamento(codigo: '03', nombre: 'Cochabamba', sigla: 'CB'),
  Departamento(codigo: '04', nombre: 'Oruro', sigla: 'OR'),
  Departamento(codigo: '05', nombre: 'Potosí', sigla: 'PT'),
  Departamento(codigo: '06', nombre: 'Tarija', sigla: 'TJ'),
  Departamento(codigo: '07', nombre: 'Santa Cruz', sigla: 'SC'),
  Departamento(codigo: '08', nombre: 'Beni', sigla: 'BN'),
  Departamento(codigo: '09', nombre: 'Pando', sigla: 'PD'),
];
