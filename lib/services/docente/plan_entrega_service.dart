import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlanEntregaService {
  final String baseUrl = dotenv.env['IP'] ?? 'http://localhost:5001';

  // 🔹 Obtener planes por proyecto
  Future<List<dynamic>> obtenerPlanesPorProyecto(int idProyecto) async {
    final url = Uri.parse('$baseUrl/entrega/proyecto/$idProyecto');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener los planes de entrega');
    }
  }

  // 🔹 Crear un nuevo plan de entrega
  Future<bool> crearPlanEntrega(Map<String, dynamic> nuevoPlan) async {
    final url = Uri.parse('$baseUrl/entrega/planear');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(nuevoPlan),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error al crear plan: ${response.statusCode}');
      return false;
    }
  }
}
