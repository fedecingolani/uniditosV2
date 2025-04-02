import 'package:flutter/material.dart';

import 'package:uniditos/entities/docentes.dart';
import 'package:uniditos/services/docentes_service.dart';

class DocentesPage extends StatefulWidget {
  const DocentesPage({super.key});

  @override
  State<DocentesPage> createState() => _DocentesPageState();
}

class _DocentesPageState extends State<DocentesPage> {
  List<Docentes> docentes = [];

  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();

  @override
  void initState() {
    DocentesService.getDocentes().then((value) {
      setState(() {
        docentes = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Agregar Docente'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nombreController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      onChanged: (value) {
                        // Actualizar el nombre del docente
                      },
                    ),
                    TextField(
                      controller: apellidoController,
                      decoration: const InputDecoration(labelText: 'Apellido'),
                      onChanged: (value) {
                        // Actualizar el apellido del docenteP
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      DocentesService.postDocentes(
                        Docentes(
                          docenteId: 0,
                          nombre: nombreController.text,
                          apellido: apellidoController.text,
                          activo: true,
                        ),
                      ).then((value) {
                        DocentesService.getDocentes().then((value) {
                          setState(() {
                            docentes = value;
                          });
                        });
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Guardar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.refresh),
      ),
      appBar: AppBar(title: const Text('Lista de Docentes')),
      body: ListView.builder(
        itemCount: docentes.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 100,
            child: Card(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(child: Text(docentes[index].nombre[0])),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          docentes[index].nombre,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          docentes[index].apellido,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
