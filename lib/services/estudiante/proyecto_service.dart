import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:proyecto_movil/models/proyecto_model.dart';

class ProyectoService {
  final String baseUrl = dotenv.env['IP'] ?? 'http://localhost:5001';

  Future<Map<String, dynamic>> obtenerProyecto(int idUsuario) async {
    try {
      final url = Uri.parse('$baseUrl/proyectos/obtener/$idUsuario');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        debugPrint('❌ Error: Status ${response.statusCode}');
        throw Exception("Error al obtener proyecto: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint('💥 Excepción en obtenerProyecto: $e');
      rethrow;
    }
  }

  Future<List<Proyecto>> obtenerProyectos(String tipo) async {
    try {
      final url = Uri.parse("$baseUrl/proyectos/mostrarProyectos?tipo=$tipo");
      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception("Error al obtener los proyectos");
      }

      final List data = json.decode(response.body);
      return data.map((json) => Proyecto.fromJson(json)).toList();
    } catch (e) {
      debugPrint('💥 Error al obtener proyectos: $e');
      rethrow;
    }
  }
}
