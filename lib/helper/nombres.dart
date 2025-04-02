import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:uniditos/models/user.dart';

class Helper {
  static User getDataToken(String token) {
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      User user = User.fromMap(decodedToken);
      user.alias = getAlias(user.nombre);
      return user;
    } catch (e) {
      return User(nombre: '', alias: '', apellido: '', id: '', roles: []);
    }
  }

  static String getAlias(String nombre) {
    String alias = nombre.trim();
    switch (alias) {
      case 'Florencia':
        return 'Flori';
      case 'Sofia':
        return 'Sofi';
      case 'Alicia':
        return 'Ali';
      case 'Julia':
        return 'Juli';
      case 'Camila':
        return 'Cami';
      case 'Mariana':
        return 'Mariu';
      case 'Maria Laura':
        return 'Lau';
      case 'Valentina':
        return 'Valen';
      case 'Carina':
        return 'Cari';
      case 'Veronica':
        return 'Vero';
      default:
        return alias;
    }
  }
}
