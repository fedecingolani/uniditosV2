import 'dart:convert';

class ContactoAlumno {
  int contactoAlumnoId;
  String nombre;
  String telefono;
  int alumnoId;
  ContactoAlumno({
    required this.contactoAlumnoId,
    required this.nombre,
    required this.telefono,
    required this.alumnoId,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({
      'contactoAlumnoId': contactoAlumnoId
    });
    result.addAll({
      'nombre': nombre
    });
    result.addAll({
      'telefono': telefono
    });
    result.addAll({
      'alumnoId': alumnoId
    });

    return result;
  }

  factory ContactoAlumno.fromMap(Map<String, dynamic> map) {
    return ContactoAlumno(
      contactoAlumnoId: map['contactoAlumnoId']?.toInt() ?? 0,
      nombre: map['nombre'] ?? '',
      telefono: map['telefono'] ?? '',
      alumnoId: map['alumnoId']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactoAlumno.fromJson(String source) => ContactoAlumno.fromMap(json.decode(source));
}
