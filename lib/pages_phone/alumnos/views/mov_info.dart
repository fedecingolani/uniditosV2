import 'package:flutter/material.dart';
import 'package:uniditos/entities/movimientos.dart';
import 'package:uniditos/helper/meses.dart';
import 'package:uniditos/pages_phone/reportes/generar_pdf/reporte_horas_alumno.dart';
import 'package:uniditos/services/movimientos_service.dart';
import 'package:uniditos/widget/crear_movimiento.dart';
import 'package:uniditos/widget/modif_movimiento.dart';

class MovimientoInfo extends StatefulWidget {
  final int id;
  const MovimientoInfo({Key? key, required this.id}) : super(key: key);

  @override
  State<MovimientoInfo> createState() => _MovimientoInfoState();
}

class _MovimientoInfoState extends State<MovimientoInfo> {
  Map<String, int> mesSelected = {};
  List<Movimientos> movimientos = [];
  Duration? duracion;

  bool loadingMovimiento = false;

  Future<void> getMovimientos(int mesSelect) async {
    setState(() {
      loadingMovimiento = true;
    });
    await MovimientosService.getMovimientosByAlumno(
      widget.id,
      mes: mesSelect,
    ).then((value) {
      movimientos = value;
      movimientos.sort((a, b) => a.fechaIngreso.compareTo(b.fechaIngreso));
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
    setState(() {
      loadingMovimiento = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    mesSelected = meses[DateTime.now().month - 1];
    getMovimientos(mesSelected.values.first);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Seleccionar Mes:'),
              const SizedBox(width: 15),
              // Seleccionar Mes
              Expanded(
                child: DropdownButton<Map<String, int>>(
                  isExpanded: true,
                  value: mesSelected,
                  onChanged: (Map<String, int>? value) {
                    setState(() {
                      mesSelected = value!;
                      getMovimientos(mesSelected.values.first).then((value) {
                        setState(() {});
                      });
                    });
                  },
                  items:
                      meses.map((Map<String, int> mes) {
                        return DropdownMenuItem<Map<String, int>>(
                          value: mes,
                          child: Text(mes.keys.first),
                        );
                      }).toList(),
                ),
              ),
              // Boton Agregar Movimiento
              IconButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CrearMovimiento(alumnosId: widget.id);
                    },
                  ).then((value) {
                    getMovimientos(mesSelected.values.first);
                  });
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 20),
          loadingMovimiento
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                child: Column(
                  children: [
                    if (duracion != null)
                      Text(
                        'Duración total: ${duracion!.inHours} horas y ${duracion!.inMinutes.remainder(60)} minutos',
                        style: const TextStyle(fontSize: 18),
                      ),
                    //Boton para exportar a PDF
                    ElevatedButton(
                      onPressed: () {
                        generateAlumnoMovimiento(
                          movimientos,
                          duracion,
                          mesSelected.keys.first,
                          widget.id,
                        );
                      },
                      child: const Text('Exportar a PDF'),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          dividerThickness: 2,
                          columnSpacing: 20,
                          columns: const [
                            DataColumn(label: Text('Día')),
                            DataColumn(label: Text('Ingreso')),
                            DataColumn(label: Text('Egreso')),
                            DataColumn(label: Text('Duración')),
                            DataColumn(label: Text('')),
                          ],
                          rows:
                              movimientos.map((e) {
                                return DataRow(
                                  onLongPress: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ModificarMovimiento(
                                          movimiento: e,
                                        );
                                      },
                                    );
                                    await getMovimientos(
                                      mesSelected.values.first,
                                    );
                                    setState(() {});
                                  },
                                  cells: [
                                    DataCell(
                                      Text(
                                        e.fechaIngreso.toString().substring(
                                          8,
                                          10,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 40,
                                        child: Text(
                                          e.fechaIngreso.toString().substring(
                                            11,
                                            16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      e.fechaEgreso != null
                                          ? Text(
                                            e.fechaEgreso!.toString().substring(
                                              11,
                                              16,
                                            ),
                                          )
                                          : const Text(''),
                                    ),
                                    DataCell(
                                      e.fechaEgreso != null
                                          ? Text(
                                            '${e.fechaEgreso!.difference(e.fechaIngreso).inHours}:${e.fechaEgreso!.difference(e.fechaIngreso).inMinutes.remainder(60)} Hs',
                                          )
                                          : const Text(''),
                                    ),
                                    DataCell(
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  'Eliminar Movimiento',
                                                ),
                                                content: const Text(
                                                  '¿Está seguro que desea eliminar el movimiento?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    },
                                                    child: const Text(
                                                      'Cancelar',
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      MovimientosService.deleteMovimiento(
                                                            e.movimientoId,
                                                          )
                                                          .then((value) {
                                                            getMovimientos(
                                                              mesSelected
                                                                  .values
                                                                  .first,
                                                            );
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                  'Movimiento eliminado',
                                                                ),
                                                              ),
                                                            );
                                                            setState(() {
                                                              Navigator.of(
                                                                context,
                                                              ).pop();
                                                            });
                                                          })
                                                          .catchError((e) {
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  e.toString(),
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    child: const Text(
                                                      'Eliminar',
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
