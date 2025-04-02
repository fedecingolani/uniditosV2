import 'dart:convert';

class NewAlumno {
  int alumnoId;

  String nombre;

  String apellido;

  DateTime? fechaNacimiento;

  String? dni;

  DateTime? fechaIngreso;

  int salaId;
  NewAlumno({
    required this.alumnoId,
    required this.nombre,
    required this.apellido,
    this.fechaNacimiento,
    this.dni,
    this.fechaIngreso,
    required this.salaId,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({
      'alumnoId': alumnoId
    });
    result.addAll({
      'nombre': nombre
    });
    result.addAll({
      'apellido': apellido
    });
    if (fechaNacimiento != null) {
      result.addAll({
        'fechaNacimiento': fechaNacimiento!.toIso8601String()
      });
    }
    if (dni != null) {
      result.addAll({
        'dni': dni
      });
    }
    if (fechaIngreso != null) {
      result.addAll({
        'fechaIngreso': fechaIngreso!.toIso8601String()
      });
    }
    result.addAll({
      'salaId': salaId
    });

    return result;
  }

  factory NewAlumno.fromMap(Map<String, dynamic> map) {
    return NewAlumno(
      alumnoId: map['alumnoId']?.toInt() ?? 0,
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      fechaNacimiento: map['fechaNacimiento'] != null ? DateTime.fromMillisecondsSinceEpoch(map['fechaNacimiento']) : null,
      dni: map['dni'],
      fechaIngreso: map['fechaIngreso'] != null ? DateTime.fromMillisecondsSinceEpoch(map['fechaIngreso']) : null,
      salaId: map['salaId']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewAlumno.fromJson(String source) => NewAlumno.fromMap(json.decode(source));
}
