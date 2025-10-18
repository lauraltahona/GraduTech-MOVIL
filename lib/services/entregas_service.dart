import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EntregasService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:5001';

  Future<List<dynamic>> obtenerEntregasPorPlan(int idPlanEntrega) async {
    final url = Uri.parse('$baseUrl/entrega/entrega-por-plan/$idPlanEntrega');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener entregas');
    }
  }

  Future<String> subirArchivo(String filePath) async {
    final url = Uri.parse('$baseUrl/upload');
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    final res = await request.send();
    if (res.statusCode == 200) {
      final body = await res.stream.bytesToString();
      final data = json.decode(body);
      return data['fileUrl'];
    } else {
      throw Exception('Error al subir archivo');
    }
  }

  Future<void> guardarRetroalimentacion(int idEntrega, String comentario, String? rutaArchivo) async {
    final url = Uri.parse('$baseUrl/entrega/$idEntrega/retroalimentacion');
    final body = {
      "retroalimentacion": comentario,
      "ruta_documento": rutaArchivo ?? ""
    };

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al guardar retroalimentación');
    }
  }
}
