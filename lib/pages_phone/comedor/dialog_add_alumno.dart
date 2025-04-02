import 'package:flutter/material.dart';

import 'package:uniditos/entities/alumnos.dart';
import 'package:uniditos/models/comedor_create.dart';
import 'package:uniditos/services/alumnos_service.dart';
import 'package:uniditos/services/comedor_service.dart';

class DialogAddComedor extends StatefulWidget {
  final int? alumnoId;

  const DialogAddComedor({Key? key, this.alumnoId}) : super(key: key);

  @override
  State<DialogAddComedor> createState() => _DialogAddComedorState();
}

class _DialogAddComedorState extends State<DialogAddComedor> {
  final _formKey = GlobalKey<FormState>();
  Alumnos? _selectedAlumno;

  DateTime _selectedFecha = DateTime.now();

  double _importe = 2000;

  List<Alumnos> _alumnos = [];

  final TextEditingController _alumnoController = TextEditingController();

  @override
  void initState() {
    if (DateTime.now().hour >= 14) {
      _selectedFecha = _selectedFecha.add(const Duration(days: 1));
    }
    super.initState();
    _fetchAlumnos();
  }

  _fetchAlumnos() async {
    _alumnos = await AlumnosServices.getAlumnos();
    if (widget.alumnoId != null) {
      _selectedAlumno = _alumnos.firstWhere(
        (element) => element.alumnoId == widget.alumnoId,
      );
      _alumnos = [_selectedAlumno!];
      _alumnoController.text =
          '${_selectedAlumno!.apellido}, ${_selectedAlumno!.nombre}';
    }
    setState(() {});
  }

  _saveComprobante() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ComedorService.createMovimientoComedor(
            ComedorCreate(
              alumnoId: _selectedAlumno!.alumnoId,
              fecha: _selectedFecha,
              importe: _importe,
              pago: false,
            ),
          )
          .then((value) {
            if (value.statusCode == 200 || value.statusCode == 201) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Alumno agregado')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error al agregar comedor')),
              );
            }
            Navigator.of(context).pop();
          })
          .catchError((e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al agregar comedor: ${e.toString()}'),
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar a Comedor'),
      content: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  widget.alumnoId == null
                      ? Autocomplete<Alumnos>(
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
                        optionsViewBuilder: (
                          BuildContext context,
                          AutocompleteOnSelected<Alumnos> onSelected,
                          Iterable<Alumnos> options,
                        ) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              child: SizedBox(
                                width: 300,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    final Alumnos alumno = options.elementAt(
                                      index,
                                    );
                                    return ListTile(
                                      title: Text(
                                        '${alumno.apellido}, ${alumno.nombre}',
                                      ),
                                      onTap: () {
                                        onSelected(alumno);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                        //initialValue: TextEditingValue(text: _selectedAlumno?.nombre ?? ''),
                        displayStringForOption:
                            (Alumnos alumno) =>
                                '${alumno.apellido}, ${alumno.nombre}',
                        fieldViewBuilder: (
                          BuildContext context,
                          TextEditingController textEditingController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted,
                        ) {
                          return TextFormField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              labelText: 'Alumno',
                              hintText: 'Escriba para buscar',
                            ),
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
                      )
                      : TextFormField(
                        controller: _alumnoController,
                        decoration: const InputDecoration(labelText: 'Alumno'),
                        enabled: false,
                      ),
                  TextFormField(
                    initialValue: _importe.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Precio Vianda',
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _importe = double.parse(value ?? '0');
                    },
                    validator:
                        (value) => value!.isEmpty ? 'Ingresa un importe' : null,
                  ),
                  //Agregar un campo para cambiar la fecha y guardarla en la variable _selectedFecha
                  Row(
                    children: [
                      const Text('Fecha: '),
                      TextButton(
                        onPressed: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedFecha,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 30),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 30),
                            ),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              _selectedFecha = selectedDate;
                            });
                          }
                        },
                        child: Text(
                          '${_selectedFecha.day}/${_selectedFecha.month}/${_selectedFecha.year}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveComprobante,
                    child: const Text('Agregar'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Si la fecha es mayor a las 14hs, se agregará para mañana.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
