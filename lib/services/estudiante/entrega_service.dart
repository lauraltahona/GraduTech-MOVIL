import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

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

  Future<List<Map<String, dynamic>>> obtenerEntregasAsignadas(int idUsuario) async {
    final url = Uri.parse("$baseUrl/entrega/asignadas/$idUsuario");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception("Error al obtener las entregas");
    }
  }

  // NUEVOS MÉTODOS
  Future<List<Map<String, dynamic>>> obtenerEntregasPorPlan(int idPlanEntrega) async {
    final url = Uri.parse("$baseUrl/entrega/entrega-por-plan/$idPlanEntrega");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception("Error al obtener entregas anteriores");
    }
  }

  Future<String> subirArchivo(File archivo) async {
    final url = Uri.parse("$baseUrl/upload");
    
    final mimeType = lookupMimeType(archivo.path) ?? 'application/octet-stream';
    final mimeTypeData = mimeType.split('/');

    var request = http.MultipartRequest('POST', url);
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        archivo.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['fileUrl'];
    } else {
      throw Exception("Error al subir archivo");
    }
  }

  Future<Map<String, dynamic>> subirEntrega({
    required int idPlanEntrega,
    required int idUsuario,
    required String descripcion,
    required String rutaDocumento,
    required String correoDocente,
  }) async {
    final url = Uri.parse("$baseUrl/entrega/subir");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id_plan_entrega': idPlanEntrega,
        'id_usuario': idUsuario,
        'descripcion': descripcion,
        'ruta_documento': rutaDocumento,
        'correo_docente': correoDocente,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error al subir entrega");
    }
  }
}