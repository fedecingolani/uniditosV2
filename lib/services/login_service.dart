import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniditos/helper/nombres.dart';
import 'package:uniditos/services/settings.dart';

class LoginService {
  static Map<String, String> headers = {
    "Access-Control-Allow-Origin": "*",
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static readToken() {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    var roles = decodedToken['role'];
    if (roles.contains('Docente')) {
      docente = true;
    } else {
      docente = false;
    }
    payload = decodedToken;
  }

  static Future<String> login(String dni, String password) async {
    try {
      String url = '$urlbase/login';
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({"dni": dni, "password": password}),
      );
      if (response.statusCode == 401) {
        throw Exception('Usuario o contraseña incorrectos');
      }
      if (response.statusCode == 200) {
        saveCredentialsInSharedPreferences(dni, password);
        token = response.body.replaceAll('"', "");
        readToken();
        userApp = Helper.getDataToken(token);
        return token;
      } else {
        throw Exception('No responde el servidor');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<void> deleteCredentialsFromSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('dni');
      prefs.remove('password');
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<String> saveCredentialsInSharedPreferences(
    String dni,
    String password,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('dni', dni);
      prefs.setString('password', password);
      return 'ok';
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<String?> readCredentialsFromSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dni = prefs.getString('dni');
      String? password = prefs.getString('password');
      if (dni == null || password == null) {
        return null;
      }
      return '$dni:$password';
    } catch (e) {
      return Future.error(e);
    }
  }
}
