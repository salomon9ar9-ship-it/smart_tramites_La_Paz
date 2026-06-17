// lib/models/licencia_model.dart

class LicenciaCategoria {
  final String codigo;
  final String descripcion;
  final int capacidadMaxima;
  final String tipoVehiculo;
  final String costo;
  final String duracionValidez;

  const LicenciaCategoria({
    required this.codigo,
    required this.descripcion,
    required this.capacidadMaxima,
    required this.tipoVehiculo,
    required this.costo,
    required this.duracionValidez,
  });

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'descripcion': descripcion,
      'capacidadMaxima': capacidadMaxima,
      'tipoVehiculo': tipoVehiculo,
      'costo': costo,
      'duracionValidez': duracionValidez,
    };
  }

  factory LicenciaCategoria.fromJson(Map<String, dynamic> json) {
    return LicenciaCategoria(
      codigo: json['codigo'],
      descripcion: json['descripcion'],
      capacidadMaxima: json['capacidadMaxima'],
      tipoVehiculo: json['tipoVehiculo'],
      costo: json['costo'],
      duracionValidez: json['duracionValidez'],
    );
  }
}

// Categorías de licencia según normativa boliviana
const List<LicenciaCategoria> categoriasLicenciaBolivia = [
  LicenciaCategoria(
    codigo: 'P',
    descripcion: 'Vehículos particulares',
    capacidadMaxima: 4,
    tipoVehiculo: 'Automóviles, camionetas, motos',
    costo: 'Bs. 100',
    duracionValidez: '2 años',
  ),
  LicenciaCategoria(
    codigo: 'A',
    descripcion: 'Transporte público ligero',
    capacidadMaxima: 10,
    tipoVehiculo: 'Taxis, minibuses, transporte escolar',
    costo: 'Bs. 150',
    duracionValidez: '2 años',
  ),
  LicenciaCategoria(
    codigo: 'B',
    descripcion: 'Transporte público mediano',
    capacidadMaxima: 20,
    tipoVehiculo: 'Microbuses, buses urbanos',
    costo: 'Bs. 200',
    duracionValidez: '2 años',
  ),
  LicenciaCategoria(
    codigo: 'C',
    descripcion: 'Transporte público pesado',
    capacidadMaxima: 40,
    tipoVehiculo: 'Buses interprovinciales, camiones medianos',
    costo: 'Bs. 250',
    duracionValidez: '2 años',
  ),
  LicenciaCategoria(
    codigo: 'E',
    descripcion: 'Licencia especial - Libre',
    capacidadMaxima: 999,
    tipoVehiculo: 'Cualquier vehículo: camiones pesados, buses 50+, maquinaria',
    costo: 'Bs. 300',
    duracionValidez: '2 años',
  ),
];
