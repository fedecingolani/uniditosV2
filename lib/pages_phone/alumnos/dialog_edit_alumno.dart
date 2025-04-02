import 'package:flutter/material.dart';

import 'package:uniditos/entities/alumno_detail.dart';
import 'package:uniditos/entities/alumnos.dart';

import 'package:uniditos/services/alumnos_service.dart';

class DialogEditAlumno extends StatefulWidget {
  final AlumnoDetail alumno;
  const DialogEditAlumno({required this.alumno, super.key});

  @override
  State<DialogEditAlumno> createState() => _DialogEditAlumnoState();
}

class _DialogEditAlumnoState extends State<DialogEditAlumno> {
  TextEditingController nombre = TextEditingController();
  TextEditingController apellido = TextEditingController();
  TextEditingController dni = TextEditingController();
  late DateTime? fechaNacimiento;

  bool comedor = false;
  // late DateTime? fechaIngreso;
  // late DateTime? fechaEgreso;

  // Salas? _salaSelected;
  // List<Salas> salas = [];

  bool loadingGuardar = false;

  // Future<void> getSalas() async {
  //   SalasServices.getSalas().then((value) => setState(() {
  //         salas = value;
  //         //_salaSelected = salas.firstWhere((element) => element.salaId == widget.alumno.salaId);
  //         setState(() {});
  //       }));
  // }

  @override
  void initState() {
    nombre.text = widget.alumno.nombre;
    apellido.text = widget.alumno.apellido;
    dni.text = widget.alumno.dni.toString();
    fechaNacimiento = widget.alumno.fechaNacimiento;
    comedor = widget.alumno.comedor;
    // fechaIngreso = widget.alumno.fechaIngreso;
    // fechaEgreso = widget.alumno.fechaEgreso;

    setState(() {
      // getSalas();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Alumno'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombre,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Nombre',
              ),
            ),
            TextField(
              controller: apellido,
              decoration: const InputDecoration(
                labelText: 'Apellido',
                hintText: 'Apellido',
              ),
            ),
            TextField(
              controller: dni,
              decoration: const InputDecoration(
                hintText: 'DNI',
                labelText: 'DNI',
              ),
            ),
            const SizedBox(height: 15),
            const Text('Fecha de Nacimiento:'),
            Row(
              children: [
                Text(
                  fechaNacimiento != null
                      ? fechaNacimiento.toString().substring(0, 10)
                      : 'Seleccionar',
                ),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() {
                        fechaNacimiento = date;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                ),
              ],
            ),
            // TextField(
            //   controller: TextEditingController(text: fechaNacimiento != null ? fechaNacimiento.toString().substring(0, 10) : ''),
            //   decoration: InputDecoration(
            //     enabled: true,
            //     hintText: 'Fecha de Nacimiento',
            //     helperText: 'Fecha de Nacimiento',
            //     suffixIcon: IconButton(
            //       onPressed: () async {
            //         DateTime? date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
            //         if (date != null) {
            //           setState(() {
            //             fechaNacimiento = date;
            //           });
            //         }
            //       },
            //       icon: const Icon(Icons.calendar_today),
            //     ),
            //   ),
            // ),
            // const Divider(),
            // TextField(
            //   controller: TextEditingController(text: fechaIngreso != null ? fechaIngreso.toString().substring(0, 10) : DateTime.now().toString().substring(0, 10)),
            //   decoration: InputDecoration(
            //     hintText: 'Fecha de Ingreso',
            //     helperText: 'Fecha de Ingreso',
            //     suffixIcon: IconButton(
            //       onPressed: () async {
            //         DateTime? date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
            //         if (date != null) {
            //           setState(() {
            //             fechaIngreso = date;
            //           });
            //         }
            //       },
            //       icon: const Icon(Icons.calendar_today),
            //     ),
            //   ),
            // ),
            // const Divider(),
            // TextField(
            //   controller: TextEditingController(text: fechaEgreso != null ? fechaEgreso.toString().substring(0, 10) : DateTime.now().toString().substring(0, 10)),
            //   decoration: InputDecoration(
            //     hintText: 'Fecha de Egreso',
            //     helperText: 'Fecha de Egreso',
            //     suffixIcon: IconButton(
            //       onPressed: () async {
            //         DateTime? date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
            //         if (date != null) {
            //           setState(() {
            //             fechaEgreso = date;
            //           });
            //         }
            //       },
            //       icon: const Icon(Icons.calendar_today),
            //     ),
            //   ),
            // ),

            // const Text('Sala: '),
            // DropdownButton<Salas>(
            //   value: _salaSelected,
            //   onChanged: (Salas? newValue) {
            //     setState(() {
            //       _salaSelected = newValue;
            //     });
            //   },
            //   items: salas.map<DropdownMenuItem<Salas>>((Salas value) {
            //     return DropdownMenuItem<Salas>(
            //       value: value,
            //       child: Text(value.nombreSala),
            //     );
            //   }).toList(),
            // ),
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
        ElevatedButton(
          onPressed: () async {
            if (nombre.text.isEmpty ||
                apellido.text.isEmpty ||
                dni.text.isEmpty) {
              return;
            }

            AlumnosServices.putAlumnos(
              Alumnos(
                alumnoId: widget.alumno.alumnoId,
                nombre: nombre.text,
                apellido: apellido.text,
                fechaNacimiento: fechaNacimiento,
                comedor: widget.alumno.comedor,
                dni: dni.text,
                activo: true,
              ),
            ).then((value) {
              // if (widget.alumno.salaId != _salaSelected!.salaId) {
              //   AlumnosServices.putAlumnosSala(widget.alumno.alumnoId, _salaSelected!.salaId).then((value) {
              //     Navigator.of(context).pop();
              //   });
              // }
              Navigator.of(context).pop();
            });
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
