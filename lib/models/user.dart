import 'dart:convert';

class User {
  String nombre;
  String alias;
  String apellido;
  String id;
  List<String> roles;
  User({
    required this.nombre,
    required this.alias,
    required this.apellido,
    required this.id,
    required this.roles,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({
      'nombre': nombre
    });
    result.addAll({
      'apellido': apellido
    });
    result.addAll({
      'id': id
    });
    result.addAll({
      'role': roles
    });

    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      nombre: map['Nombre'] ?? '',
      alias: map['Alias'] ?? map['Nombre'] ?? '',
      apellido: map['Apellido'] ?? '',
      id: map['ID'] ?? '',
      roles: List<String>.from(map['role']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
