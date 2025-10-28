// models/entrega_model.dart
class Entrega {
  final int idEntrega;
  final DateTime fechaEnvio;
  final String rutaDocumento;
  final String descripcion;
  final int idEstudiante;
  final String? retroalimentacion;
  final String? rutaRetroalimentacion;

  Entrega({
    required this.idEntrega,
    required this.fechaEnvio,
    required this.rutaDocumento,
    required this.descripcion,
    required this.idEstudiante,
    this.retroalimentacion,
    this.rutaRetroalimentacion,
  });

  factory Entrega.fromJson(Map<String, dynamic> json) {
    return Entrega(
      idEntrega: json['idEntrega'] ?? 0,
      fechaEnvio: DateTime.parse(json['fecha_envio']),
      rutaDocumento: json['ruta_documento'] ?? '',
      descripcion: json['descripcion'] ?? '',
      idEstudiante: json['id_estudiante'] ?? 0,
      retroalimentacion: json['retroalimentacion'],
      rutaRetroalimentacion: json['ruta_retroalimentacion'],
    );
  }

  // Agregar este método copyWith
  Entrega copyWith({
    int? idEntrega,
    DateTime? fechaEnvio,
    String? rutaDocumento,
    String? descripcion,
    int? idEstudiante,
    String? retroalimentacion,
    String? rutaRetroalimentacion,
  }) {
    return Entrega(
      idEntrega: idEntrega ?? this.idEntrega,
      fechaEnvio: fechaEnvio ?? this.fechaEnvio,
      rutaDocumento: rutaDocumento ?? this.rutaDocumento,
      descripcion: descripcion ?? this.descripcion,
      idEstudiante: idEstudiante ?? this.idEstudiante,
      retroalimentacion: retroalimentacion ?? this.retroalimentacion,
      rutaRetroalimentacion: rutaRetroalimentacion ?? this.rutaRetroalimentacion,
    );
  }
}