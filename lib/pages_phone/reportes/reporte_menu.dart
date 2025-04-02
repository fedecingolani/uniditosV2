import 'package:flutter/material.dart';
import 'package:uniditos/entities/alumnos.dart';
import 'package:uniditos/entities/salas.dart';
import 'package:uniditos/entities/vista_sala_alumno.dart';
import 'package:uniditos/helper/minutos_hora.dart';
import 'package:uniditos/services/alumnos_service.dart';
import 'package:uniditos/services/movimientos_service.dart';
import 'package:uniditos/services/salas_service.dart';

class ReporteMenu extends StatefulWidget {
  const ReporteMenu({super.key});

  @override
  State<ReporteMenu> createState() => _ReporteMenuState();
}

class _ReporteMenuState extends State<ReporteMenu> {
  List<VistaSalaAlumnos> alumnos = [];
  List<Salas> salas = [];

  Salas? selectedSala;
  Alumnos? selectedAlumno;
  DateTime? selectedTime;
  bool loadingAlumnos = false;

  Future<void> getAlumnos() async {
    setState(() {
      loadingAlumnos = true;
    });
    AlumnosServices.getAlumnosBySalaId(selectedSala!.salaId).then((value) {
      setState(() {
        loadingAlumnos = false;
        alumnos = value;
      });
    });
  }

  Future<Map<String, dynamic>> getMovimientos(int alumnoId) async {
    try {
      Map<String, dynamic> movimientos = {
        'lsitado': [],
        'horas': 0,
        'color': Colors.green,
      };
      await MovimientosService.getMovimientosByAlumno(alumnoId).then((value) {
        Duration? duracion;
        if (value.isEmpty) {
          return Future.error('Sin Ingresos');
        }
        for (var i = 0; i < value.length; i++) {
          if (value[i].fechaEgreso == null) {
            value[i].fechaEgreso = DateTime.now();
            movimientos['color'] = Colors.red;
          }
          var min = value[i].fechaEgreso!.difference(value[i].fechaIngreso);
          if (duracion == null) {
            duracion = min;
          } else {
            duracion = duracion + min;
          }
        }
        movimientos['listado'] = value;
        movimientos['horas'] = duracion!.inMinutes;
      });
      return movimientos;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  void initState() {
    setState(() {
      loadingAlumnos = true;
    });
    SalasServices.getSalas().then((value) {
      salas = value;
      selectedSala = value[0];
      loadingAlumnos = true;
      AlumnosServices.getAlumnosBySalaId(selectedSala!.salaId).then((value) {
        setState(() {
          loadingAlumnos = false;
          alumnos = value;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reporte de Alumnos')),
      body: Column(
        children: [
          const SizedBox(width: 10),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: salas.length,
              itemBuilder: (BuildContext context, int index) {
                Salas sala = salas[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSala = sala;

                      getAlumnos();
                    });
                  },
                  child: Container(
                    width: 175,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selectedSala == sala ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${sala.nombreSala} - ${sala.alias ?? ''}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              selectedSala == sala
                                  ? Colors.white
                                  : Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child:
                loadingAlumnos
                    ? const Center(child: CircularProgressIndicator())
                    : alumnos.isEmpty
                    ? const Center(child: Text('Sin Alumnos'))
                    : ListView.builder(
                      itemCount: alumnos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 100,
                          child: Card(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    child: Text(alumnos[index].nombre[0]),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${alumnos[index].apellido}, ${alumnos[index].nombre}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                FutureBuilder(
                                  future: getMovimientos(
                                    alumnos[index].alumnoId,
                                  ),
                                  builder: (
                                    BuildContext context,
                                    AsyncSnapshot snapshot,
                                  ) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (snapshot.hasError) {
                                      return Text(snapshot.error.toString());
                                    }
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          convertirMinutosAHorasMinutos(
                                            snapshot.data['horas'],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Movimientos',
                                                  ),
                                                  content: SizedBox(
                                                    width: 300,
                                                    child: ListView.builder(
                                                      itemCount:
                                                          snapshot
                                                              .data['listado']
                                                              .length,
                                                      itemBuilder: (
                                                        BuildContext context,
                                                        int index,
                                                      ) {
                                                        return ListTile(
                                                          title: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Ingreso: ${snapshot.data['listado'][index].fechaIngreso.toString().substring(0, 16)}',
                                                              ),
                                                              Text(
                                                                'Egreso: ${snapshot.data['listado'][index].fechaEgreso.toString().substring(0, 16)}',
                                                              ),
                                                            ],
                                                          ),
                                                          subtitle: Text(
                                                            'Duracion: ${snapshot.data['listado'][index].fechaEgreso.difference(snapshot.data['listado'][index].fechaIngreso).inHours} Horas',
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(
                                            Icons.timelapse_sharp,
                                            color: snapshot.data['color'],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
