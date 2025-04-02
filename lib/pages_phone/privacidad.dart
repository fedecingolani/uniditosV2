import 'package:flutter/material.dart';
import 'package:uniditos/models/privacidad_policy.dart';

class PrivacidadPage extends StatelessWidget {
  const PrivacidadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PrivacidadPolicy politicaDePrivacidad = PrivacidadPolicy.fromJson({
      'titulo': 'Política de Privacidad',
      'fecha': '9 de marzo de 2024',
      'introduccion':
          'Uniditos App es una aplicación para el control horario de un jardín de infantes. Esta aplicación permite a los padres de familia registrar la entrada y salida de sus hijos del jardín, así como ver el historial de asistencia.',
      'informacionRecopilada': [
        'Información personal: Nombre, correo electrónico, número de teléfono, dirección postal.',
        'Información de los niños: Nombre, fecha de nacimiento, sexo, foto.',
        'Información del jardín de infantes: Nombre, dirección, teléfono.',
        'Información de asistencia: Fecha y hora de entrada y salida del jardín.',
      ],
      'comoSeUtilizaLaInformacion': [
        'Proporcionar el servicio de control horario.',
        'Enviar notificaciones a los padres sobre la entrada y salida de sus hijos del jardín.',
        'Generar informes de asistencia.',
        'Mejorar la aplicación.',
      ],
      'comoSeComparteLaInformacion': [
        'No compartimos la información personal de los usuarios con terceros sin su consentimiento.',
        'Solo compartimos información agregada o anónima con terceros para fines estadísticos o de investigación.',
      ],
      'seguridadDeLaInformacion':
          'Tomamos medidas de seguridad razonables para proteger la información personal de los usuarios contra el acceso no autorizado, el uso indebido, la divulgación, la alteración o la destrucción.',
      'derechosDeLosUsuarios': [
        'Los usuarios tienen derecho a acceder, corregir o eliminar su información personal.',
        'También tienen derecho a oponerse al procesamiento de su información personal y a solicitar la restricción del mismo.',
      ],
      'contacto':
          'Si tiene alguna pregunta sobre esta política de privacidad, puede contactarnos a través de la aplicación o por correo electrónico a [correo electrónico de contacto].',
      'actualizacionesDeLaPoliticaDePrivacidad':
          'Nos reservamos el derecho de actualizar esta política de privacidad en cualquier momento. Le notificaremos de cualquier cambio importante en la política de privacidad por correo electrónico o a través de la aplicación.',
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Política de Privacidad')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          politicaDePrivacidad.toJson().toString(),
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
