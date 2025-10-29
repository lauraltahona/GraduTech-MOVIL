import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mime/mime.dart';

class ApiService {
  final String baseUrl = dotenv.env['IP'] ?? '';

  Future<Map<String, dynamic>> login(String correo, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuario/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'correo': correo, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Credenciales incorrectas');
    }
  }

  Future<String> subirArchivoACloudinary(File archivo) async {
    final url = Uri.parse("$baseUrl/cloudinary/upload");

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

    print('📡 Cloudinary response: ${response.statusCode}');
    print('🧾 Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);

      // Aceptar varias posibles claves
      final fileUrl = data['fileUrl'] ?? data['secure_url'] ?? data['url'];
      if (fileUrl == null || fileUrl.isEmpty) {
        throw Exception("El servidor no devolvió la URL del archivo");
      }
      return fileUrl;
    } else {
      throw Exception("Error al subir archivo a Cloudinary");
    }
  }

  Future<bool> registrarProyecto({
    required String titulo,
    required String tipoProyecto,
    required String idEstudiante,
    required String descripcion,
    required File archivo,
  }) async {
    try {
      final fileUrl = await subirArchivoACloudinary(archivo);
      print('✅ Archivo subido a: $fileUrl');

      final uri = Uri.parse('$baseUrl/proyectos');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': titulo,
          'tipo': tipoProyecto,
          'idEstudiante': idEstudiante,
          'descripcion': descripcion,
          'rutaDocumento': fileUrl,
        }),
      );

      print('📤 Respuesta del backend: ${response.statusCode}');
      print('📦 Body: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('❌ Error al registrar proyecto: $e');
      return false;
    }
  }
}
