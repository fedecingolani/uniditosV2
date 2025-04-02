import 'package:flutter/material.dart';
import 'package:uniditos/entities/alumno_detail.dart';
import 'package:uniditos/entities/alumnos.dart';
import 'package:uniditos/entities/salas.dart';
import 'package:uniditos/services/alumnos_service.dart';
import 'package:uniditos/services/salas_service.dart';
import 'package:uniditos/widget/crear_contacto.dart';

class PersonalInfo extends StatefulWidget {
  final AlumnoDetail alum;
  const PersonalInfo({Key? key, required this.alum}) : super(key: key);

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  late AlumnoDetail alumno;

  List<Salas> salas = [];

  @override
  void initState() {
    alumno = widget.alum;
    super.initState();
  }

  TextStyle style_title = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  Future<AlumnoDetail> getAlumno() async {
    await AlumnosServices.getAlumnosId(alumno.alumnoId).then((value) {
      alumno = value;
    });
    setState(() {});
    return alumno;
  }

  Future<void> getSalas() async {
    salas = await SalasServices.getSalas();
    salas = salas.where((element) => element.activa).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Datos:', style: style_title),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Editar datos'),
                            content: const Text(
                              'Proximamente se va a poder cambiar los datos',
                            ),
                          ),
                    );
                  },
                ),
              ],
            ),
            Text('Nombre: ${alumno.nombre}'),
            Text('Apellido: ${alumno.apellido}'),
            Text('Fecha de nacimiento: ${alumno.fechaNacimiento ?? ''}'),
            Text('DNI: ${alumno.dni ?? ''}'),
            Text('Fecha de ingreso: ${alumno.fechaIngreso ?? ''}'),
            Divider(),
            Row(
              children: [
                Text('Contactos:', style: style_title),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder:
                          (context) =>
                              CrearContacto(alumnosId: alumno.alumnoId),
                    ).then((value) {
                      getAlumno();
                    });
                  },
                ),
              ],
            ),
            for (var contacto in alumno.contactoAlumnos)
              Row(
                children: [
                  Text('${contacto.nombre} - Tel: ${contacto.telefono}'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      AlumnosServices.deleteContactoAlumno(
                        contacto.contactoAlumnoId,
                      ).then((value) {
                        getAlumno();
                      });
                    },
                  ),
                ],
              ),
            Divider(),
            // Armar una card para que se pueda agregar salitas y eliminar salitas de los alumnos
            Card(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Salitas:', style: style_title),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          await getSalas();
                          await showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Agregar Salita'),
                                  content:
                                  // Aramr un menu desplegable con la lista de salas.
                                  // Al seleccionar una sala, se agrega al alumno.
                                  DropdownButton<Salas>(
                                    items:
                                        salas.map((Salas value) {
                                          return DropdownMenuItem<Salas>(
                                            value: value,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                    value: salas.first,
                                    onChanged: (Salas? value) {
                                      if (value != null) {
                                        AlumnosServices.postAlumnosSala(
                                              alumno.alumnoId,
                                              value.salaId,
                                            )
                                            .then((value) {
                                              getAlumno();
                                            })
                                            .whenComplete(
                                              () => Navigator.of(context).pop(),
                                            )
                                            .catchError((e) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(e.toString()),
                                                ),
                                              );
                                            });
                                      }
                                    },
                                  ),
                                ),
                          );
                        },
                      ),
                    ],
                  ),
                  for (var salita in alumno.salas)
                    Row(
                      children: [
                        Text('${salita.alias} - ${salita.nombreSala}'),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            AlumnosServices.deleteAlumnosSala(
                                  alumno.alumnoId,
                                  salita.salaId,
                                )
                                .then((value) {
                                  getAlumno();
                                })
                                .catchError((e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Text('Salitas:', style: style_title),
            // for (var salita in alumno.salas) Text('${salita.alias} - ${salita.nombreSala}'),
            Divider(),
            Text('Abono:', style: style_title),
            Text('Horas: XXXX'),
            Text('Importe: XXXX'),
            Divider(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    widget.alum.activo ? Colors.red : Colors.green,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title:
                            widget.alum.activo
                                ? const Text('Desabilitar Alumno')
                                : const Text('Habilitar Alumno'),
                        content:
                            widget.alum.activo
                                ? const Text(
                                  '¿Está seguro que desea desabilitar el alumno?',
                                )
                                : const Text(
                                  '¿Está seguro que desea habilitar el alumno?',
                                ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                widget.alum.activo ? Colors.red : Colors.green,
                              ),
                            ),
                            onPressed: () {
                              Alumnos alumno = Alumnos(
                                activo: !widget.alum.activo,
                                alumnoId: widget.alum.alumnoId,
                                apellido: widget.alum.apellido,
                                comedor: widget.alum.comedor,
                                fechaNacimiento: widget.alum.fechaNacimiento,
                                nombre: widget.alum.nombre,
                                dni: widget.alum.dni,
                                fechaIngreso: widget.alum.fechaIngreso,
                                fechaEgreso: widget.alum.fechaEgreso,
                                fechaVencimientoComedor:
                                    widget.alum.fechaVencimientoComedor,
                              );
                              AlumnosServices.putAlumnos(alumno)
                                  .then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Alumno Actualizado'),
                                      ),
                                    );
                                    setState(() {
                                      Navigator.of(context).pop();
                                    });
                                  })
                                  .catchError((e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  });
                            },
                            child:
                                widget.alum.activo
                                    ? const Text('Desabilitar Alumno')
                                    : const Text('Habilitar Alumno'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child:
                    widget.alum.activo
                        ? const Text(
                          'Desabilitar Alumno',
                          style: TextStyle(color: Colors.white),
                        )
                        : const Text(
                          'Habilitar Alumno',
                          style: TextStyle(color: Colors.white),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
