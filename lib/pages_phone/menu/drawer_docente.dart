import 'package:flutter/material.dart';
import 'package:uniditos/pages_phone/login.dart';
import 'package:uniditos/services/login_service.dart';
import 'package:uniditos/services/settings.dart';

class MenuDocente extends StatelessWidget {
  const MenuDocente({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                children: <Widget>[
                  //image center
                  SizedBox(
                    height: 100,
                    child: Image.asset('assets/uniLogo.jpg'),
                  ), //

                  Text(
                    'Hola ${userApp?.alias ?? ''}!',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.login_outlined),
            title: const Text('Cerrar Sesion'),
            onTap: () {
              LoginService.deleteCredentialsFromSharedPreferences().then((
                value,
              ) {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              });
            },
          ),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Versión: $versionApp - Darkflow SRL',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
