class PrivacidadPolicy {
  String titulo;
  String fecha;
  String introduccion;
  List<String> informacionRecopilada;
  List<String> comoSeUtilizaLaInformacion;
  List<String> comoSeComparteLaInformacion;
  String seguridadDeLaInformacion;
  List<String> derechosDeLosUsuarios;
  String contacto;
  String actualizacionesDeLaPoliticaDePrivacidad;

  PrivacidadPolicy({
    required this.titulo,
    required this.fecha,
    required this.introduccion,
    required this.informacionRecopilada,
    required this.comoSeUtilizaLaInformacion,
    required this.comoSeComparteLaInformacion,
    required this.seguridadDeLaInformacion,
    required this.derechosDeLosUsuarios,
    required this.contacto,
    required this.actualizacionesDeLaPoliticaDePrivacidad,
  });

  factory PrivacidadPolicy.fromJson(Map<String, dynamic> json) {
    return PrivacidadPolicy(
      titulo: json['titulo'],
      fecha: json['fecha'],
      introduccion: json['introduccion'],
      informacionRecopilada: json['informacionRecopilada'].cast<String>(),
      comoSeUtilizaLaInformacion: json['comoSeUtilizaLaInformacion'].cast<String>(),
      comoSeComparteLaInformacion: json['comoSeComparteLaInformacion'].cast<String>(),
      seguridadDeLaInformacion: json['seguridadDeLaInformacion'],
      derechosDeLosUsuarios: json['derechosDeLosUsuarios'].cast<String>(),
      contacto: json['contacto'],
      actualizacionesDeLaPoliticaDePrivacidad: json['actualizacionesDeLaPoliticaDePrivacidad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'fecha': fecha,
      'introduccion': introduccion,
      'informacionRecopilada': informacionRecopilada,
      'comoSeUtilizaLaInformacion': comoSeUtilizaLaInformacion,
      'comoSeComparteLaInformacion': comoSeComparteLaInformacion,
      'seguridadDeLaInformacion': seguridadDeLaInformacion,
      'derechosDeLosUsuarios': derechosDeLosUsuarios,
      'contacto': contacto,
      'actualizacionesDeLaPoliticaDePrivacidad': actualizacionesDeLaPoliticaDePrivacidad,
    };
  }
}
