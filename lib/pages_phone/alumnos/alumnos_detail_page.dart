import 'package:flutter/material.dart';

import 'package:uniditos/entities/alumno_detail.dart';
import 'package:uniditos/entities/contacto_alumno.dart';

import 'package:uniditos/entities/movimientos.dart';
import 'package:uniditos/helper/minutos_hora.dart';
import 'package:uniditos/models/comedor_reset.dart';
import 'package:uniditos/models/response_comedor.dart';
import 'package:uniditos/pages_phone/alumnos/dialog_edit_alumno.dart';
import 'package:uniditos/pages_phone/login.dart';

import 'package:uniditos/services/alumnos_service.dart';
import 'package:uniditos/services/comedor_service.dart';
import 'package:uniditos/services/login_service.dart';

import 'package:uniditos/services/movimientos_service.dart';
import 'package:uniditos/services/settings.dart';
import 'package:intl/intl.dart';

class AlumnosDetail extends StatefulWidget {
  final int id;
  const AlumnosDetail({required this.id, super.key});

  @override
  State<AlumnosDetail> createState() => _AlumnosDetailState();
}

class _AlumnosDetailState extends State<AlumnosDetail> {
  DateFormat format = DateFormat('dd-MM-yyyy');
  bool loading = true;
  AlumnoDetail? alumnos;
  List<Movimientos> movimientos = [];
  List<ResponseComedor> comedor = [];
  Duration? duracion;
  int importeComedor = 0;

  Future<void> getAlumno() async {
    setState(() {
      loading = true;
    });
    await AlumnosServices.getAlumnosId(widget.id).then((value) {
      alumnos = value;
      getMovimientos().then((value) async {
        await getComedor();
        setState(() {
          loading = false;
        });
      });
    });
  }

  Future<void> getComedor() async {
    await ComedorService.getComedorByAlumno(id: alumnos!.alumnoId).then((
      value,
    ) {
      comedor = value;
      importeComedor = 0;
      for (var i = 0; i < comedor.length; i++) {
        importeComedor += comedor[i].importe;
      }
    });
  }

  Future<void> getMovimientos() async {
    await MovimientosService.getMovimientosByAlumno(alumnos!.alumnoId).then((
      value,
    ) {
      movimientos = value;
      duracion = null;
      for (var i = 0; i < movimientos.length; i++) {
        if (movimientos[i].fechaEgreso != null) {
          var min = movimientos[i].fechaEgreso!.difference(
            movimientos[i].fechaIngreso,
          );
          if (duracion == null) {
            duracion = min;
          } else {
            duracion = duracion! + min;
          }
        }
      }
    });
  }

  @override
  void initState() {
    getAlumno().then((value) {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  void _editarAlumno() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogEditAlumno(alumno: alumnos!);
      },
    ).then((value) {
      setState(() {
        getAlumno();
      });
    });
  }

