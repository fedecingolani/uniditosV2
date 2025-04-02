// To parse this JSON data, do
//
//     final salas = salasFromMap(jsonString);

import 'dart:convert';

List<Salas> salasFromMap(String str) => List<Salas>.from(json.decode(str).map((x) => Salas.fromMap(x)));

String salasToMap(List<Salas> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Salas {
  int salaId;
  String nombreSala;
  bool activa;
  int ano;
  String? alias;

  Salas({
    required this.salaId,
    required this.nombreSala,
    required this.activa,
    required this.ano,
    required this.alias,
  });

  factory Salas.fromMap(Map<String, dynamic> json) => Salas(
        salaId: json["salaId"],
        nombreSala: json["nombreSala"],
        activa: json["activa"],
        ano: json["año"],
        alias: json["alias"],
      );

  Map<String, dynamic> toMap() => {
        "salaId": salaId,
        "nombreSala": nombreSala,
        "activa": activa,
        "año": ano,
        "alias": alias,
      };
}
