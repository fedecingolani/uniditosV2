import 'package:flutter/material.dart';
import 'package:uniditos/entities/movimientos.dart';
import 'package:uniditos/helper/minutos_hora.dart';
import 'package:uniditos/services/movimientos_service.dart';

class ModificarMovimiento extends StatefulWidget {
  final Movimientos movimiento;
  const ModificarMovimiento({Key? key, required this.movimiento})
    : super(key: key);

  @override
  State<ModificarMovimiento> createState() => _ModificarMovimientoState();
}

class _ModificarMovimientoState extends State<ModificarMovimiento> {
  DateTime ingresoTime = DateTime.now();
  DateTime egresoTime = DateTime.now();

  @override
  void initState() {
    ingresoTime = widget.movimiento.fechaIngreso;
    egresoTime =
        widget.movimiento.fechaEgreso ?? widget.movimiento.fechaIngreso;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Movimiento'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Ingreso: ${formatDate.format(ingresoTime)}'),
          ElevatedButton(
            onPressed: () {
              showDatePicker(
                context: context,
                currentDate: DateTime.now(),
                firstDate: DateTime(2024),
                lastDate: DateTime(2025),
              ).then((value) {
                if (value != null) {
                  ingresoTime = value;
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: DateTime.now().hour,
                      minute: DateTime.now().minute,
                    ),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        ingresoTime = DateTime(
                          ingresoTime.year,
                          ingresoTime.month,
                          ingresoTime.day,
                          value.hour,
                          value.minute,
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
          Text('Egreso: ${formatDate.format(egresoTime)}'),
          ElevatedButton(
            onPressed: () {
              egresoTime = ingresoTime;
              showDatePicker(
                context: context,
                currentDate: egresoTime,
                firstDate: DateTime(2024),
                lastDate: DateTime(2025),
              ).then((value) {
                if (value != null) {
                  egresoTime = value;
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: egresoTime.hour,
                      minute: egresoTime.minute,
                    ),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        egresoTime = DateTime(
                          egresoTime.year,
                          egresoTime.month,
                          egresoTime.day,
                          value.hour,
                          value.minute,
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
            final Movimientos mov = Movimientos(
              movimientoId: widget.movimiento.movimientoId,
              fechaIngreso: ingresoTime,
              fechaEgreso: egresoTime,
              alumnoId: widget.movimiento.alumnoId,
            );

            MovimientosService.putMovimiento(mov)
                .then((value) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //     content: Text('Movimiento creado'),
                  //   ),
                  // );
                })
                .whenComplete(() {});
            Navigator.of(context).pop();
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
