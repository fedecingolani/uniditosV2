import 'package:flutter/material.dart';
import 'package:uniditos/entities/contacto_alumno.dart';
import 'package:uniditos/services/alumnos_service.dart';

class CrearContacto extends StatelessWidget {
  final int alumnosId;
  CrearContacto({Key? key, required this.alumnosId}) : super(key: key);

  final TextEditingController nombre = TextEditingController();
  final TextEditingController telefono = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Contacto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nombre,
            decoration: const InputDecoration(hintText: 'Nombre'),
          ),
          TextField(
            controller: telefono,
            decoration: const InputDecoration(hintText: 'Telefono'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            AlumnosServices.postContactoAlumno(
              ContactoAlumno(
                contactoAlumnoId: 0,
                nombre: nombre.text,
                telefono: telefono.text,
                alumnoId: alumnosId,
              ),
            ).then((value) {
              Navigator.of(context).pop();
            });
          },
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}
