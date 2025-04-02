import 'dart:convert';

class TestModel {
  String id;
  String name;
  String description;
  TestModel({
    required this.id,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({
      'id': id
    });
    result.addAll({
      'name': name
    });
    result.addAll({
      'description': description
    });

    return result;
  }

  factory TestModel.fromMap(Map<String, dynamic> map) {
    return TestModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TestModel.fromJson(String source) => TestModel.fromMap(json.decode(source));
}
