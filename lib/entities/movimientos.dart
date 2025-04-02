// To parse this JSON data, do
//
//     final movimientos = movimientosFromMap(jsonString);

import 'dart:convert';

List<Movimientos> movimientosFromMap(String str) => List<Movimientos>.from(json.decode(str).map((x) => Movimientos.fromMap(x)));

String movimientosToMap(List<Movimientos> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Movimientos {
  int movimientoId;
  int alumnoId;
  DateTime fechaIngreso;
  DateTime? fechaEgreso;
  Movimientos({
    required this.movimientoId,
    required this.alumnoId,
    required this.fechaIngreso,
    this.fechaEgreso,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({
      'movimientoId': movimientoId
    });
    result.addAll({
      'alumnoId': alumnoId
    });
    result.addAll({
      'fechaIngreso': fechaIngreso.toIso8601String()
    });
    if (fechaEgreso != null) {
      result.addAll({
        'fechaEgreso': fechaEgreso!.toIso8601String()
      });
    }

    return result;
  }

  factory Movimientos.fromMap(Map<String, dynamic> map) {
    return Movimientos(
      movimientoId: map['movimientoId']?.toInt() ?? 0,
      alumnoId: map['alumnoId']?.toInt() ?? 0,
      fechaIngreso: DateTime.parse(map['fechaIngreso']),
      fechaEgreso: map['fechaEgreso'] != null ? DateTime.parse(map['fechaEgreso']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Movimientos.fromJson(String source) => Movimientos.fromMap(json.decode(source));
}
