import 'dart:convert';

import 'package:uniditos/entities/Comprobantes.dart';
import 'package:uniditos/services/settings.dart';

import 'package:http/http.dart' as http;

class ComprobantesService {
  static Map<String, String> headers = {
    "Access-Control-Allow-Origin": "*",
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  /// Trae todos los comprobantes de un alumno
  static Future<List<Comprobantes>> getComprobantesByAlumno(int id) async {
    try {
      String url = '$urlbase/comprobantes/alumno/$id';
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return comprobantesFromMap(response.body);
      } else {
        throw Exception('Failed to load comprobantes');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  //nuevo Comprobante
  static Future<http.Response> createComprobante(
    Comprobantes comprobante,
  ) async {
    try {
      String url = '$urlbase/comprobantes';
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(comprobante.toMap()),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<http.Response> deleteComprobante(int id) {
    try {
      String url = '$urlbase/comprobantes/$id';
      return http.delete(Uri.parse(url), headers: headers);
    } catch (e) {
      return Future.error(e);
    }
  }
}
