import 'package:flutter/material.dart';

import 'package:uniditos/pages_phone/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //en que plataforma se está ejectuando
    var plataforma = Theme.of(context).platform;
    //iswindows

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uniditos',
      theme: ThemeData(useMaterial3: true),
      home:
          plataforma == TargetPlatform.windows
              ? const LoginPage()
              : const LoginPage(),
    );
  }
}