  void _mostrarDetalleComedor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registro de comedor'),
          content: SizedBox(
            width: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: comedor.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      'Fecha: ${comedor[index].fecha.toString().substring(0, 10)}',
                    ),
                    subtitle: Text('Importe: \$${comedor[index].importe}'),
                    trailing: Icon(
                      comedor[index].pago ? Icons.check : Icons.close,
                      color: comedor[index].pago ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<Widget> generateList() {
    var lista =
        alumnos!.salas
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Chip(
                  color: WidgetStateProperty.all(
                    const Color.fromARGB(255, 88, 171, 238),
                  ),
                  labelPadding: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),
                  label: Text(e.nombreSala),
                ),
              ),
            )
            .toList();

    if (docente) {
      lista.insert(
        0,
        Padding(
          padding: const EdgeInsets.only(right: 3),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
      );
    }

    return lista;
  }

  Future<void> actualizarComedor(bool value, DateTime? fecha) =>
      AlumnosServices.postComedor(
        alumnos!.alumnoId,
        ComedorReset(comedor: value, fechaVencimiento: fecha),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          alumnos == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        height: docente ? 170 : 120,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: generateList()),
                                const SizedBox(height: 5),
                                Text(
                                  '${alumnos!.nombre.trim()}, ${alumnos!.apellido.trim()}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('DNI: ${alumnos!.dni}'),
                                const SizedBox(height: 5),
                                Text(
                                  'Cumpleaños: ${alumnos!.fechaNacimiento != null ? alumnos!.fechaNacimiento.toString().substring(0, 10) : ''}',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                _editarAlumno();
                              },
                              icon: const Padding(
                                padding: EdgeInsets.only(top: 50, right: 20),
                                child: Icon(Icons.settings, size: 30),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Text('Editar'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        height:
                            alumnos!.contactoAlumnos.isEmpty
                                ? 60
                                : 50 + (alumnos!.contactoAlumnos.length * 80),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            style: BorderStyle.solid,
                            color: Colors.black,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                'Madre/Padre/Responsable:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: alumnos!.contactoAlumnos.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: ListTile(
                                      title: Text(
                                        'Nombre: ${alumnos!.contactoAlumnos[index].nombre}',
                                      ),
                                      subtitle: Text(
                                        'Telefono: ${alumnos!.contactoAlumnos[index].telefono}',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              AlumnosServices.deleteContactoAlumno(
                                                alumnos!
                                                    .contactoAlumnos[index]
                                                    .contactoAlumnoId,
                                              ).then((value) {
                                                getAlumno();
                                              });
                                            },
                                            icon: const Icon(Icons.delete),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            TextEditingController nombre =
                                TextEditingController();
                            TextEditingController telefono =
                                TextEditingController();
                            showDialog(
                              context: context,
                              builder:
                                  (BuildContext context) => AlertDialog(
                                    title: const Text('Agregar Contacto'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: nombre,
                                          decoration: const InputDecoration(
                                            hintText: 'Nombre',
                                          ),
                                        ),
                                        TextField(
                                          controller: telefono,
                                          decoration: const InputDecoration(
                                            hintText: 'Telefono',
                                          ),
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
                                              alumnoId: alumnos!.alumnoId,
                                            ),
                                          ).then((value) {
                                            getAlumno();
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: const Text('Agregar'),
                                      ),
                                    ],
                                  ),
                            );
                          },
                          icon: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Icon(Icons.add),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        style: BorderStyle.solid,
                        color: Colors.black,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Comedor:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Switch(
                              value: alumnos!.comedor,
                              onChanged: (value) {
                                if (value == false) {
                                  alumnos!.fechaVencimientoComedor = null;
                                } else {
                                  alumnos!.fechaVencimientoComedor =
                                      DateTime.now();
                                }

                                actualizarComedor(
                                      value,
                                      alumnos!.fechaVencimientoComedor,
                                    )
                                    .then((value) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Comedor actualizado'),
                                        ),
                                      );
                                    })
                                    .catchError((e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text(e.toString())),
                                      );
                                    })
                                    .whenComplete(() => getAlumno());
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Fecha Vencimiento: '),
                            const Spacer(),
                            alumnos!.comedor
                                ? ElevatedButton(
                                  onPressed: () {
                                    showDatePicker(
                                      context: context,
                                      currentDate: DateTime.now(),
                                      firstDate: DateTime(2024),
                                      lastDate: DateTime(2025),
                                    ).then((value) {
                                      actualizarComedor(alumnos!.comedor, value)
                                          .then((value) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Comedor actualizado',
                                                ),
                                              ),
                                            );
                                          })
                                          .catchError((e) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(e.toString()),
                                              ),
                                            );
                                          })
                                          .whenComplete(() => getAlumno());
                                    });
                                  },
                                  child: Text(
                                    alumnos!.fechaVencimientoComedor
                                            ?.toString()
                                            .substring(0, 10) ??
                                        'No seleccionada',
                                  ),
                                )
                                : Container(),
                          ],
                        ),
                        // boton para ir a la descripcion del comedor
                        const SizedBox(height: 0),
                        Row(
                          children: [
                            Text(
                              'Cantidad de dias en el mes: ${comedor.length}',
                            ),
                          ],
                        ),
                        Row(children: [Text('Saldo: \$$importeComedor')]),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _mostrarDetalleComedor();
                              },
                              child: const Text('Ver Registro comedor'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  docente
                      ? Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              style: BorderStyle.solid,
                              color: Colors.black,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Horaios de Ingreso y Egreso: Duracion: ${convertirMinutosAHorasMinutos(duracion?.inMinutes ?? 0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Expanded(
                                child:
                                    movimientos.isEmpty
                                        ? const Center(
                                          child: Text('No hay movimientos'),
                                        )
                                        : ListView.builder(
                                          itemCount: movimientos.length,
                                          itemBuilder: (
                                            BuildContext context,
                                            int index,
                                          ) {
                                            if (movimientos[index]
                                                    .fechaEgreso ==
                                                null) {
                                              return ListTile(
                                                //trailing: changeTime(context, index),
                                                title: Text(
                                                  'Ingreso: ${movimientos[index].fechaIngreso.toString().substring(0, 16)}',
                                                ),
                                                subtitle: const Text(
                                                  'Egreso: No se ha registrado la salida',
                                                ),
                                              );
                                            } else {
                                              return Card(
                                                child: ListTile(
                                                  //trailing: changeTime(context, index),
                                                  title: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Ingreso: ${movimientos[index].fechaIngreso.toString().substring(0, 16)}',
                                                            ),
                                                            const Divider(),
                                                            Text(
                                                              'Egreso: ${movimientos[index].fechaEgreso.toString().substring(0, 16)}',
                                                            ),
                                                            const Divider(),
                                                            Text(
                                                              'Duracion: ${convertirMinutosAHorasMinutos(movimientos[index].fechaEgreso!.difference(movimientos[index].fechaIngreso).inMinutes)}',
                                                            ),
                                                            const Divider(),
                                                            docente
                                                                ? Center(
                                                                  child:
                                                                      changeTime(
                                                                        context,
                                                                        index,
                                                                      ),
                                                                )
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                      //changeTime(context, index),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            style: BorderStyle.solid,
                            color: Colors.black,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Text(
                                  'Abono:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Total de tiempo: ${convertirMinutosAHorasMinutos(duracion?.inMinutes ?? 0)}',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  docente
                      ? Container()
                      : ElevatedButton(
                        onPressed: () {
                          LoginService.deleteCredentialsFromSharedPreferences()
                              .then((value) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              });
                        },
                        child: Text('Salir'),
                      ),
                ],
              ),
    );
  }

  Row changeTime(BuildContext context, int index) {
    return Row(
      children: [
        TextButton.icon(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.grey[300]),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Editar Movimiento'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ingreso: ${movimientos[index].fechaIngreso.toString().substring(0, 16)}',
                      ),
                      ElevatedButton(
                        onPressed: () {
                          DateTime stime = DateTime.now();
                          showDatePicker(
                            context: context,
                            currentDate: movimientos[index].fechaIngreso,
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2025),
                          ).then((value) {
                            if (value != null) {
                              stime = value;
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                  hour: movimientos[index].fechaIngreso.hour,
                                  minute:
                                      movimientos[index].fechaIngreso.minute,
                                ),
                              ).then((value) {
                                if (value != null) {
                                  stime = DateTime(
                                    stime.year,
                                    stime.month,
                                    stime.day,
                                    value.hour,
                                    value.minute,
                                  );
                                  movimientos[index].fechaIngreso = stime;
                                  Movimientos mov = Movimientos(
                                    movimientoId:
                                        movimientos[index].movimientoId,
                                    fechaIngreso: stime,
                                    fechaEgreso: movimientos[index].fechaEgreso,
                                    alumnoId: movimientos[index].alumnoId,
                                  );
                                  MovimientosService.putMovimiento(mov)
                                      .then((value) {
                                        getMovimientos();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Movimiento editado'),
                                          ),

                                          ///cerrar ventana
                                        );
                                        setState(() {
                                          Navigator.of(context).pop();
                                        });
                                      })
                                      .catchError((e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text(e.toString())),
                                        );
                                      });
                                }
                              });
                            }
                          });
                        },
                        child: const Text('Cambiar Ingreso'),
                      ),
                      const Divider(),
                      Text(
                        'Egreso: ${movimientos[index].fechaEgreso?.toString().substring(0, 16) ?? 'No se ha registrado la salida'}',
                      ),
                      ElevatedButton(
                        onPressed: () {
                          DateTime stime = DateTime.now();
                          showDatePicker(
                            context: context,
                            currentDate: movimientos[index].fechaIngreso,
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2025),
                          ).then((value) {
                            if (value != null) {
                              stime = value;
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                  hour:
                                      movimientos[index].fechaEgreso?.hour ??
                                      DateTime.now().hour,
                                  minute:
                                      movimientos[index].fechaEgreso?.minute ??
                                      DateTime.now().minute,
                                ),
                              ).then((value) {
                                if (value != null) {
                                  stime = DateTime(
                                    stime.year,
                                    stime.month,
                                    stime.day,
                                    value.hour,
                                    value.minute,
                                  );
                                  movimientos[index].fechaEgreso = stime;
                                  Movimientos mov = Movimientos(
                                    movimientoId:
                                        movimientos[index].movimientoId,
                                    fechaIngreso:
                                        movimientos[index].fechaIngreso,
                                    fechaEgreso: stime,
                                    alumnoId: movimientos[index].alumnoId,
                                  );
                                  MovimientosService.putMovimiento(mov)
                                      .then((value) {
                                        getMovimientos();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Movimiento editado'),
                                          ),

                                          ///cerrar ventana
                                        );
                                        setState(() {
                                          Navigator.of(context).pop();
                                        });
                                      })
                                      .catchError((e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text(e.toString())),
                                        );
                                      });
                                }
                              });
                            }
                          });
                        },
                        child: const Text('Cambiar Egreso'),
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
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Guardar'),
                    ),
                  ],
                );
              },
            );
          },
          label: const Text('Editar'),
          icon: const Icon(Icons.edit),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            MovimientosService.deleteMovimiento(movimientos[index].movimientoId)
                .then((value) {
                  getMovimientos().then((value) {
                    setState(() {});
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Movimiento eliminado')),
                  );
                })
                .catchError((e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                });
          },
          color: Colors.red,
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }
}
