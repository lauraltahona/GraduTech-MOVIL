import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:proyecto_movil/models/proyecto_model.dart';
import 'package:proyecto_movil/models/jurado_model.dart';

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

   Future<Proyecto?> obtenerMiProyecto(int idUsuario) async {
    final res = await http.get(Uri.parse('$baseUrl/proyectos/obtener/$idUsuario'));
    if (res.statusCode == 200) {
      return Proyecto.fromJson(jsonDecode(res.body));
    }
    return null;
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

  Future<Jurado?> obtenerJurado(int idJurado) async {
    final res = await http.get(Uri.parse('$baseUrl/jurado/getById/$idJurado'));
    if (res.statusCode == 200) {
      return Jurado.fromJson(jsonDecode(res.body));
    }
    return null;
  }

  Future<bool> enviarAutorizacion(int idProyecto) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/proyectos/autorizacion'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "idProyecto": idProyecto,
        "autorizacion_repositorio": "SI",
      }),
    );
    return res.statusCode == 200;
  }
}
