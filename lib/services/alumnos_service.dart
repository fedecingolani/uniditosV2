import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uniditos/entities/alumno_detail.dart';
import 'package:uniditos/entities/alumnos.dart';
import 'package:uniditos/entities/contacto_alumno.dart';
import 'package:uniditos/entities/vista_movimientos.dart';
import 'package:uniditos/entities/vista_sala_alumno.dart';
import 'package:uniditos/models/comedor_reset.dart';
import 'package:uniditos/models/new_alumno.dart';

import 'package:uniditos/services/settings.dart';

class AlumnosServices {
  static Map<String, String> headers = {
    "Access-Control-Allow-Origin": "*",
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  /// Trae todos los alumnos
  static Future<List<Alumnos>> getAlumnos() async {
    try {
      String url = '$urlbase/alumnos';
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return alumnosFromMap(response.body);
      } else {
        throw Exception('Failed to load Alumnos');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Trae un alumno en particular
  static Future<AlumnoDetail> getAlumnosId(int id) async {
    try {
      String url = '$urlbase/alumnos/$id';
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return AlumnoDetail.fromMap(json.decode(response.body));
      } else {
        throw Exception('Failed to load docentes');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Trae todos los alumnos con su sala
  static Future<List<VistaSalaAlumnos>> getAlumnosBySala() async {
    try {
      String url = '$urlbase/alumnos/sala';
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return vistaSalaAlumnosFromMap(response.body);
      } else {
        throw Exception('Failed to load alumnos by sala');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  ///Trae los alumons de una sala en particular
  static Future<List<VistaSalaAlumnos>> getAlumnosBySalaId(int idSala) async {
    try {
      String url = '$urlbase/alumnos/sala/$idSala';
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return vistaSalaAlumnosFromMap(response.body);
      } else {
        throw Exception('Failed to load alumnos by sala');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Trae los alumnos que estan dentro del jardin
  static Future<List<VistaMovimiento>> getAlumnosInside() async {
    try {
      String url = '$urlbase/alumnos/inside';
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return vistaMovimientoFromMap(response.body);
      } else {
        throw Exception('Failed to load alumnos online');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Trae los alumnos que estan dentro del jardin de una sala especifica
  static Future<List<VistaMovimiento>> getAlumnosInsideBySala(
    int salaID,
  ) async {
    try {
      String url = '$urlbase/alumnos/inside/sala/$salaID';
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return vistaMovimientoFromMap(response.body);
      } else {
        throw Exception('Failed to load alumnos online');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  ///Crea un nuevo alumno y lo asocia a una sala
  static Future<Alumnos> postAlumnos(Alumnos alumno, int salaid) async {
    try {
      NewAlumno newAlumno = NewAlumno(
        alumnoId: 0,
        nombre: alumno.nombre,
        apellido: alumno.apellido,
        salaId: salaid,
        dni: alumno.dni,
        fechaNacimiento: alumno.fechaNacimiento,
      );
      String url = '$urlbase/alumnos';

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(newAlumno.toMap()),
      );
      if (response.statusCode == 200) {
        return Alumnos.fromMap(json.decode(response.body));
      } else {
        throw Exception('Failed to load docentes');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  ///Asocia un alumno a un Sala
  static Future<Alumnos> postAlumnosSala(int alumnoId, int salaid) async {
    try {
      String url = '$urlbase/alumnos/$alumnoId/sala/$salaid';

      final response = await http.post(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return Alumnos.fromMap(json.decode(response.body));
      } else {
        return Future.error(response.body);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  ///Elimina un alumno de una sala
  static Future<void> deleteAlumnosSala(int alumnoId, int salaid) async {
    try {
      String url = '$urlbase/alumnos/$alumnoId/sala/$salaid';
      final response = await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode != 200) {
        return Future.error(response.body);
      }
      return;
    } catch (e) {
      return Future.error(e);
    }
  }

  ///Actualiza un alumno
  static Future<Alumnos> putAlumnos(Alumnos alumno) async {
    try {
      String url = '$urlbase/alumnos/${alumno.alumnoId}';
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: json.encode(alumno.toMap()),
      );
      if (response.statusCode == 200) {
        return Alumnos.fromMap(json.decode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  ///Crear un contacto de un alumno
  static Future<ContactoAlumno> postContactoAlumno(
    ContactoAlumno contacto,
  ) async {
    try {
      String url = '$urlbase/alumnos/contacto/${contacto.alumnoId}';
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(contacto.toMap()),
      );
      if (response.statusCode == 200) {
        return ContactoAlumno.fromMap(json.decode(response.body));
      } else {
        throw Exception('Failed to load docentes');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  ///Elimina un contacto de un alumno
  static Future<void> deleteContactoAlumno(int id) async {
    try {
      String url = '$urlbase/alumnos/contacto/$id';
      final response = await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to load contacto');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  ///Activa o desactiva la opcion de comedor para el alumno
  static Future<void> postComedor(int id, ComedorReset comedor) async {
    try {
      String url = '$urlbase/alumnos/$id/comedor/reset';

      final response = await http.post(
        Uri.parse(url),
        body: json.encode(comedor.toMap()),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to load comedor');
      }
      //await ComedorService.generarComedor();
    } catch (e) {
      return Future.error(e);
    }
  }

  ///Listado de alumnos para el comedor
  static Future<List<Alumnos>> getAlumnosComedor() async {
    try {
      String url = '$urlbase/comedor/status';
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return alumnosFromMap(response.body);
      } else {
        throw Exception('Failed to Comdedor');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
