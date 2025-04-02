// To parse this JSON data, do
//
//     final alumnos = alumnosFromMap(jsonString);

import 'dart:convert';

List<Alumnos> alumnosFromMap(String str) => List<Alumnos>.from(json.decode(str).map((x) => Alumnos.fromMap(x)));

String alumnosToMap(List<Alumnos> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Alumnos {
  int alumnoId;
  String nombre;
  String apellido;
  DateTime? fechaNacimiento;
  String? dni;
  DateTime? fechaIngreso;
  DateTime? fechaEgreso;
  bool activo;
  bool comedor;
  DateTime? fechaVencimientoComedor;
  Alumnos({
    required this.alumnoId,
    required this.nombre,
    required this.apellido,
    this.fechaNacimiento,
    this.dni,
    this.fechaIngreso,
    this.fechaEgreso,
    required this.activo,
    required this.comedor,
    this.fechaVencimientoComedor,
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
    if (fechaIngreso != null) {
      result.addAll({
        'fechaIngreso': fechaIngreso!.toIso8601String()
      });
    }
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

    if (fechaEgreso != null) {
      result.addAll({
        'fechaEgreso': fechaEgreso!.toIso8601String()
      });
    }
    result.addAll({
      'activo': activo
    });
    result.addAll({
      'comedor': comedor
    });
    if (fechaVencimientoComedor != null) {
      result.addAll({
        'fechaVencimientoComedor': fechaVencimientoComedor!.toIso8601String()
      });
    }

    return result;
  }

  factory Alumnos.fromMap(Map<String, dynamic> map) {
    return Alumnos(
      alumnoId: map['alumnoId']?.toInt() ?? 0,
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      fechaNacimiento: DateTime.parse(map['fechaNacimiento'] ?? DateTime.now().toString()),
      dni: map['dni'],
      fechaIngreso: map['fechaIngreso'] != null ? DateTime.parse(map['fechaIngreso']) : null,
      fechaEgreso: map['fechaEgreso'] != null ? DateTime.parse(map['fechaEgreso']) : null,
      activo: map['activo'] ?? false,
      comedor: map['comedor'] ?? false,
      fechaVencimientoComedor: map['fechaVencimientoComedor'] != null ? DateTime.parse(map['fechaVencimientoComedor']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Alumnos.fromJson(String source) => Alumnos.fromMap(json.decode(source));
}
