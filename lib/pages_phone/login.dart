import 'package:flutter/material.dart';
import 'package:uniditos/pages_phone/alumnos/alumnos_home.dart';

import 'package:uniditos/pages_phone/menu/home_docente.dart';
import 'package:uniditos/services/login_service.dart';
import 'package:uniditos/services/settings.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController dniController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;

  bool errorLogin = false;

  @override
  void initState() {
    LoginService.readCredentialsFromSharedPreferences().then((value) {
      if (value != null) {
        List<String> credentials = value.split(':');
        dniController.text = credentials[0];
        passwordController.text = credentials[1];
        LoginService.login(dniController.text, passwordController.text).then((
          value,
        ) {
          if (value.isNotEmpty) {
            if (docente == false) {
              Navigator.of(context)
                  .pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder:
                          (context) => AlumnosHome(
                            id: int.parse(payload['ID']),
                            indexPage: 0,
                          ),
                    ),
                    (Route<dynamic> route) => false,
                  )
                  .catchError((e) {});
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeDocente()),
                (Route<dynamic> route) => false,
              );
            }
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ancho = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: ancho > 250 ? 250 : ancho,
                child: Image.asset('assets/uniLogo.jpg'),
              ), // Agrega la ruta correcta de tu imagen
              const SizedBox(height: 20),
              const SizedBox(height: 50),
              SizedBox(
                width: ancho > 250 ? 250 : ancho,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: dniController,
                    decoration: const InputDecoration(
                      labelText: 'DNI',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: ancho > 250 ? 250 : ancho,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              errorLogin
                  ? const Text(
                    'Usuario o contraseña incorrectos',
                    style: TextStyle(color: Colors.red),
                  )
                  : const SizedBox(),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    LoginService.login(
                          dniController.text,
                          passwordController.text,
                        )
                        .then((value) {
                          if (value.isNotEmpty) {
                            if (docente == false) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder:
                                      (context) => AlumnosHome(
                                        id: int.parse(payload['ID']),
                                        indexPage: 0,
                                      ),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            } else {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const HomeDocente(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            }
                          } else {
                            setState(() {
                              errorLogin = true;
                            });
                          }
                        })
                        .catchError((e) {
                          setState(() {
                            errorLogin = true;
                          });
                        });
                  },
                  child: const Text('Ingresar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
