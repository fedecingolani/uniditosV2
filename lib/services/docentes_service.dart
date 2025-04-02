import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uniditos/entities/docentes.dart';
import 'package:uniditos/services/settings.dart';

class DocentesService {
  static Map<String, String> headers = {
    "Access-Control-Allow-Origin": "*",
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  static Future<List<Docentes>> getDocentes() async {
    try {
      String url = '$urlbase/docentes';
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return docentesFromMap(response.body);
      } else {
        throw Exception('Failed to load docentes');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Docentes> postDocentes(Docentes docentes) async {
    try {
      String url = '$urlbase/docentes';

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(docentes.toMap()),
      );
      if (response.statusCode == 200) {
        return docentesFromMap(response.body).first;
      } else {
        throw Exception('Failed to post docentes');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
