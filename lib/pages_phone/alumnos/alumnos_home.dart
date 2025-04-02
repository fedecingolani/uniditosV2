import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uniditos/entities/alumno_detail.dart';
import 'package:uniditos/pages_phone/alumnos/views/comedor_info.dart';
import 'package:uniditos/pages_phone/alumnos/views/comrpobantes_info.dart';
import 'package:uniditos/pages_phone/alumnos/views/mov_info.dart';
import 'package:uniditos/pages_phone/alumnos/views/personal_info.dart';
import 'package:uniditos/services/alumnos_service.dart';

class AlumnosHome extends StatefulWidget {
  final int id;
  final int indexPage;

  const AlumnosHome({Key? key, required this.id, required this.indexPage})
    : super(key: key);

  @override
  State<AlumnosHome> createState() => _AlumnosHomeState();
}

class _AlumnosHomeState extends State<AlumnosHome> {
  int _selectedIndex = 0;

  bool loading = true;
  AlumnoDetail? alumno;
  List<Widget> views = [];

  Future<AlumnoDetail> getAlumno() async {
    await AlumnosServices.getAlumnosId(widget.id).then((value) {
      alumno = value;
    });
    return alumno!;
  }

  @override
  void initState() {
    getAlumno().then(
      (value) => setState(() {
        _selectedIndex = widget.indexPage;
        views = [
          PersonalInfo(alum: alumno!),
          MovimientoInfo(id: widget.id),
          ComedorInfo(id: widget.id),
          ComprobantesInfo(id: widget.id),
        ];
        loading = false;
      }),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(child: Container());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('${alumno!.nombre.trim()} ${alumno!.apellido.trim()}'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Datos'),
          BottomNavigationBarItem(
            icon: Icon(Icons.import_export_rounded),
            label: 'Movimientos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank_outlined),
            label: 'Comedor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Comprobantes',
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          PersonalInfo(alum: alumno!),
          MovimientoInfo(id: widget.id),
          ComedorInfo(id: widget.id),
          ComprobantesInfo(id: widget.id),
          //ComprobantesInfo(id: widget.id),
        ],
      ),
    );
  }
}
