// To parse this JSON data, do
//
//     final vistaMovimiento = vistaMovimientoFromMap(jsonString);

import 'dart:convert';

List<VistaMovimiento> vistaMovimientoFromMap(String str) => List<VistaMovimiento>.from(json.decode(str).map((x) => VistaMovimiento.fromMap(x)));

String vistaMovimientoToMap(List<VistaMovimiento> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class VistaMovimiento {
  int alumnoId;
  String nombre;
  String apellido;
  bool activo;
  DateTime fechaIngreso;
  DateTime? fechaEgreso;
  int movimientoId;

  VistaMovimiento({
    required this.alumnoId,
    required this.nombre,
    required this.apellido,
    required this.activo,
    required this.fechaIngreso,
    required this.fechaEgreso,
    required this.movimientoId,
  });

  factory VistaMovimiento.fromMap(Map<String, dynamic> json) => VistaMovimiento(
        alumnoId: json["alumnoId"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        activo: json["activo"],
        fechaIngreso: DateTime.parse(json["fechaIngreso"]),
        fechaEgreso: json["fechaEgreso"] == null ? null : DateTime.parse(json["fechaEgreso"]),
        movimientoId: json["movimientoId"],
      );

  Map<String, dynamic> toMap() => {
        "alumnoId": alumnoId,
        "nombre": nombre,
        "apellido": apellido,
        "activo": activo,
        "fechaIngreso": fechaIngreso.toIso8601String(),
        "fechaEgreso": fechaEgreso?.toIso8601String(),
        "movimientoId": movimientoId,
      };
}
