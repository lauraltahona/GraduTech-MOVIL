class ProyectoAsignado {
  final int idProyecto;
  final String titulo;
  final String estudiante;
  final String correo;
  final String estado;
  final int? idPlanEntrega;

  ProyectoAsignado({
    required this.idProyecto,
    required this.titulo,
    required this.estudiante,
    required this.correo,
    required this.estado,
    this.idPlanEntrega,
  });

  factory ProyectoAsignado.fromJson(Map<String, dynamic> json) {
    return ProyectoAsignado(
      idProyecto: json['idProyecto'] ?? 0,
      titulo: json['titulo'] ?? '',
      estudiante: json['estudiante'] ?? '',
      correo: json['correo'] ?? '',
      estado: json['estado'] ?? 'PENDIENTE',
      idPlanEntrega: json['idPlanEntrega'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProyecto': idProyecto,
      'titulo': titulo,
      'estudiante': estudiante,
      'correo': correo,
      'estado': estado,
      'idPlanEntrega': idPlanEntrega,
    };
  }

  ProyectoAsignado copyWith({
    int? idProyecto,
    String? titulo,
    String? estudiante,
    String? correo,
    String? estado,
    int? idPlanEntrega,
  }) {
    return ProyectoAsignado(
      idProyecto: idProyecto ?? this.idProyecto,
      titulo: titulo ?? this.titulo,
      estudiante: estudiante ?? this.estudiante,
      correo: correo ?? this.correo,
      estado: estado ?? this.estado,
      idPlanEntrega: idPlanEntrega ?? this.idPlanEntrega,
    );
  }
}