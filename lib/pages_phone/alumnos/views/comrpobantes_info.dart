import 'dart:async';

import 'package:flutter/material.dart';

import 'package:uniditos/entities/Comprobantes.dart';
import 'package:uniditos/helper/meses.dart';
import 'package:uniditos/helper/minutos_hora.dart';
import 'package:uniditos/pages_phone/comedor/dialog_add_alumno.dart';
import 'package:uniditos/pages_phone/comprobantes/dialog_new_comprobante.dart';
import 'package:uniditos/pages_phone/reportes/generar_pdf/reporte_comprobantes.dart';
import 'package:uniditos/services/comprobantes_service.dart';

class ComprobantesInfo extends StatefulWidget {
  final int id;
  const ComprobantesInfo({Key? key, required this.id}) : super(key: key);

  @override
  State<ComprobantesInfo> createState() => _ComprobantesInfoState();
}

class _ComprobantesInfoState extends State<ComprobantesInfo> {
  List<Comprobantes> _comprobantes = [];

  Map<String, String> tipoComprobante = {};

  //tipo de comprobante seleccionado
  String? _selectedTipoComprobante;

  ///Traer los comprobantes de un alumno
  Future<void> getComprobantes() async {
    var comprobantes = await ComprobantesService.getComprobantesByAlumno(
      widget.id,
    );
    if (_selectedTipoComprobante != 'Todos') {
      comprobantes =
          comprobantes
              .where(
                (element) =>
                    element.letraComprobante == _selectedTipoComprobante,
              )
              .toList();
    }
    setState(() {
      _comprobantes = comprobantes;
    });
  }

  Timer? timer;
  void loopGetData() {
    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      getComprobantes();
    });
  }

  ///Formatear la card de los comprobantes
  Map<String, dynamic> formatComprobantes(Comprobantes comprobante) {
    switch (comprobante.letraComprobante) {
      case "C":
        comprobante.detalle = "Comprobante de Comedor";
        break;
      case "A":
        comprobante.detalle = "Comprobante de Abono";
        break;
      case "P":
        comprobante.detalle = "Comprobante de Pago";
        break;
      default:
        comprobante.detalle = "Comprobante ${comprobante.detalle}";
    }
    return {
      'detalle': comprobante.detalle,
      'fecha': formatOnlyDate.format(comprobante.fecha),
      'importe': comprobante.importe,
      'notas': comprobante.notas,
    };
  }

  @override
  void initState() {
    tipoComprobante = {
      'C': 'Comedor',
      'A': 'Abono',
      'P': 'Pago',
      'Todos': 'Todos',
    };

    _selectedTipoComprobante = 'Todos';
    getComprobantes();
    loopGetData();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(width: 5),
            const Text('Comprobantes: '),
            SizedBox(
              width: 150,
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedTipoComprobante,
                onChanged: (String? value) {
                  setState(() {
                    _selectedTipoComprobante = value;
                    getComprobantes();
                  });
                },
                items:
                    tipoComprobante.entries.map((e) {
                      return DropdownMenuItem<String>(
                        value: e.key,
                        child: Text(e.value),
                      );
                    }).toList(),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                generateReporteComprobantes(_comprobantes, "Todos", widget.id);
              },
              icon: const Icon(Icons.picture_as_pdf),
            ),
            IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder:
                      (context) => DialogNewComprobante(alumnoId: widget.id),
                );
                getComprobantes();
              },
              icon: const Icon(Icons.add),
            ),
            const SizedBox(width: 15),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: _comprobantes.length,
            itemBuilder: (context, index) {
              var comprobante = formatComprobantes(_comprobantes[index]);
              return Card(
                child: ListTile(
                  title: Text(comprobante['detalle']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comprobante['fecha']),
                      Text('Importe: \$${comprobante['importe']}'),
                      Text(comprobante['notas']),
                    ],
                  ),
                  //borrar comprobante
                  trailing: // si es comprobante de pago mostrar el icono
                      _comprobantes[index].letraComprobante == 'P'
                          ? IconButton(
                            onPressed: () async {
                              await ComprobantesService.deleteComprobante(
                                    _comprobantes[index].id,
                                  )
                                  .then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Comprobante eliminado'),
                                      ),
                                    );
                                  })
                                  .catchError((e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Error al eliminar el comprobante',
                                        ),
                                      ),
                                    );
                                  });
                              getComprobantes();
                            },
                            icon: const Icon(Icons.delete),
                          )
                          : const SizedBox(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
