import 'package:flutter/material.dart';

import 'package:uniditos/entities/alumnos.dart';
import 'package:uniditos/entities/movimientos.dart';
import 'package:uniditos/entities/salas.dart';
import 'package:uniditos/entities/vista_movimientos.dart';
import 'package:uniditos/entities/vista_sala_alumno.dart';
import 'package:uniditos/services/alumnos_service.dart';
import 'package:uniditos/services/movimientos_service.dart';
import 'package:uniditos/services/salas_service.dart';

class IngresoPage extends StatefulWidget {
  const IngresoPage({super.key});

  @override
  State<IngresoPage> createState() => _IngresoPageState();
}

class _IngresoPageState extends State<IngresoPage> {
  List<VistaSalaAlumnos> alumnos = [];
  List<VistaMovimiento> alumnosInside = [];
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
      AlumnosServices.getAlumnosInsideBySala(selectedSala!.salaId).then((
        value1,
      ) {
        alumnosInside = value1;

        setState(() {
          loadingAlumnos = false;

          alumnos = value;
          alumnos.removeWhere(
            (alumno) => alumnosInside.any(
              (alumnInside) => alumno.alumnoId == alumnInside.alumnoId,
            ),
          );
        });
      });
    });
  }

  @override
  void initState() {
    setState(() {
      loadingAlumnos = true;
    });
    SalasServices.getSalas().then((value) {
      // hacer un filtro por el campo activo de la clase salas
      salas = value.where((element) => element.activa).toList();

      // salas = value;
      selectedSala = salas[0];
      loadingAlumnos = true;
      AlumnosServices.getAlumnosBySalaId(selectedSala!.salaId).then((value) {
        AlumnosServices.getAlumnosInsideBySala(selectedSala!.salaId).then((
          value1,
        ) {
          alumnosInside = value1;

          setState(() {
            loadingAlumnos = false;

            alumnos = value;
            alumnos.removeWhere(
              (alumno) => alumnosInside.any(
                (alumnInside) => alumno.alumnoId == alumnInside.alumnoId,
              ),
            );
          });
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingreso de Alumnos')),
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
                                      Text(alumnos[index].nombre),
                                      const SizedBox(width: 10),
                                      Text(alumnos[index].apellido),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  child: const Text('Ingresar'),
                                  onPressed: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((selectedTime) {
                                      if (selectedTime != null) {
                                        this.selectedTime = DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day,
                                          selectedTime.hour,
                                          selectedTime.minute,
                                        );
                                        Movimientos mov = Movimientos(
                                          movimientoId: 0,
                                          fechaIngreso: this.selectedTime!,
                                          fechaEgreso: null,
                                          alumnoId: alumnos[index].alumnoId,
                                        );
                                        MovimientosService.postMovimientos(mov)
                                            .then((value) {
                                              AlumnosServices.getAlumnosBySalaId(
                                                selectedSala!.salaId,
                                              ).then((value) {
                                                setState(() {
                                                  alumnos = value;
                                                });
                                              });
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Ingreso registrado',
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
                                            });
                                      }
                                    });
                                  },
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
    );
  }
}
