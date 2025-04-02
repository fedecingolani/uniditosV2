// To parse this JSON data, do
//
//     final docentes = docentesFromMap(jsonString);

import 'dart:convert';

List<Docentes> docentesFromMap(String str) => List<Docentes>.from(json.decode(str).map((x) => Docentes.fromMap(x)));

String docentesToMap(List<Docentes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Docentes {
  int docenteId;
  String nombre;
  String apellido;
  bool activo;
  Docentes({
    required this.docenteId,
    required this.nombre,
    required this.apellido,
    required this.activo,
  });

  // Docentes({
  //   required this.docenteId,
  //   required this.nombre,
  //   required this.apellido,
  //   required this.activo,
  // });

  // String toJson() => json.encode(toMap());

  // factory Docentes.fromMap(Map<String, dynamic> json) => Docentes(
  //       docenteId: json["docenteId"],
  //       nombre: json["nombre"],
  //       apellido: json["apellido"],
  //       activo: json["activo"],
  //     );

  // Map<String, dynamic> toMap() => {
  //       "docenteId": docenteId,
  //       "nombre": nombre,
  //       "apellido": apellido,
  //       "activo": activo,
  //     };

  Docentes copyWith({
    String? nombre,
    String? apellido,
    bool? activo,
  }) {
    return Docentes(
      docenteId: docenteId,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      activo: activo ?? this.activo,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({
      'docenteId': docenteId
    });

    result.addAll({
      'nombre': nombre
    });
    result.addAll({
      'apellido': apellido
    });
    result.addAll({
      'activo': activo
    });

    return result;
  }

  factory Docentes.fromMap(Map<String, dynamic> map) {
    return Docentes(
      docenteId: map['docenteId'] ?? 0,
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      activo: map['activo'] ?? false,
    );
  }

  factory Docentes.fromJson(String source) => Docentes.fromMap(json.decode(source));

  @override
  String toString() => 'Docentes(nombre: $nombre, apellido: $apellido, activo: $activo)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Docentes && other.nombre == nombre && other.apellido == apellido && other.activo == activo;
  }

  @override
  int get hashCode => nombre.hashCode ^ apellido.hashCode ^ activo.hashCode;

  String toJson() => json.encode(toMap());
}
