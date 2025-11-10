class ProyectoAsignado {
  final int idProyecto;
  final String titulo;
  final String estudiante;
  final String correo;
  final String estado;
  final String tipo; 
  final String? rutaDocumento; 
  final int? idPlanEntrega;

  ProyectoAsignado({
    required this.idProyecto,
    required this.titulo,
    required this.estudiante,
    required this.correo,
    required this.estado,
    required this.tipo, 
    this.rutaDocumento, 
    this.idPlanEntrega,
  });

  factory ProyectoAsignado.fromJson(Map<String, dynamic> json) {
    return ProyectoAsignado(
      idProyecto: json['idProyecto'] ?? 0,
      titulo: json['titulo'] ?? '',
      estudiante: json['estudiante'] ?? '',
      correo: json['correo'] ?? '',
      estado: json['estado'] ?? 'PENDIENTE',
      tipo: json['tipo'] ?? '', 
      rutaDocumento: json['rutaDocumento'], 
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
      'tipo': tipo, 
      'rutaDocumento': rutaDocumento, 
      'idPlanEntrega': idPlanEntrega,
    };
  }

  ProyectoAsignado copyWith({
    int? idProyecto,
    String? titulo,
    String? estudiante,
    String? correo,
    String? estado,
    String? tipo,
    String? rutaDocumento,
    int? idPlanEntrega,
  }) {
    return ProyectoAsignado(
      idProyecto: idProyecto ?? this.idProyecto,
      titulo: titulo ?? this.titulo,
      estudiante: estudiante ?? this.estudiante,
      correo: correo ?? this.correo,
      estado: estado ?? this.estado,
      tipo: tipo ?? this.tipo,
      rutaDocumento: rutaDocumento ?? this.rutaDocumento,
      idPlanEntrega: idPlanEntrega ?? this.idPlanEntrega,
    );
  }
}
