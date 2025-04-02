import 'dart:convert';

List<Comprobantes> comprobantesFromMap(String str) => List<Comprobantes>.from(json.decode(str).map((x) => Comprobantes.fromMap(x)));

class Comprobantes {
  int id;
  DateTime fecha;
  int alumnoId;
  String detalle;
  int importe;
  String letraComprobante;
  String notas;
  int numeroComprobante;
  Comprobantes({
    required this.id,
    required this.fecha,
    required this.alumnoId,
    required this.detalle,
    required this.importe,
    required this.letraComprobante,
    required this.notas,
    required this.numeroComprobante,
  });

  Comprobantes copyWith({
    int? id,
    DateTime? fecha,
    int? alumnoId,
    String? detalle,
    int? importe,
    String? letraComprobante,
    String? notas,
    int? numeroComprobante,
  }) {
    return Comprobantes(
      id: id ?? this.id,
      fecha: fecha ?? this.fecha,
      alumnoId: alumnoId ?? this.alumnoId,
      detalle: detalle ?? this.detalle,
      importe: importe ?? this.importe,
      letraComprobante: letraComprobante ?? this.letraComprobante,
      notas: notas ?? this.notas,
      numeroComprobante: numeroComprobante ?? this.numeroComprobante,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({
      'id': id
    });
    result.addAll({
      'fecha': fecha.toIso8601String().split('T')[0]
    });
    result.addAll({
      'alumnoId': alumnoId
    });
    result.addAll({
      'detalle': detalle
    });
    result.addAll({
      'importe': importe
    });
    result.addAll({
      'letraComprobante': letraComprobante
    });
    result.addAll({
      'notas': notas
    });
    result.addAll({
      'numeroComprobante': numeroComprobante
    });

    return result;
  }

  factory Comprobantes.fromMap(Map<String, dynamic> map) {
    return Comprobantes(
      id: map['id']?.toInt() ?? 0,
      fecha: DateTime.parse(map['fecha']),
      alumnoId: map['alumnoId']?.toInt() ?? 0,
      detalle: map['detalle'] ?? '',
      importe: map['importe']?.toInt() ?? 0,
      letraComprobante: map['letraComprobante'] ?? '',
      notas: map['notas'] ?? '',
      numeroComprobante: map['numeroComprobante']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comprobantes.fromJson(String source) => Comprobantes.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Comprobantes(id: $id, fecha: $fecha, alumnoId: $alumnoId, detalle: $detalle, importe: $importe, letraComprobante: $letraComprobante, notas: $notas, numeroComprobante: $numeroComprobante)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comprobantes && other.id == id && other.fecha == fecha && other.alumnoId == alumnoId && other.detalle == detalle && other.importe == importe && other.letraComprobante == letraComprobante && other.notas == notas && other.numeroComprobante == numeroComprobante;
  }

  @override
  int get hashCode {
    return id.hashCode ^ fecha.hashCode ^ alumnoId.hashCode ^ detalle.hashCode ^ importe.hashCode ^ letraComprobante.hashCode ^ notas.hashCode ^ numeroComprobante.hashCode;
  }
}
