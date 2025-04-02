import 'package:http/http.dart' as http;

import 'package:uniditos/entities/salas.dart';
import 'package:uniditos/services/settings.dart';

class SalasServices {
  static Map<String, String> headers = {
    "Access-Control-Allow-Origin": "*",
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  static Future<List<Salas>> getSalas() async {
    try {
      String url = '$urlbase/salas';
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return salasFromMap(response.body);
      } else {
        throw Exception('Failed to load docentes');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
