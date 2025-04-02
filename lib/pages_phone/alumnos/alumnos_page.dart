import 'package:flutter/material.dart';
import 'package:uniditos/entities/alumnos.dart';

import 'package:uniditos/pages_phone/alumnos/alumnos_home.dart';
import 'package:uniditos/pages_phone/alumnos/dialog_new_alumno.dart';
import 'package:uniditos/services/alumnos_service.dart';

class AlumnosPage extends StatefulWidget {
  const AlumnosPage({Key? key}) : super(key: key);

  @override
  State<AlumnosPage> createState() => _AlumnosPageState();
}

class _AlumnosPageState extends State<AlumnosPage> {
  final TextEditingController _buscar = TextEditingController();

  List<Alumnos> alumnos = [];
  List<Alumnos> alumnosFiltrados = [];

  TextEditingController nombre = TextEditingController();
  TextEditingController apellido = TextEditingController();
  DateTime fechaNacimiento = DateTime.now();
  TextEditingController dni = TextEditingController();
  DateTime fechaIngreso = DateTime.now();

  getAlumnos() {
    AlumnosServices.getAlumnos().then(
      (value) => setState(() {
        alumnos = value;
        _buscarAlumno();
      }),
    );
  }

  _buscarAlumno() {
    if (_buscar.text.isEmpty) {
      setState(() {
        alumnosFiltrados = alumnos;
      });
    } else {
      setState(() {
        alumnosFiltrados =
            alumnos
                .where(
                  (alumno) =>
                      alumno.nombre.toLowerCase().contains(
                        _buscar.text.toLowerCase(),
                      ) ||
                      alumno.apellido.toLowerCase().contains(
                        _buscar.text.toLowerCase(),
                      ),
                )
                .toList();
      });
    }
  }

  @override
  void initState() {
    getAlumnos();

    super.initState();
  }

  void _agregarAlumno() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DialogoNuevoAlumno();
      },
    ).then((value) async {
      await getAlumnos();
      setState(() {
        _buscarAlumno();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alumnos')),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarAlumno,
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  style: BorderStyle.solid,
                  color: Colors.grey,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Buscar',
                        border: InputBorder.none,
                      ),
                      controller: _buscar,
                      onChanged: (value) {
                        _buscarAlumno();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.search),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: alumnosFiltrados.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 100,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => AlumnosHome(
                                  id: alumnosFiltrados[index].alumnoId,
                                  indexPage: 1,
                                ),
                            //builder: (context) => AlumnosDetail(id: alumnosFiltrados[index].alumnoId),
                          ),
                        );
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                child: Text(alumnosFiltrados[index].nombre[0]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    alumnosFiltrados[index].nombre,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    alumnosFiltrados[index].apellido,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Text(
                                  //   alumnosFiltrados[index].nombreSala,
                                  // ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            alumnosFiltrados[index].activo
                                ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                                : const Icon(Icons.cancel, color: Colors.red),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => AlumnosHome(
                                          id: alumnosFiltrados[index].alumnoId,
                                          indexPage: 1,
                                        ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
