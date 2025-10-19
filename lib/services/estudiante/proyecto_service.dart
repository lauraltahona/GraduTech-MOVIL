import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class ProyectoService {
  final String baseUrl = dotenv.env['IP'] ?? 'http://localhost:5001';

  Future<Map<String, dynamic>> obtenerProyecto(int idUsuario) async {
    try {
      final url = Uri.parse('$baseUrl/proyectos/obtener/$idUsuario');
      debugPrint('🔍 URL de petición: $url');
      debugPrint('👤 idUsuario en servicio: $idUsuario');
      
      final response = await http.get(url);
      
      debugPrint('📡 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        
        // Debug detallado de cada campo
        debugPrint('✅ Datos recibidos exitosamente:');
        debugPrint('  - title: ${data['title']}');
        debugPrint('  - descripcion: ${data['descripcion']}');
        debugPrint('  - estado: ${data['estado']}');
        debugPrint('  - createdAt: ${data['createdAt']} (${data['createdAt'].runtimeType})');
        debugPrint('  - idEstudiante: ${data['idEstudiante']}');
        debugPrint('  - idDocente: ${data['idDocente']}');
        debugPrint('  - rutaDocumento: ${data['rutaDocumento']}');
        
        return data;
      } else {
        debugPrint('❌ Error: Status ${response.statusCode}');
        throw Exception("Error al obtener proyecto: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint('💥 Excepción en obtenerProyecto: $e');
      rethrow;
    }
  }
}