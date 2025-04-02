import 'package:flutter/material.dart';
import 'package:uniditos/entities/alumno_detail.dart';
import 'package:uniditos/entities/alumnos.dart';
import 'package:uniditos/services/alumnos_service.dart';

class ComprobanteScreen extends StatefulWidget {
  @override
  _ComprobanteScreenState createState() => _ComprobanteScreenState();
}

class _ComprobanteScreenState extends State<ComprobanteScreen> {
  final _formKey = GlobalKey<FormState>();
  Alumnos? _selectedAlumno;
  String? _selectedTipoComprobante;
  DateTime _selectedFecha = DateTime.now();
  String _detalle = '';
  double _importe = 0.0;

  List<Alumnos> _alumnos = []; // Aquí almacenarás los alumnos del servicio

  final TextEditingController _alumnoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAlumnos(); // Llamar al servicio para obtener los alumnos
  }

  _fetchAlumnos() async {
    _alumnos = await AlumnosServices.getAlumnos();
    setState(() {});
  }

  _saveComprobante() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Aquí llamas al backend para guardar el comprobante
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ingresar Comprobante')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Autocomplete<Alumnos>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<Alumnos>.empty();
                  }
                  return _alumnos.where((Alumnos alumno) {
                    return alumno.nombre.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ) ||
                        alumno.apellido.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        );
                  });
                },
                displayStringForOption:
                    (Alumnos alumno) => '${alumno.apellido}, ${alumno.nombre}',
                fieldViewBuilder: (
                  BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted,
                ) {
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(labelText: 'Alumno'),
                    validator:
                        (value) =>
                            _selectedAlumno == null
                                ? 'Selecciona un alumno'
                                : null,
                  );
                },
                onSelected: (Alumnos alumno) {
                  setState(() {
                    _selectedAlumno = alumno;
                    _alumnoController.text = alumno.nombre;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedTipoComprobante,
                items:
                    ['Comedor', 'Abono', 'Pago'].map((tipo) {
                      return DropdownMenuItem<String>(
                        value: tipo,
                        child: Text(tipo),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTipoComprobante = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Tipo de Comprobante'),
                validator:
                    (value) =>
                        value == null
                            ? 'Selecciona un tipo de comprobante'
                            : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Detalle'),
                onSaved: (value) {
                  _detalle = value ?? '';
                },
                validator:
                    (value) => value!.isEmpty ? 'Ingresa un detalle' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Importe'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _importe = double.parse(value ?? '0');
                },
                validator:
                    (value) => value!.isEmpty ? 'Ingresa un importe' : null,
              ),
              ElevatedButton(
                onPressed: _saveComprobante,
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
