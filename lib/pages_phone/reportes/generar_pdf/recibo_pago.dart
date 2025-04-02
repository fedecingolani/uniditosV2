// Reporte de horas de un alumno

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:uniditos/services/alumnos_service.dart';
import 'package:uniditos/services/settings.dart';

Future<void> generateReciboPago(
  int importe,
  String recibo,
  String concepto,
  int alumnoId,
) async {
  var alumno = await AlumnosServices.getAlumnosId(alumnoId);

  var usuario = ('${userApp?.nombre} ${userApp?.apellido}');

  final pdf = pw.Document(pageMode: PdfPageMode.none);
  final profileImage = pw.MemoryImage(
    (await rootBundle.load('assets/uniLogo.jpg')).buffer.asUint8List(),
  );
  final unionImage = pw.MemoryImage(
    (await rootBundle.load('assets/union.jpg')).buffer.asUint8List(),
  );

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build:
          (pw.Context context) => <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Row(
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Fecha: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                            style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            'Número: $recibo',
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
                  pw.Divider(),
                  pw.Text(
                    'Recibimos de ${alumno.nombre.trim()}, ${alumno.apellido.trim()} la suma de: $importe pesos',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Row(
                    children: [
                      pw.Column(
                        children: [
                          pw.Text(
                            'Por concepto de: $concepto',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.Divider(),
                  pw.SizedBox(height: 30),
                  pw.Container(
                    width: 80,
                    height: 80,
                    child: pw.Image(unionImage),
                  ),
                  pw.Text(
                    usuario,
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
    ),
  );

  final directory = await getApplicationSupportDirectory();
  final path = directory.path;
  final reportesDir = Directory('$path/reportes/ReciboPago');
  if (!(await reportesDir.exists())) {
    await reportesDir.create(recursive: true);
  }

  String fecha1 = '${DateTime.now().second}';

  File file = File(
    '$path/reportes/ReciboPago/${alumno.apellido}-${alumno.nombre}-$fecha1.pdf',
  );

  if (Platform.isAndroid) {
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(
      '$path/reportes/ReciboPago/${alumno.apellido}-${alumno.nombre}-$fecha1.pdf',
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
      '$path/reportes/ReciboPago/${alumno.apellido}-${alumno.nombre}-$fecha1.pdf',
    );
  }
}
