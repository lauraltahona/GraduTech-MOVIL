class Proyecto {
  final int idProyecto;
  final String titulo;
  final String descripcion;
  final String tipo;
  final String? estado;
  final String? rutaDocumento;
  final String? carrera;
  final String? fecha;
  final String? updatedAt;
  final int? idJurado;

  Proyecto({
    required this.idProyecto,
    required this.titulo,
    required this.descripcion,
    required this.tipo,
    this.estado,
    this.rutaDocumento,
    this.carrera,
    this.fecha,
    this.updatedAt,
    this.idJurado,
  });

  factory Proyecto.fromJson(Map<String, dynamic> json) {
    return Proyecto(
      idProyecto: json['idProyecto'] ?? 0,
      titulo: json['title'] ?? '',
      descripcion: json['descripcion'] ?? '',
      tipo: json['tipo'] ?? '',
      estado: json['estado'],
      rutaDocumento: json['rutaDocumento'],
      carrera: json['student']?['carrera'],
      fecha: json['createdAt'],
      updatedAt: json['updatedAt'],
      idJurado: json['idJurado'],
    );
  }
}
