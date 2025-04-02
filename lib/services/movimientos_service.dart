import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uniditos/entities/movimientos.dart';
import 'package:uniditos/services/settings.dart';

class MovimientosService {
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Authorization': 'Bearer $token',
  };

  // static Future<List<Movimientos>> getMovimientos() async {
  //   try {
  //     String url = '$urlbase/movimientos';
  //     final response = await http.get(Uri.parse(url), headers: headers);
  //     if (response.statusCode == 200) {
  //       return movimientosFromMap(response.body);
  //     }
  //     return Future.error('Failed to load movimientos');
  //   } catch (e) {
  //     return Future.error(e);
  //   }
  // }

  static Future<List<Movimientos>> getMovimientosByAlumno(
    int idAlumno, {
    int? mes,
  }) async {
    try {
      mes ??= DateTime.now().month;
      String url = '$urlbase/movimientos/alumno/$idAlumno/mes/$mes';
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var movimientos = movimientosFromMap(response.body);
        //filtrar solamente los de este año
        movimientos =
            movimientos
                .where(
                  (element) => element.fechaIngreso.year == DateTime.now().year,
                )
                .toList();
        print(movimientos);
        return movimientos;
      } else {
        return Future.error('Failed to load movimientos by alumno');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  //post movimientos
  static Future<Movimientos> postMovimientos(Movimientos movimientos) async {
    try {
      String url = '$urlbase/movimientos';

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(movimientos.toMap()),
      );
      if (response.statusCode == 400) {
        return Future.error(response.body);
      }
      if (response.statusCode == 200) {
        return Movimientos.fromMap(jsonDecode(response.body));
      } else {
        return Future.error('Failed to post movimientos');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  //post movimientos
  static Future<Movimientos> putMovimiento(Movimientos movimientos) async {
    try {
      String url = '$urlbase/movimientos/${movimientos.movimientoId}';

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(movimientos.toMap()),
      );
      if (response.statusCode == 400) {
        return Future.error(response.body);
      }
      if (response.statusCode == 200) {
        return Movimientos.fromMap(jsonDecode(response.body));
      } else {
        return Future.error(response.body);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<void> deleteMovimiento(int id) async {
    try {
      String url = '$urlbase/movimientos/$id';
      final response = await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return;
      }
      return Future.error(response.body);
    } catch (e) {
      return Future.error(e);
    }
  }
}
