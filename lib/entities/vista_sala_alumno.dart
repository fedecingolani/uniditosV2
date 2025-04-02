// To parse this JSON data, do
//
//     final vistaSalaAlumnos = vistaSalaAlumnosFromMap(jsonString);

import 'dart:convert';

List<VistaSalaAlumnos> vistaSalaAlumnosFromMap(String str) => List<VistaSalaAlumnos>.from(json.decode(str).map((x) => VistaSalaAlumnos.fromMap(x)));

String vistaSalaAlumnosToMap(List<VistaSalaAlumnos> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class VistaSalaAlumnos {
  int id;
  String nombre;
  String apellido;
  String nombreSala;
  int salaId;
  int alumnoId;

  VistaSalaAlumnos({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.nombreSala,
    required this.salaId,
    required this.alumnoId,
  });

  factory VistaSalaAlumnos.fromMap(Map<String, dynamic> json) => VistaSalaAlumnos(
        id: json["id"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        nombreSala: json["nombreSala"],
        salaId: json["salaId"],
        alumnoId: json["alumnoId"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "apellido": apellido,
        "nombreSala": nombreSala,
        "salaId": salaId,
        "alumnoId": alumnoId,
      };
}
