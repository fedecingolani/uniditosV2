import 'package:flutter/material.dart';
import 'package:uniditos/helper/meses.dart';
import 'package:uniditos/models/response_comedor.dart';
import 'package:uniditos/pages_phone/comedor/dialog_add_alumno.dart';
import 'package:uniditos/pages_phone/reportes/generar_pdf/reporte_comedor_alumno.dart';
import 'package:uniditos/services/comedor_service.dart';

class ComedorInfo extends StatefulWidget {
  final int id;
  const ComedorInfo({Key? key, required this.id}) : super(key: key);

  @override
  State<ComedorInfo> createState() => _ComedorInfoState();
}

class _ComedorInfoState extends State<ComedorInfo> {
  Map<String, int> mesSelected = {};
  List<ResponseComedor> movimientos = [];
  Duration? duracion;

  bool loadingMovimiento = false;

  Future<void> getMovimientos() async {
    setState(() {
      loadingMovimiento = true;
    });
    movimientos = await ComedorService.getComedorByAlumno(
      id: widget.id,
      mes: mesSelected.values.first,
    );
    movimientos.sort((a, b) => a.fecha.compareTo(b.fecha));
    setState(() {
      loadingMovimiento = false;
    });
  }

  @override
  void initState() {
    mesSelected = meses[DateTime.now().month - 1];
    getMovimientos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(width: 15),
            const Text('Mes: '),
            SizedBox(
              width: 120,
              child: DropdownButton<Map<String, int>>(
                isExpanded: true,
                value: mesSelected,
                onChanged: (Map<String, int>? value) {
                  setState(() {
                    mesSelected = value!;
                    getMovimientos();
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
            const Spacer(),
            IconButton(
              onPressed: () {
                generateReporteComedorAlumno(
                  movimientos,
                  mesSelected.keys.first,
                  widget.id,
                );
              },
              icon: const Icon(Icons.picture_as_pdf),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => DialogAddComedor(alumnoId: widget.id),
                );
                getMovimientos();
              },
              icon: const Icon(Icons.add),
            ),
            const SizedBox(width: 15),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child:
              loadingMovimiento
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    itemCount: movimientos.length,
                    itemBuilder: (context, index) {
                      final mov = movimientos[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                            'Fecha: ${mov.fecha.day}/${mov.fecha.month}/${mov.fecha.year}',
                          ),
                          subtitle: Text('Importe: \$${mov.importe}'),
                          trailing: IconButton(
                            onPressed: () async {
                              await ComedorService.deleteMovimientoComedor(
                                    mov.movimientoId,
                                  )
                                  .then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Movimiento eliminado'),
                                      ),
                                    );
                                  })
                                  .whenComplete(() {
                                    setState(() {
                                      getMovimientos();
                                    });
                                  });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
