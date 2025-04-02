import 'dart:convert';

List<ResponseComedor> responseComedorFromMap(String str) => List<ResponseComedor>.from(json.decode(str).map((x) => ResponseComedor.fromMap(x)));

String responseComedorToMap(List<ResponseComedor> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ResponseComedor {
  int alumnoId;
  String nombre;
  String apellido;
  DateTime? fechaNacimiento;
  String? dni;
  dynamic fechaIngreso;
  dynamic fechaEgreso;
  bool activo;
  DateTime fecha;
  int importe;
  bool pago;
  int movimientoId;
  ResponseComedor({
    required this.alumnoId,
    required this.nombre,
    required this.apellido,
    this.fechaNacimiento,
    this.dni,
    required this.fechaIngreso,
    required this.fechaEgreso,
    required this.activo,
    required this.fecha,
    required this.importe,
    required this.pago,
    required this.movimientoId,
  });

  ResponseComedor copyWith({
    int? alumnoId,
    String? nombre,
    DateTime? fechaNacimiento,
    String? dni,
    dynamic? fechaIngreso,
    dynamic? fechaEgreso,
    bool? activo,
    DateTime? fecha,
    int? importe,
    bool? pago,
    int? movimientoId,
  }) {
    return ResponseComedor(
      alumnoId: alumnoId ?? this.alumnoId,
      apellido: apellido ?? this.apellido,
      nombre: nombre ?? this.nombre,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      dni: dni ?? this.dni,
      fechaIngreso: fechaIngreso ?? this.fechaIngreso,
      fechaEgreso: fechaEgreso ?? this.fechaEgreso,
      activo: activo ?? this.activo,
      fecha: fecha ?? this.fecha,
      importe: importe ?? this.importe,
      pago: pago ?? this.pago,
      movimientoId: movimientoId ?? this.movimientoId,
    );
  }

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
        'fechaNacimiento': fechaNacimiento!.millisecondsSinceEpoch
      });
    }
    if (dni != null) {
      result.addAll({
        'dni': dni
      });
    }
    result.addAll({
      'fechaIngreso': fechaIngreso
    });
    result.addAll({
      'fechaEgreso': fechaEgreso
    });
    result.addAll({
      'activo': activo
    });
    result.addAll({
      'fecha': fecha.millisecondsSinceEpoch
    });
    result.addAll({
      'importe': importe
    });
    result.addAll({
      'pago': pago
    });
    result.addAll({
      'movimientoId': movimientoId
    });

    return result;
  }

  factory ResponseComedor.fromMap(Map<String, dynamic> map) {
    return ResponseComedor(
      alumnoId: map['alumnoId']?.toInt() ?? 0,
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      fechaNacimiento: map['fechaNacimiento'] != null ? DateTime.parse(map['fechaNacimiento']) : null,
      dni: map['dni'],
      fechaIngreso: map['fechaIngreso'] ,
      fechaEgreso: map['fechaEgreso'] ,
      activo: map['activo'] ?? false,
      fecha: DateTime.parse(map['fecha']),
      importe: map['importe']?.toInt() ?? 0,
      pago: map['pago'] ?? false,
      movimientoId: map['movimientoId']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseComedor.fromJson(String source) => ResponseComedor.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ResponseComedor(alumnoId: $alumnoId, nombre: $nombre, fechaNacimiento: $fechaNacimiento, dni: $dni, fechaIngreso: $fechaIngreso, fechaEgreso: $fechaEgreso, activo: $activo, fecha: $fecha, importe: $importe, pago: $pago, movimientoId: $movimientoId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResponseComedor && other.alumnoId == alumnoId && other.nombre == nombre && other.fechaNacimiento == fechaNacimiento && other.dni == dni && other.fechaIngreso == fechaIngreso && other.fechaEgreso == fechaEgreso && other.activo == activo && other.fecha == fecha && other.importe == importe && other.pago == pago && other.movimientoId == movimientoId;
  }

  @override
  int get hashCode {
    return alumnoId.hashCode ^ nombre.hashCode ^ fechaNacimiento.hashCode ^ dni.hashCode ^ fechaIngreso.hashCode ^ fechaEgreso.hashCode ^ activo.hashCode ^ fecha.hashCode ^ importe.hashCode ^ pago.hashCode ^ movimientoId.hashCode;
  }
}
