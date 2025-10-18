import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class EntregaService {
  final String baseUrl = dotenv.env['IP'] ?? '';

  Future<List<Map<String, dynamic>>> obtenerFechasEntregas(int idUsuario) async {
    final url = Uri.parse("$baseUrl/entrega/fechas/$idUsuario");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(
        data.map((e) => {
          "fecha": DateTime.parse(e["fecha_limite"]),
          "descripcion": e["titulo"],
        }),
      );
    } else {
      throw Exception("Error al obtener entregas");
    }
  }
}
