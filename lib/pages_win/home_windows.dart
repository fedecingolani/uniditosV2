import 'package:flutter/material.dart';
import 'package:uniditos/pages_phone/alumnos/alumnos_page.dart';
import 'package:uniditos/pages_win/comprobantes_page.dart';

class HomeWindows extends StatefulWidget {
  const HomeWindows({super.key});

  @override
  State<HomeWindows> createState() => _HomeWindowsState();
}

class _HomeWindowsState extends State<HomeWindows> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Administración Uniditos'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            //image logo
            SizedBox(width: 250, child: Image.asset('assets/uniLogo.jpg')),
            // lista de botones para acceso a las diferentes secciones
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ComprobanteScreen(),
                    ),
                  );
                },
                child: const Text('Alumnos'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
