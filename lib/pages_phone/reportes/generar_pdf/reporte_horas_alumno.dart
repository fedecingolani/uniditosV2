// Reporte de horas de un alumno

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:uniditos/entities/movimientos.dart';
import 'package:uniditos/helper/minutos_hora.dart';
import 'package:uniditos/services/alumnos_service.dart';
import 'package:uniditos/services/reporte_service.dart';

Future<void> generateAlumnoMovimiento(
  List<Movimientos> data,
  Duration? duracion,
  String mes,
  int alumnoId,
) async {
  var datos = data;
  print(datos.length);

  var alumno = await AlumnosServices.getAlumnosId(alumnoId);

  final pdf = pw.Document(pageMode: PdfPageMode.fullscreen);
  final profileImage = pw.MemoryImage(
    (await rootBundle.load('assets/uniLogo.jpg')).buffer.asUint8List(),
  );

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a3,
      build:
          (pw.Context context) => <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Row(
                    children: [
                      pw.Column(
                        children: [
                          pw.Text(
                            'Horas de $mes',
                            style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            '${alumno.nombre} ${alumno.apellido}',
                            style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      pw.Spacer(),
                      pw.Container(
                        width: 100,
                        height: 100,
                        child: pw.Image(profileImage),
                      ),
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Text(
                        'Duración total: ${duracion!.inHours} horas y ${duracion!.inMinutes.remainder(60)} minutos',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.ListView.builder(
              itemCount: 1,
              itemBuilder: (pw.Context context, int index) {
                return pw.Column(
                  children: [
                    // pw.Text(
                    //   datos[index].nombreSala,
                    //   style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    // ),
                    pw.TableHelper.fromTextArray(
                      context: context,
                      headers: <String>[
                        'Fecha',
                        'Hora Ingreso',
                        'Hora Egreso',
                        'Duración',
                      ],
                      data:
                          datos
                              .map(
                                (e) => [
                                  (formatOnlyDate.format(e.fechaIngreso)),
                                  (formatOnlyHS.format(e.fechaIngreso)),
                                  (formatOnlyHS.format(e.fechaEgreso!)),
                                  (convertirMinutosAHorasMinutos(
                                    e.fechaEgreso!
                                        .difference(e.fechaIngreso)
                                        .inMinutes,
                                  )),
                                ],
                              )
                              .toList(),

                      // datos
                      //     .map((e) => [
                      //           '${e.fechaIngreso.day}/${e.fechaIngreso.month}/${e.fechaIngreso.year}',
                      //           '${e.fechaIngreso.hour}:${e.fechaIngreso.minute}',
                      //           '${e.fechaEgreso!.hour}:${e.fechaEgreso!.minute}',
                      //           (convertirMinutosAHorasMinutos(e.fechaEgreso!.difference(e.fechaIngreso).inMinutes)),
                      //         ])
                      //     .toList(),
                    ),

                    // pw.TableHelper.fromTextArray(context: context, data: <List<String>>[
                  ],
                );
              },
            ),
          ],
    ),
  );

  final directory = await getApplicationSupportDirectory();
  final path = directory.path;
  final reportesDir = Directory('$path/reportes/$mes');
  if (!(await reportesDir.exists())) {
    await reportesDir.create(recursive: true);
  }

  String fecha1 = '${DateTime.now().second}';

  File file = File(
    '$path/reportes/$mes/${alumno.apellido}-${alumno.nombre}-$fecha1.pdf',
  );

  if (Platform.isAndroid) {
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(
      '$path/reportes/$mes/${alumno.apellido}-${alumno.nombre}-$fecha1.pdf',
    ).then((value) {
      Future.delayed(const Duration(seconds: 2), () {
        file.delete();
      });
    });
  } else {
    print(file.path);
    await file.writeAsBytes(await pdf.save());
    //open PDF file
    OpenFile.open(
      '$path/reportes/$mes/${alumno.apellido}-${alumno.nombre}-$fecha1.pdf',
    );
  }
}
