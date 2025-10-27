class Entrega{
  final int? idEntrega;
  final String? descripcion;
  final String? retroalimetacion;
  final String? rutaDocumento;

  Entrega({
    this.idEntrega,
    this.descripcion,
    this.retroalimetacion,
    this.rutaDocumento,
  });

  factory Entrega.fromJson(Map<String, dynamic> json) {
    return Entrega(
      idEntrega: json['idEntrega'] ?? 0,
      descripcion: json['descripcion'] ?? '',
      retroalimetacion: json['retroalimetacion'] ?? '',
      rutaDocumento: json['rutaDocumento'] ?? '',
    );
  }
}
  