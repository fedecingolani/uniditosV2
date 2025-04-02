import 'dart:convert';

class ComedorCreate {
  int? movimientoId = 0;
  int alumnoId;
  DateTime fecha;
  double importe;
  bool pago;

  ComedorCreate({
    required this.alumnoId,
    required this.fecha,
    required this.importe,
    required this.pago,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({
      'alumnoId': alumnoId
    });
    result.addAll({
      'fecha': fecha.toIso8601String().split('T')[0]
    });
    result.addAll({
      'importe': importe
    });
    result.addAll({
      'pago': pago
    });

    return result;
  }

  factory ComedorCreate.fromMap(Map<String, dynamic> map) {
    return ComedorCreate(
      alumnoId: map['alumnoId'] ?? '',
      fecha: DateTime.parse(map['fecha']),
      importe: map['importe']?.toInt() ?? 0,
      pago: map['pago'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ComedorCreate.fromJson(String source) => ComedorCreate.fromMap(json.decode(source));
}
