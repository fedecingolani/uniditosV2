import 'package:flutter/material.dart';
import 'package:uniditos/entities/salas.dart';
import 'package:uniditos/services/salas_service.dart';

class SalasPage extends StatefulWidget {
  const SalasPage({super.key});

  @override
  State<SalasPage> createState() => _SalasPageState();
}

class _SalasPageState extends State<SalasPage> {
  List<Salas> salas = [];

  @override
  void initState() {
    SalasServices.getSalas().then((value) {
      setState(() {
        salas = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Salas')),
      body: ListView.builder(
        itemCount: salas.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 100,
            child: Card(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      child: Text(salas[index].nombreSala[0]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          salas[index].nombreSala,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(salas[index].alias ?? ''),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
