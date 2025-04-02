import 'dart:convert';

import 'package:uniditos/entities/contacto_alumno.dart';
import 'package:uniditos/entities/salas.dart';

class AlumnoDetail {
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
  List<Salas> salas = [];
  List<ContactoAlumno> contactoAlumnos;
  AlumnoDetail({
    required this.alumnoId,
    required this.nombre,
    required this.apellido,
    this.fechaNacimiento,
    this.dni,
    this.fechaIngreso,
    this.fechaEgreso,
    required this.activo,
    required this.salas,
    required this.contactoAlumnos,
    required this.comedor,
    this.fechaVencimientoComedor,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'alumnoId': alumnoId});
    result.addAll({'nombre': nombre});
    result.addAll({'apellido': apellido});
    if (fechaNacimiento != null) {
      result.addAll({
        'fechaNacimiento': fechaNacimiento!.millisecondsSinceEpoch,
      });
    }
    if (dni != null) {
      result.addAll({'dni': dni});
    }
    if (fechaIngreso != null) {
      result.addAll({'fechaIngreso': fechaIngreso!.millisecondsSinceEpoch});
    }
    if (fechaEgreso != null) {
      result.addAll({'fechaEgreso': fechaEgreso!.millisecondsSinceEpoch});
    }
    result.addAll({'activo': activo});
    result.addAll({'salas': salas.map((x) => x.toMap()).toList()});
    result.addAll({
      'contactoAlumnos': contactoAlumnos.map((x) => x.toMap()).toList(),
    });
    result.addAll({'comedor': comedor});
    if (fechaVencimientoComedor != null) {
      result.addAll({
        'fechaVencimientoComedor': fechaVencimientoComedor!.toIso8601String(),
      });
    }

    return result;
  }

  factory AlumnoDetail.fromMap(Map<String, dynamic> map) {
    return AlumnoDetail(
      alumnoId: map['alumnoId']?.toInt() ?? 0,
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      fechaNacimiento:
          map['fechaNacimiento'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['fechaNacimiento'])
              : null,
      dni: map['dni'],
      fechaIngreso:
          map['fechaIngreso'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['fechaIngreso'])
              : null,
      fechaEgreso:
          map['fechaEgreso'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['fechaEgreso'])
              : null,
      activo: map['activo'] ?? false,
      salas: List<Salas>.from(map['salas']?.map((x) => Salas.fromMap(x))),
      contactoAlumnos: List<ContactoAlumno>.from(
        map['contactoAlumnos']?.map((x) => ContactoAlumno.fromMap(x)),
      ),
      comedor: map['comedor'] ?? false,
      fechaVencimientoComedor:
          map['fechaVencimientoComedor'] != null
              ? DateTime.parse(map['fechaVencimientoComedor'])
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AlumnoDetail.fromJson(String source) =>
      AlumnoDetail.fromMap(json.decode(source));
}
