class UserModel {
  final String id;
  final String tipoDocumento; // 'CI' o 'CE'
  final String numeroDocumento;
  final String? complemento;
  final String lugarExpedicion;
  final String nombres;
  final String apellidos;
  final DateTime fechaNacimiento;
  final String telefono;
  final String email;
  final String password; // En producción, usar hash
  final String genero;
  final String estadoCivil;
  final String profesion;
  final String direccion;
  final String? fotoCarnetFrente;
  final String? fotoCarnetAtras;
  final String? fotoSelfie;
  final DateTime fechaRegistro;
  bool estaVerificado;

  UserModel({
    String? id,
    required this.tipoDocumento,
    required this.numeroDocumento,
    this.complemento,
    required this.lugarExpedicion,
    required this.nombres,
    required this.apellidos,
    required this.fechaNacimiento,
    required this.telefono,
    required this.email,
    required this.password,
    required this.genero,
    required this.estadoCivil,
    required this.profesion,
    required this.direccion,
    this.fotoCarnetFrente,
    this.fotoCarnetAtras,
    this.fotoSelfie,
    DateTime? fechaRegistro,
    this.estaVerificado = false,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        fechaRegistro = fechaRegistro ?? DateTime.now();

  String get nombreCompleto => '$nombres $apellidos';

  String get documentoCompleto {
    if (complemento != null && complemento!.isNotEmpty) {
      return '$numeroDocumento-$complemento';
    }
    return numeroDocumento;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipoDocumento': tipoDocumento,
      'numeroDocumento': numeroDocumento,
      'complemento': complemento,
      'lugarExpedicion': lugarExpedicion,
      'nombres': nombres,
      'apellidos': apellidos,
      'fechaNacimiento': fechaNacimiento.toIso8601String(),
      'telefono': telefono,
      'email': email,
      'password': password,
      'genero': genero,
      'estadoCivil': estadoCivil,
      'profesion': profesion,
      'direccion': direccion,
      'fotoCarnetFrente': fotoCarnetFrente,
      'fotoCarnetAtras': fotoCarnetAtras,
      'fotoSelfie': fotoSelfie,
      'fechaRegistro': fechaRegistro.toIso8601String(),
      'estaVerificado': estaVerificado,
    };
  }

  // Alias para compatibilidad
  Map<String, dynamic> toMap() => toJson();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      tipoDocumento: json['tipoDocumento'] as String? ?? 'CI',
      numeroDocumento: json['numeroDocumento'] as String,
      complemento: json['complemento'] as String?,
      lugarExpedicion: json['lugarExpedicion'] as String,
      nombres: json['nombres'] as String,
      apellidos: json['apellidos'] as String,
      fechaNacimiento: json['fechaNacimiento'] is DateTime
          ? json['fechaNacimiento'] as DateTime
          : DateTime.parse(json['fechaNacimiento'] as String),
      telefono: json['telefono'] as String,
      email: json['email'] as String,
      password: json['password'] as String? ?? '',
      genero: json['genero'] as String? ?? '',
      estadoCivil: json['estadoCivil'] as String? ?? '',
      profesion: json['profesion'] as String? ?? '',
      direccion: json['direccion'] as String? ?? '',
      fotoCarnetFrente: json['fotoCarnetFrente'] as String?,
      fotoCarnetAtras: json['fotoCarnetAtras'] as String?,
      fotoSelfie: json['fotoSelfie'] as String?,
      fechaRegistro: json['fechaRegistro'] != null
          ? (json['fechaRegistro'] is DateTime
              ? json['fechaRegistro'] as DateTime
              : DateTime.parse(json['fechaRegistro'] as String))
          : DateTime.now(),
      estaVerificado: json['estaVerificado'] as bool? ?? false,
    );
  }

  // Alias para compatibilidad
  factory UserModel.fromMap(Map<String, dynamic> map) =>
      UserModel.fromJson(map);

  UserModel copyWith({
    String? id,
    String? tipoDocumento,
    String? numeroDocumento,
    String? complemento,
    String? lugarExpedicion,
    String? nombres,
    String? apellidos,
    DateTime? fechaNacimiento,
    String? telefono,
    String? email,
    String? password,
    String? genero,
    String? estadoCivil,
    String? profesion,
    String? direccion,
    String? fotoCarnetFrente,
    String? fotoCarnetAtras,
    String? fotoSelfie,
    bool? estaVerificado,
  }) {
    return UserModel(
      id: id ?? this.id,
      tipoDocumento: tipoDocumento ?? this.tipoDocumento,
      numeroDocumento: numeroDocumento ?? this.numeroDocumento,
      complemento: complemento ?? this.complemento,
      lugarExpedicion: lugarExpedicion ?? this.lugarExpedicion,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      password: password ?? this.password,
      genero: genero ?? this.genero,
      estadoCivil: estadoCivil ?? this.estadoCivil,
      profesion: profesion ?? this.profesion,
      direccion: direccion ?? this.direccion,
      fotoCarnetFrente: fotoCarnetFrente ?? this.fotoCarnetFrente,
      fotoCarnetAtras: fotoCarnetAtras ?? this.fotoCarnetAtras,
      fotoSelfie: fotoSelfie ?? this.fotoSelfie,
      fechaRegistro: fechaRegistro,
      estaVerificado: estaVerificado ?? this.estaVerificado,
    );
  }
}
