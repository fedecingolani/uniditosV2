import 'package:http/http.dart' as http;

import 'package:uniditos/models/reporte_mes_general.dart';
import 'package:uniditos/services/settings.dart';

class ReporteSerivce {
  static Map<String, String> headers = {
    "Access-Control-Allow-Origin": "*",
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  static Future<List<ReporteMes>> getReporteMes2025(int mes) async {
    try {
      String url = '$urlbase/movimientos/reportes/mes_nuevo/$mes';
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return reoporteFromMap(response.body);
      } else {
        throw Exception('Failed to load reporte mes');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<List<ReporteMes>> getReporteMes(int mes) async {
    try {
      String url = '$urlbase/movimientos/reportes/mes/$mes';
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return reoporteFromMap(response.body);
      } else {
        throw Exception('Failed to load reporte mes');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
