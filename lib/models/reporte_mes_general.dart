import 'dart:convert';

List<ReporteMes> reoporteFromMap(String str) => List<ReporteMes>.from(json.decode(str).map((x) => ReporteMes.fromMap(x)));

class ReporteMes {
  String nombreSala;
  List<Dato> datos;

  ReporteMes({
    required this.nombreSala,
    required this.datos,
  });

  factory ReporteMes.fromJson(String str) => ReporteMes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ReporteMes.fromMap(Map<String, dynamic> json) => ReporteMes(
        nombreSala: json["nombreSala"],
        datos: List<Dato>.from(json["datos"].map((x) => Dato.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "nombreSala": nombreSala,
        "datos": List<dynamic>.from(datos.map((x) => x.toMap())),
      };
}

class Dato {
  int alumnoId;
  String nombre;
  String apellido;
  List<Movimiento> movimientos;
  double totalMinutos;

  Dato({
    required this.alumnoId,
    required this.nombre,
    required this.apellido,
    required this.movimientos,
    required this.totalMinutos,
  });

  factory Dato.fromJson(String str) => Dato.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Dato.fromMap(Map<String, dynamic> json) => Dato(
        alumnoId: json["alumnoId"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        movimientos: List<Movimiento>.from(json["movimientos"].map((x) => Movimiento.fromMap(x))),
        totalMinutos: json["totalMinutos"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "alumnoId": alumnoId,
        "nombre": nombre,
        "apellido": apellido,
        "movimientos": List<dynamic>.from(movimientos.map((x) => x.toMap())),
        "totalMinutos": totalMinutos,
      };
}

class Movimiento {
  int movimientoId;
  int alumnoId;
  DateTime fechaIngreso;
  DateTime? fechaEgreso;

  Movimiento({
    required this.movimientoId,
    required this.alumnoId,
    required this.fechaIngreso,
    required this.fechaEgreso,
  });

  factory Movimiento.fromJson(String str) => Movimiento.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Movimiento.fromMap(Map<String, dynamic> json) => Movimiento(
        movimientoId: json["movimientoId"],
        alumnoId: json["alumnoId"],
        fechaIngreso: DateTime.parse(json["fechaIngreso"]),
        fechaEgreso: json["fechaEgreso"] == null ? null : DateTime.parse(json["fechaEgreso"]),
      );

  Map<String, dynamic> toMap() => {
        "movimientoId": movimientoId,
        "alumnoId": alumnoId,
        "fechaIngreso": fechaIngreso.toIso8601String(),
        "fechaEgreso": fechaEgreso?.toIso8601String(),
      };
}
