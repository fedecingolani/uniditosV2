import 'package:flutter/material.dart';

import 'package:uniditos/entities/alumnos.dart';
import 'package:uniditos/entities/movimientos.dart';
import 'package:uniditos/entities/salas.dart';

import 'package:uniditos/entities/vista_movimientos.dart';

import 'package:uniditos/services/alumnos_service.dart';
import 'package:uniditos/services/movimientos_service.dart';
import 'package:uniditos/services/salas_service.dart';

class EgresoPage extends StatefulWidget {
  const EgresoPage({super.key});

  @override
  State<EgresoPage> createState() => _EgresoPageState();
}

class _EgresoPageState extends State<EgresoPage> {
  List<VistaMovimiento> alumnos = [];

  Alumnos? selectedAlumno;
  DateTime? selectedTime;

  bool loadingAlumnos = true;

  List<Salas> salas = [];

  Salas? selectedSala;

  void getAlumnos() {
    setState(() {
      loadingAlumnos = true;
    });
    AlumnosServices.getAlumnosInsideBySala(selectedSala!.salaId).then((value) {
      loadingAlumnos = false;
      setState(() {
        alumnos = value;
      });
    });
  }

  @override
  void initState() {
    SalasServices.getSalas().then((value) {
      // Salas del año en curso
      salas =
          value.where((element) => element.ano == DateTime.now().year).toList();
      selectedSala = salas[0];
      loadingAlumnos = true;
      AlumnosServices.getAlumnosInsideBySala(selectedSala!.salaId).then((
        value,
      ) {
        setState(() {
          loadingAlumnos = false;
          alumnos = value;
        });
      });
    });
    //getAlumnos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Egreso de Alumnos')),
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
          Expanded(
            child:
                loadingAlumnos
                    ? const Center(child: CircularProgressIndicator())
                    : alumnos.isEmpty
                    ? const Center(child: Text('No hay alumnos ingresados.'))
                    : ListView.builder(
                      itemCount: alumnos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 120,
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
                                        alumnos[index].nombre,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        alumnos[index].apellido,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Ingreso: ${alumnos[index].fechaIngreso.toIso8601String().substring(11, 16)} Hs',
                                      ),
                                      Text(
                                        'Duración: ${DateTime.now().difference(alumnos[index].fechaIngreso).inMinutes} Minutos',
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  child: const Text('Egreso'),
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
                                          movimientoId:
                                              alumnos[index].movimientoId,
                                          fechaIngreso:
                                              alumnos[index].fechaIngreso,
                                          fechaEgreso: this.selectedTime!,
                                          alumnoId: alumnos[index].alumnoId,
                                        );
                                        MovimientosService.putMovimiento(mov)
                                            .then((value) {
                                              getAlumnos();
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
