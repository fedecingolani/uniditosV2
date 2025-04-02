import 'package:flutter/material.dart';
import 'package:uniditos/helper/meses.dart';
import 'package:uniditos/pages_phone/reportes/generar_pdf/reporte_horas_general.dart';

import 'package:uniditos/pages_phone/reportes/generar_pdf/reporte_horas_detallado.dart';
import 'package:uniditos/pages_phone/reportes/grafico_ingresos.dart';

class ReportePage extends StatefulWidget {
  const ReportePage({super.key});

  @override
  State<ReportePage> createState() => _ReportePageState();
}

class _ReportePageState extends State<ReportePage> {
  // String mesSelected = 'Enero';
  // int numeroMes = 1;
  Map<String, int> mesSelected = {};

  @override
  void initState() {
    mesSelected = meses[DateTime.now().month - 1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reporte de horas mensual')),
      body: Center(
        child: Column(
          children: [
            //combo box para seleccionar el mes
            SizedBox(
              width: 250,
              child: DropdownButton<Map<String, int>>(
                value: mesSelected,
                onChanged: (Map<String, int>? value) {
                  setState(() {
                    mesSelected = value!;
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
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  generatePDF(mesSelected.keys.first, mesSelected.values.first);
                },
                child: const Text('Generar PDF'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  generatePDFDetallado(
                    mesSelected.keys.first,
                    mesSelected.values.first,
                  );
                },
                child: const Text('Generar PDF Detallado'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              GraficoPage(monthId: mesSelected.values.first),
                    ),
                  );
                },
                child: const Text('Graficos de Movimientos'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
