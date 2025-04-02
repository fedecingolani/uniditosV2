import 'package:intl/intl.dart';

String convertirMinutosAHorasMinutos(int minutos) {
  int horas = minutos ~/ 60;
  int minutosRestantes = minutos % 60;

  String resultadoHoras = horas.toString().padLeft(1, '0');
  String resultadoMinutos = minutosRestantes.toString().padLeft(2, '0');

  if (horas == 0) {
    return '0:$resultadoMinutos';
  } else {
    return "$resultadoHoras:$resultadoMinutos";
  }
}

DateFormat formatDate = DateFormat('dd-MM-yyyy HH:mm');
DateFormat formatOnlyDate = DateFormat('dd-MM-yyyy');
DateFormat formatOnlyHS = DateFormat('HH:mm');
