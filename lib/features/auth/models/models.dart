class UserModel {
  String? nombre;
  String? apellido;
  String? celular;
  String? cedula;
  DateTime? fechaNacimiento;
  String? correo;
  String? pais;
  String? departamento;
  String? municipio;
  String? direccion;
  String? barrio;
  String? contrasena;
  String? bio;
  String? avatarUrl;
  String? status;

  String? descripcion;
  double? valorMensual;
  double? rating;
  double? seguidores;
  double? vistas;
  int? recetas;
  int? sesiones;
  String? duracion;

  UserModel({
    this.nombre,
    this.apellido,
    this.celular,
    this.cedula,
    this.fechaNacimiento,
    this.correo,
    this.pais,
    this.departamento,
    this.municipio,
    this.direccion,
    this.barrio,
    this.contrasena,
    this.bio,
    this.avatarUrl,
    this.status,
    this.descripcion,
    this.valorMensual,
    this.rating,
    this.seguidores,
    this.vistas,
    this.recetas,
    this.sesiones,
    this.duracion,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'celular': celular,
      'cedula': cedula,
      'fechaNacimiento': fechaNacimiento?.toIso8601String(),
      'correo': correo,
      'pais': pais,
      'departamento': departamento,
      'municipio': municipio,
      'direccion': direccion,
      'barrio': barrio,
      'contrasena': contrasena,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'status': status,
      'descripcion': descripcion,
      'valorMensual': valorMensual,
      'rating': rating,
      'seguidores': seguidores,
      'vistas': vistas,
      'recetas': recetas,
      'sesiones': sesiones,
      'duracion': duracion,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nombre: json['nombre'],
      apellido: json['apellido'],
      celular: json['celular'],
      cedula: json['cedula'],
      fechaNacimiento:
          json['fechaNacimiento'] != null
              ? DateTime.parse(json['fechaNacimiento'])
              : null,
      correo: json['correo'],
      pais: json['pais'],
      departamento: json['departamento'],
      municipio: json['municipio'],
      direccion: json['direccion'],
      barrio: json['barrio'],
      contrasena: json['contrasena'],
      bio: json['bio'],
      avatarUrl: json['avatarUrl'],
      status: json['status'],
      descripcion: json['descripcion'],
      valorMensual: (json['valorMensual'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      seguidores: json['seguidores'],
      vistas: json['vistas'],
      recetas: json['recetas'],
      sesiones: json['sesiones'],
      duracion: json['duracion'],
    );
  }

  UserModel copyWith({
    String? nombre,
    String? apellido,
    String? celular,
    String? cedula,
    DateTime? fechaNacimiento,
    String? correo,
    String? pais,
    String? departamento,
    String? municipio,
    String? direccion,
    String? barrio,
    String? contrasena,
    String? bio,
    String? avatarUrl,
    String? status,
    String? descripcion,
    double? valorMensual,
    double? rating,
    int? seguidores,
    int? vistas,
    int? recetas,
    int? sesiones,
    String? duracion,
  }) {
    return UserModel(
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      celular: celular ?? this.celular,
      cedula: cedula ?? this.cedula,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      correo: correo ?? this.correo,
      pais: pais ?? this.pais,
      departamento: departamento ?? this.departamento,
      municipio: municipio ?? this.municipio,
      direccion: direccion ?? this.direccion,
      barrio: barrio ?? this.barrio,
      contrasena: contrasena ?? this.contrasena,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
      descripcion: descripcion ?? this.descripcion,
      valorMensual: valorMensual ?? this.valorMensual,
      rating: rating ?? this.rating,
      seguidores: seguidores != null ? seguidores.toDouble() : this.seguidores,
      vistas: vistas != null ? vistas.toDouble() : this.vistas,
      recetas: recetas ?? this.recetas,
      sesiones: sesiones ?? this.sesiones,
      duracion: duracion ?? this.duracion,
    );
  }

  String get fullName => '${nombre ?? ''} ${apellido ?? ''}';
}
