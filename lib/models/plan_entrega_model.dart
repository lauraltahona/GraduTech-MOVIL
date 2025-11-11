class PlanEntrega {
  final int? idPlanEntrega;
  final int idProyecto;
  final int nroEntrega;
  final String titulo;
  final String descripcion;
  final DateTime fechaLimite;
  final DateTime? createdAt;

  PlanEntrega({
    this.idPlanEntrega,
    required this.idProyecto,
    required this.nroEntrega,
    required this.titulo,
    required this.descripcion,
    required this.fechaLimite,
    this.createdAt,
  });

  factory PlanEntrega.fromJson(Map<String, dynamic> json) {
    return PlanEntrega(
      idPlanEntrega: json['id_plan_entrega'],
      idProyecto: json['id_proyecto'] ?? 0,
      nroEntrega: json['nro_entrega'] ?? 0,
      titulo: json['title'] ?? '',
      descripcion: json['descripcion'] ?? '',
      fechaLimite: DateTime.parse(json['fecha_limite']),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idPlanEntrega != null) 'id_plan_entrega': idPlanEntrega,
      'id_proyecto': idProyecto,
      'nro_entrega': nroEntrega,
      'title': titulo,
      'descripcion': descripcion,
      'fecha_limite': fechaLimite.toIso8601String(),
    };
  }
}