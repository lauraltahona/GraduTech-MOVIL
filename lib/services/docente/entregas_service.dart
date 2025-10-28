import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_movil/models/entrega_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EntregaService {
  final String baseUrl = dotenv.env['IP'] ?? 'http://localhost:5001';

 Future<List<Entrega>> obtenerEntregasPorPlan(int idPlanEntrega) async {
  try {
    debugPrint('🔍 Iniciando solicitud para plan: $idPlanEntrega');
    
    final response = await http.get(
      Uri.parse('$baseUrl/entrega/entrega-por-plan/$idPlanEntrega'),
    );
    
    debugPrint('📦 Status Code: ${response.statusCode}');
    debugPrint('📦 Respuesta recibida: ${response.body}');
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      debugPrint('📦 JSON decodificado: $jsonResponse');
      
      // Verifica que no sea null
      if (jsonResponse == null) {
        debugPrint('❌ JSON response es NULL');
        return [];
      }
      
      final entregas = jsonResponse.map((json) {
        debugPrint('📦 Procesando entrega: $json');
        return Entrega.fromJson(json);
      }).toList();
      
      debugPrint('✅ Entregas procesadas: ${entregas.length}');
      return entregas;
    } else {
      throw Exception('Error al cargar entregas: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('❌ Error en obtenerEntregasPorPlan: $e');
    rethrow;
  }
}

  Future<void> enviarRetroalimentacion({
    required int idEntrega,
    required String retroalimentacion,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/entrega/$idEntrega/retroalimentacion'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'retroalimentacion': retroalimentacion,
        'ruta_documento': '',
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al enviar retroalimentación: ${response.statusCode}');
    }
  }
}
