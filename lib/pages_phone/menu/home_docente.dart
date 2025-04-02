import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uniditos/pages_phone/alumnos/alumnos_page.dart';
import 'package:uniditos/pages_phone/comedor/home_comedor.dart';
import 'package:uniditos/pages_phone/movimientos/egreso_page.dart';
import 'package:uniditos/pages_phone/movimientos/ingreso_page.dart';
import 'package:uniditos/pages_phone/menu/drawer_docente.dart';

import 'package:uniditos/pages_phone/reportes/reporte_menu.dart';
import 'package:uniditos/pages_phone/reportes/reporte_horas_mensual.dart';

import 'package:uniditos/services/alumnos_service.dart';
import 'package:uniditos/services/comedor_service.dart';
import 'package:uniditos/services/settings.dart';

class HomeDocente extends StatefulWidget {
  const HomeDocente({super.key});

  @override
  State<HomeDocente> createState() => _HomeDocenteState();
}

class _HomeDocenteState extends State<HomeDocente> {
  int cantidadAlumnos = 0;
  bool loadingCantAlumnos = true;

  Timer? timer;
  DateTime timeData = DateTime.now();

  int cantidadComedor = 0;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _boxDecoration = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 110, 173, 224),
        Color.fromARGB(255, 155, 197, 216),
      ],
    ),
    borderRadius: BorderRadius.circular(10),
  );

  Container _opcionMenu(String titulo, IconData icono, Function onTap) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 80,
      decoration: _boxDecoration,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                onTap();
              },
              child: Row(
                children: [
                  Icon(icono, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void getCantidadAlumnos() async {
    await AlumnosServices.getAlumnosInside().then((value) {
      setState(() {
        cantidadAlumnos = value.length;
        timeData = DateTime.now();
        loadingCantAlumnos = false;
      });
    });
  }

  void getComedor() async {
    try {
      var comedor = await ComedorService.getComedor();
      if (DateTime.now().hour >= 14) {
        comedor.removeWhere(
          (element) => element.fecha.isBefore(DateTime.now()),
        );
      }
      setState(() {
        cantidadComedor = comedor.length;
      });
    } catch (e) {
      print(e);
    }
  }

  void loopGetData() {
    timer = Timer.periodic(const Duration(seconds: 30), (Timer t) {
      getCantidadAlumnos();
      getComedor();
    });
  }

  @override
  void initState() {
    getCantidadAlumnos();
    getComedor();
    loopGetData();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const MenuDocente(),
      body: Stack(
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue, Color.fromARGB(255, 155, 197, 216)],
              ),
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, top: 20),
                      child: Text(
                        'Hola,',
                        style: TextStyle(color: Colors.white70, fontSize: 32),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Seño ${userApp?.alias} !',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 150),
              Expanded(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black38),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      maxRadius: 35,
                                      child: Text(
                                        cantidadAlumnos.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Alumnos en el Jardin',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black38,
                                          ),
                                        ),
                                        Text(
                                          'Actualizado: ${timeData.hour}:${timeData.minute.toString().padLeft(2, '0')}:${timeData.second.toString().padLeft(2, '0')} Hs',
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      maxRadius: 35,
                                      child: Text(
                                        cantidadComedor.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      children: [
                                        Text(
                                          DateTime.now().hour > 14
                                              ? 'Comedor para Mañana'
                                              : 'Comedor para Hoy',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 130,
                          decoration: _boxDecoration,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap:
                                      () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const IngresoPage(),
                                        ),
                                      ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.person_add_alt_1,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Ingreso de Alumnos',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Divider(color: Colors.white),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap:
                                      () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const EgresoPage(),
                                        ),
                                      ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.person_remove_alt_1,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Egreso de Alumnos',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _opcionMenu(
                          "Alumnos",
                          Icons.person,
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AlumnosPage(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _opcionMenu(
                          "Comedor",
                          Icons.room_service,
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const HomeComedor(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _opcionMenu(
                          "Reportes",
                          Icons.report,
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ReporteMenu(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _opcionMenu("PDF", Icons.picture_as_pdf, () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ReportePage(),
                            ),
                          );
                        }),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
