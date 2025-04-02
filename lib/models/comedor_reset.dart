import 'dart:convert';

class ComedorReset {
  bool comedor;
  DateTime? fechaVencimiento;
  ComedorReset({
    required this.comedor,
    required this.fechaVencimiento,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({
      'comedor': comedor
    });
    if (fechaVencimiento != null) {
      result.addAll({
        'fechaVencimiento': fechaVencimiento!.toIso8601String()
      });
    }

    return result;
  }

  factory ComedorReset.fromMap(Map<String, dynamic> map) {
    return ComedorReset(
      comedor: map['comedor'] ?? false,
      fechaVencimiento: map['fechaVencimiento'] != null ? DateTime.fromMillisecondsSinceEpoch(map['fechaVencimiento']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ComedorReset.fromJson(String source) => ComedorReset.fromMap(json.decode(source));
}
