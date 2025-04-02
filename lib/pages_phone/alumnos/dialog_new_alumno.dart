import 'package:flutter/material.dart';

import 'package:uniditos/entities/alumnos.dart';
import 'package:uniditos/entities/salas.dart';
import 'package:uniditos/helper/minutos_hora.dart';
import 'package:uniditos/services/alumnos_service.dart';
import 'package:uniditos/services/salas_service.dart';

class DialogoNuevoAlumno extends StatefulWidget {
  const DialogoNuevoAlumno({super.key});

  @override
  State<DialogoNuevoAlumno> createState() => _DialogoNuevoAlumnoState();
}

class _DialogoNuevoAlumnoState extends State<DialogoNuevoAlumno> {
  TextEditingController nombre = TextEditingController();
  TextEditingController apellido = TextEditingController();
  DateTime fechaNacimiento = DateTime.now();
  TextEditingController dni = TextEditingController();
  DateTime fechaIngreso = DateTime.now();
  Salas? _salaSelected;
  List<Salas> salas = [];

  bool loadingGuardar = false;

  getSalas() {
    SalasServices.getSalas().then(
      (value) => setState(() {
        salas = value.where((element) => element.activa).toList();
      }),
    );
  }

  Future<void> guardar() async {
    setState(() {
      loadingGuardar = true;
    });
    AlumnosServices.postAlumnos(
      Alumnos(
        alumnoId: 0,
        //first Letter to UpperCase
        nombre: '${nombre.text[0].toUpperCase()}${nombre.text.substring(1)}',
        apellido:
            '${apellido.text[0].toUpperCase()}${apellido.text.substring(1)}',
        fechaNacimiento: fechaNacimiento,
        comedor: false,
        activo: true,
      ),
      _salaSelected!.salaId,
    ).then((value) {
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    setState(() {
      getSalas();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(10.0),
      title: const Text('Nuevo Alumno'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: nombre,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: apellido,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            const SizedBox(height: 15),
            //Fecha de nacimiento
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Nacimiento: ${formatOnlyDate.format(fechaNacimiento)}',
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          fechaNacimiento = value;
                        });
                      }
                    });
                  },
                  icon: const Icon(Icons.calendar_today),
                ),
              ],
            ),

            const SizedBox(height: 15),
            const Text('Seleccionar sala:'),
            DropdownButton<Salas>(
              value: _salaSelected,
              onChanged: (Salas? newValue) {
                setState(() {
                  _salaSelected = newValue;
                });
              },
              items:
                  salas.map<DropdownMenuItem<Salas>>((Salas value) {
                    return DropdownMenuItem<Salas>(
                      value: value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(value.nombreSala),
                          Text(
                            value.alias!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            guardar();
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
