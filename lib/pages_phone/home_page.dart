import 'package:flutter/material.dart';
import 'package:uniditos/pages_phone/alumnos/alumnos_page.dart';

import 'package:uniditos/pages_phone/movimientos/egreso_page.dart';
import 'package:uniditos/pages_phone/movimientos/ingreso_page.dart';
import 'package:uniditos/pages_phone/login.dart';
import 'package:uniditos/pages_phone/reportes/reporte_menu.dart';

import 'package:uniditos/services/login_service.dart';
import 'package:uniditos/services/settings.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Jardin Maternal Uniditos')),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              LoginService.deleteCredentialsFromSharedPreferences().then((
                value,
              ) {
                token = '';
                docente = false;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              });
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 250,
                child: Image.asset('assets/uniLogo.jpg'),
              ), // Agrega la ruta correcta de tu imagen
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const IngresoPage(),
                        ),
                      ),
                  child: const Text('Ingreso de Alumnos'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const EgresoPage(),
                        ),
                      ),
                  child: const Text('Egreso de Alumnos'),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AlumnosPage(),
                        ),
                      ),
                  child: const Text('Alumnos'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ReporteMenu(),
                        ),
                      ),
                  child: const Text('Reportes de Alumnos'),
                ),
              ),
              // const SizedBox(height: 20),
              // SizedBox(
              //   width: 200,
              //   child: ElevatedButton(
              //     onPressed: () => Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => const DocentesPage(),
              //       ),
              //     ),
              //     child: const Text('Docentes'),
              //   ),
              // ),
              // const SizedBox(height: 20),
              // SizedBox(
              //   width: 200,
              //   child: ElevatedButton(
              //     onPressed: () => Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => const SalasPage(),
              //       ),
              //     ),
              //     child: const Text('Salas'),
              //   ),
              // ),
              const Padding(padding: EdgeInsets.all(8.0), child: Divider()),
              const Text(
                'Version 1.0.10',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
