import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:uniditos/entities/Comprobantes.dart';
import 'package:uniditos/helper/minutos_hora.dart';

import 'package:uniditos/services/alumnos_service.dart';

Future<void> generateReporteComprobantes(
  List<Comprobantes> data,
  String mes,
  int alumnoId,
) async {
  var datos = data;
  print(datos.length);

  var alumno = await AlumnosServices.getAlumnosId(alumnoId);

  final pdf = pw.Document(pageMode: PdfPageMode.none);
  final profileImage = pw.MemoryImage(
    (await rootBundle.load('assets/uniLogo.jpg')).buffer.asUint8List(),
  );

  List<Map<String, dynamic>> comprobantes = [];

  datos.forEach((element) {
    switch (element.letraComprobante) {
      case "C":
        element.detalle = "Comprobante de Comedor";
        break;
      case "A":
        element.detalle = "Comprobante de Abono";
        break;
      case "P":
        element.detalle = "Comprobante de Pago";
        break;
      default:
        element.detalle = "Comprobante ${element.detalle}";
    }
    comprobantes.add({
      'detalle': element.detalle,
      'fecha': formatOnlyDate.format(element.fecha),
      'importe': element.importe,
      'notas':
          "Nota:${element.notas}- Referencia:${element.letraComprobante}${element.numeroComprobante}",
    });
  });

  num totalComedor = 0;
  num totalAbono = 0;
  num totalPago = 0;

  datos.forEach((element) {
    switch (element.letraComprobante) {
      case "C":
        totalComedor += element.importe;
        break;
      case "A":
        totalAbono += element.importe;
        break;
      case "P":
        totalPago += element.importe;
        break;
    }
  });

  // Dividir los comprobantes en páginas si hay demasiados elementos
  List<List<Map<String, dynamic>>> dividirPorPaginas(
    List<Map<String, dynamic>> comprobantes,
    int cantidadPorPagina,
  ) {
    List<List<Map<String, dynamic>>> paginas = [];
    for (var i = 0; i < comprobantes.length; i += cantidadPorPagina) {
      paginas.add(
        comprobantes.sublist(
          i,
          i + cantidadPorPagina > comprobantes.length
              ? comprobantes.length
              : i + cantidadPorPagina,
        ),
      );
    }
    return paginas;
  }

  int cantidadPorPagina =
      15; // Número de comprobantes por página, puedes ajustarlo
  List<List<Map<String, dynamic>>> paginasComprobantes = dividirPorPaginas(
    comprobantes,
    cantidadPorPagina,
  );

  for (var pagina in paginasComprobantes) {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
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
                              'Comprobantes $mes',
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
                  ],
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Total Comedor: \$$totalComedor'),
                  pw.Text('Total Abono: \$$totalAbono'),
                  pw.Text('Total Pago: \$$totalPago'),
                ],
              ),
              pw.SizedBox(height: 15),
              pw.Text(
                'SALDO: \$${totalPago - totalComedor - totalAbono}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Divider(),
              pw.SizedBox(height: 20),
              // Tabla de comprobantes por página
              pw.TableHelper.fromTextArray(
                headers: <String>['Fecha', 'Tipo Comprobante', 'Importe'],
                data:
                    pagina
                        .map(
                          (e) => [
                            e['fecha'],
                            e['detalle'],
                            '\$${e['importe']}',
                          ],
                        )
                        .toList(),
              ),
            ],
      ),
    );
  }

  final directory = await getApplicationSupportDirectory();
  final path = directory.path;
  final reportesDir = Directory('$path/reportes/Comprobantes/$mes');
  if (!(await reportesDir.exists())) {
    await reportesDir.create(recursive: true);
  }

  String fecha1 = '${DateTime.now().second}';

  File file = File(
    '$path/reportes/Comprobantes/$mes/${alumno.apellido}-${alumno.nombre}-$fecha1.pdf',
  );

  if (Platform.isAndroid) {
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(
      '$path/reportes/Comprobantes/$mes/${alumno.apellido}-${alumno.nombre}-$fecha1.pdf',
    ).then((value) {
      Future.delayed(const Duration(seconds: 2), () {
        file.delete();
      });
    });
  } else {
    print(file.path);
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(
      '$path/reportes/Comprobantes/$mes/${alumno.apellido}-${alumno.nombre}-$fecha1.pdf',
    );
  }
}
