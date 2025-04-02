import 'dart:convert';

import 'package:http/http.dart';
import 'package:uniditos/models/comedor_create.dart';
import 'package:uniditos/models/response_comedor.dart';
import 'package:uniditos/services/settings.dart';

import 'package:http/http.dart' as http;

class ComedorService {
  static Map<String, String> headers = {
    "Access-Control-Allow-Origin": "*",
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  static Future createDay() async {
    try {
      String url = '$urlbase/comedor/createDay';
      final response = await http.post(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to create day');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<List<ResponseComedor>> getComedor() async {
    try {
      String url = '$urlbase/comedor/status';
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return responseComedorFromMap(response.body);
      } else {
        throw Exception('Failed to load comedor');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<List<ResponseComedor>> getComedorByAlumno({
    required int id,
    int? mes,
  }) async {
    try {
      String url = '';
      if (mes != null) {
        url = '$urlbase/comedor/alumno/$id?mes=$mes';
      } else {
        url = '$urlbase/comedor/alumno/$id';
      }

      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return responseComedorFromMap(response.body);
      } else {
        throw Exception('Failed to load getComedorByAlumno');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<void> generarComedor() async {
    try {
      print('Generamos el comedor');
      await http.post(
        Uri.parse('$urlbase/comedor/GenerarComedor'),
        headers: headers,
      );
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Response> createMovimientoComedor(ComedorCreate data) async {
    try {
      String url = '$urlbase/comedor';
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(data.toMap()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        //await generarComedor();
        return response;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<dynamic> deleteMovimientoComedor(int id) async {
    try {
      String url = '$urlbase/comedor/$id';
      final response = await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
