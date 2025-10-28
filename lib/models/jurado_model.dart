class Jurado {
  final String name;
  final String role;
  final String specialty;
  final String status;

  Jurado({
    required this.name,
    required this.role,
    required this.specialty,
    required this.status,
  });

  factory Jurado.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    return Jurado(
      name: user['nombre'] ?? 'Sin nombre',
      role: 'Jurado Principal',
      specialty: json['carrera'] ?? 'Sin especialidad',
      status: json['idJurado']?.toString() ?? 'Pendiente',
    );
  }
}
