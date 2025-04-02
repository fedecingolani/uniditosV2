import 'package:flutter/material.dart';
import 'package:uniditos/helper/minutos_hora.dart';
import 'package:uniditos/models/comedor_reset.dart';
import 'package:uniditos/models/response_comedor.dart';
import 'package:uniditos/pages_phone/alumnos/alumnos_home.dart';
import 'package:uniditos/pages_phone/alumnos/alumnos_page.dart';
import 'package:uniditos/pages_phone/comedor/dialog_add_alumno.dart';
import 'package:uniditos/services/alumnos_service.dart';
import 'package:uniditos/services/comedor_service.dart';

class HomeComedor extends StatefulWidget {
  const HomeComedor({super.key});

  @override
  State<HomeComedor> createState() => _HomeComedorState();
}

class _HomeComedorState extends State<HomeComedor> {
  List<ResponseComedor> comedor = [];

  bool loading = true;

  late DateTime fechaComedor;

  Future<void> getComedor() async {
    setState(() {
      loading = true;
    });
    comedor = await ComedorService.getComedor();
    if (DateTime.now().hour >= 14) {
      comedor.removeWhere((element) => element.fecha.isBefore(DateTime.now()));
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // si la fecha es mayor a las 14hs, sumar un dia
    fechaComedor = DateTime.now();
    if (fechaComedor.hour >= 14) {
      fechaComedor = fechaComedor.add(const Duration(days: 1));
    }
    getComedor();
    super.initState();
  }

  Future<void> actualizarComedor(bool value, DateTime? fecha, int alumnoId) =>
      AlumnosServices.postComedor(
        alumnoId,
        ComedorReset(comedor: value, fechaVencimiento: fecha),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Column(
          children: [
            SizedBox(height: 20),
            Text('Comedor: ${formatOnlyDate.format(fechaComedor)}'),
            Text('Cantidad ${comedor.length}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => const DialogAddComedor(),
          ).then((value) {
            getComedor();
          });
        },
        child: const Icon(Icons.add),
      ),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: comedor.length,
                itemBuilder: (context, index) {
                  final item = comedor[index];
                  return Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(child: Text(item.nombre[0])),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.nombre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                item.apellido,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // si item.fecha != a la fecha de hoy mostrar una leyenda
                              if (item.fecha.isAfter(DateTime.now()))
                                Text(
                                  'POSTERIOR A LA FECHA: ${formatOnlyDate.format(item.fecha)}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // deleete button
                        // IconButton(
                        //   onPressed: () async {
                        //     await ComedorService.deleteMovimientoComedor(item.movimientoId).then(
                        //       (value) {
                        //         ScaffoldMessenger.of(context).showSnackBar(
                        //           const SnackBar(
                        //             content: Text('Movimiento eliminado'),
                        //           ),
                        //         );
                        //       },
                        //     ).whenComplete(() {
                        //       actualizarComedor(false, null, item.alumnoId).then((value) {
                        //         getComedor();
                        //       });
                        //     });
                        //   },
                        //   icon: const Icon(Icons.delete),
                        // ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => AlumnosHome(
                                          id: item.alumnoId,
                                          indexPage: 2,
                                        ),
                                  ),
                                )
                                .then((value) {
                                  getComedor();
                                });
                          },
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
