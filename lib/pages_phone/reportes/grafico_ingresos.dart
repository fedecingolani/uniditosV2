//https://localhost:7184/api/movimientos/grafico/${widget.monthId}
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:uniditos/services/settings.dart';

class MovimientoGraficos {
  int dia;
  List<MovimientoGraficosDetalle> detalle;

  MovimientoGraficos({required this.dia, required this.detalle});

  factory MovimientoGraficos.fromJson(Map<String, dynamic> json) {
    var list = json['detalle'] as List;
    List<MovimientoGraficosDetalle> detalleList =
        list.map((i) => MovimientoGraficosDetalle.fromJson(i)).toList();
    return MovimientoGraficos(dia: json['dia'], detalle: detalleList);
  }
}

class MovimientoGraficosDetalle {
  DateTime hora;
  int cantidad;

  MovimientoGraficosDetalle({required this.hora, required this.cantidad});

  factory MovimientoGraficosDetalle.fromJson(Map<String, dynamic> json) {
    return MovimientoGraficosDetalle(
      hora: DateTime.parse(json['hora']),
      cantidad: json['cantidad'],
    );
  }
}

class GraficoPage extends StatefulWidget {
  final int monthId;

  const GraficoPage({super.key, required this.monthId});

  @override
  State<GraficoPage> createState() => _GraficoPageState();
}

class _GraficoPageState extends State<GraficoPage> {
  late Future<List<MovimientoGraficos>> futureMovimientos;
  late GlobalKey<SfCartesianChartState> _chartKey;

  String month = '';

  @override
  void initState() {
    super.initState();
    futureMovimientos = fetchMovimientos();
    _chartKey = GlobalKey();
  }

  Future<List<MovimientoGraficos>> fetchMovimientos() async {
    final response = await http.get(
      Uri.parse('$urlbase/movimientos/grafico/${widget.monthId}'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => MovimientoGraficos.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _exportToPdf() async {
    final PdfDocument document = PdfDocument();
    document.pageSettings.size = PdfPageSize.a4;
    document.pageSettings.orientation = PdfPageOrientation.landscape;

    final PdfPage page = document.pages.add();

    // Renderiza el gráfico como una imagen
    final ui.Image? chartImage = await _chartKey.currentState!.toImage(
      pixelRatio: 3.0,
    );

    // Convierte la imagen a bytes
    final ByteData? byteData = await chartImage?.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final Uint8List imageBytes = byteData!.buffer.asUint8List();

    page.graphics.drawImage(
      PdfBitmap(imageBytes),
      Rect.fromLTWH(0, 0, page.getClientSize().width, 400),
    );

    page.graphics.drawString(
      'Gráfico de Movimientos',
      PdfStandardFont(PdfFontFamily.helvetica, 18),
      bounds: const Rect.fromLTWH(0, 410, 500, 20),
    );

    final List<int> bytes = document.saveSync();
    document.dispose();

    //pasar de un int al mes correspondiente

    switch (widget.monthId) {
      case 1:
        month = 'Enero';
        break;
      case 2:
        month = 'Febrero';
        break;
      case 3:
        month = 'Marzo';
        break;
      case 4:
        month = 'Abril';
        break;
      case 5:
        month = 'Mayo';
        break;
      case 6:
        month = 'Junio';
        break;
      case 7:
        month = 'Julio';
        break;
      case 8:
        month = 'Agosto';
        break;
      case 9:
        month = 'Septiembre';
        break;
      case 10:
        month = 'Octubre';
        break;
      case 11:
        month = 'Noviembre';
        break;
      case 12:
        month = 'Diciembre';
        break;
    }

    final directory = await getApplicationSupportDirectory();
    final path = directory.path;
    final reportesDir = Directory('$path/reportes');
    if (!(await reportesDir.exists())) {
      await reportesDir.create(recursive: true);
    }
    String fecha1 = '$month${DateTime.now().second}';
    File file = File('$path/reportes/$fecha1.pdf');

    if (Platform.isAndroid) {
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open('$path/reportes/$fecha1.pdf').then((value) {
        Future.delayed(const Duration(seconds: 2), () {
          file.delete();
        });
      });
    } else {
      print(file.path);
      await file.writeAsBytes(bytes, flush: true);
    }

    // final Directory directory = await getApplicationDocumentsDirectory();
    // final String path = directory.path;
    // final File file = File('$path/$month(${DateTime.now().microsecond}).pdf');
    // await file.writeAsBytes(bytes, flush: true);
    // print('PDF saved to $path/$month(${DateTime.now().microsecond}).pdf');
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF saved to $path/$month(${DateTime.now().microsecond}).pdf')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfico de Movimientos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _exportToPdf,
          ),
        ],
      ),
      body: FutureBuilder<List<MovimientoGraficos>>(
        future: futureMovimientos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return SfCartesianChart(
              key: _chartKey,
              primaryXAxis: const CategoryAxis(
                title: AxisTitle(text: 'Horario'),
                interval: 1,
              ),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: 'Cantidad de Alumnos'),
              ),
              title: ChartTitle(text: '$month-Movimientos por Día y Hora'),
              legend: const Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: _getSeries(snapshot.data!),
            );
          }
        },
      ),
    );
  }

  List<CartesianSeries<dynamic, dynamic>> _getSeries(
    List<MovimientoGraficos> data,
  ) {
    List<CartesianSeries<dynamic, dynamic>> series = [];
    for (var dia in data) {
      series.add(
        LineSeries<MovimientoGraficosDetalle, String>(
          dataSource: dia.detalle,
          xValueMapper:
              (MovimientoGraficosDetalle detalle, _) =>
                  '${detalle.hora.hour}:${detalle.hora.minute.toString().padLeft(2, '0')}', // Formatear la hora
          yValueMapper:
              (MovimientoGraficosDetalle detalle, _) => detalle.cantidad,
          name: 'Día ${dia.dia}',
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      );
    }
    return series;
  }
}
