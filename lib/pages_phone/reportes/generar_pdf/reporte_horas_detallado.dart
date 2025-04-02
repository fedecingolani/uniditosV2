import 'dart:io';

import 'package:flutter/services.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:uniditos/helper/minutos_hora.dart';
import 'package:uniditos/models/reporte_mes_general.dart';
import 'package:uniditos/services/reporte_service.dart';

Future<void> generatePDFDetallado(String mes, int numero) async {
  var datos = await ReporteSerivce.getReporteMes(numero);

  final pdf = pw.Document(pageMode: PdfPageMode.fullscreen);
  final profileImage = pw.MemoryImage(
    (await rootBundle.load('assets/uniLogo.jpg')).buffer.asUint8List(),
  );

  List<String> columnas() {
    List<String> columnas = [];
    columnas.add('Apellido y Nombre');
    for (var i = 1; i <= 31; i++) {
      columnas.add(i.toString());
    }
    columnas.add('Total');
    return columnas;
  }

  List<String> data(Dato data) {
    List<String> datos = [];
    datos.add('${data.apellido.trim()}, ${data.nombre.trim()}');

    for (var i = 1; i <= 31; i++) {
      var total = 0;
      var mov = data.movimientos.where(
        (element) => element.fechaIngreso.day == i,
      );
      for (var item in mov) {
        if (item.fechaEgreso != null) {
          total += item.fechaEgreso!.difference(item.fechaIngreso).inMinutes;
        }
      }
      datos.add(convertirMinutosAHorasMinutos(total));
    }
    datos.add(convertirMinutosAHorasMinutos(data.totalMinutos.round()));
    return datos;
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a3,
      orientation: pw.PageOrientation.landscape,
      maxPages: 40,
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
                            'Reporte de horas general',
                            style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            'Mes de $mes',
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
                        'Fecha: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.ListView.builder(
              itemCount: datos.length,
              itemBuilder: (pw.Context context, int index) {
                return pw.Column(
                  children: [
                    pw.Text(
                      datos[index].nombreSala,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.TableHelper.fromTextArray(
                      context: context,
                      data: <List<String>>[
                        <String>[...columnas()],
                        ...datos[index].datos.map((e) => data(e)).toList(),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
    ),
  );

  final directory = await getApplicationSupportDirectory();
  final path = directory.path;
  final reportesDir = Directory('$path/reportes');
  if (!(await reportesDir.exists())) {
    await reportesDir.create(recursive: true);
  }
  String fecha1 = '$mes${DateTime.now().second}';
  File file = File('$path/reportes/$fecha1.pdf');

  if (Platform.isAndroid) {
    await file.writeAsBytes(await pdf.save());
    OpenFile.open('$path/reportes/$fecha1.pdf').then((value) {
      Future.delayed(const Duration(seconds: 2), () {
        file.delete();
      });
    });
  } else {
    print(file.path);
    await file.writeAsBytes(await pdf.save());
  }
}
