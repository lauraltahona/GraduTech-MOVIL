import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProyectosAsignadosService {
  final String baseUrl = dotenv.env['IP'] ?? 'http://localhost:5001';

  // Obtener proyectos asignados al docente
  Future<List<Map<String, dynamic>>> obtenerProyectosAsignados(int idUsuario) async {
    final url = Uri.parse('$baseUrl/proyectos/asignados/jurado/$idUsuario');
    
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Error al obtener proyectos asignados: ${response.statusCode}');
    }
  }

  // Cambiar estado del proyecto
  Future<bool> cambiarEstadoProyecto(int idProyecto, String nuevoEstado) async {
    final url = Uri.parse('$baseUrl/proyectos/cambiar-estado');
    
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'idProyecto': idProyecto,
        'estado': nuevoEstado,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al cambiar estado: ${response.statusCode}');
    }
  }
}