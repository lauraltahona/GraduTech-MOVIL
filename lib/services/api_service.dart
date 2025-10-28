import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  Future<bool> registrarProyecto({
    required String titulo,
    required String tipoProyecto,
    required String idEstudiante,
    required String descripcion,
    required File archivo,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/proyectos/registrar'); // ajusta la ruta a tu backend CAMBIAAAAAAAR
      var request = http.MultipartRequest('POST', uri);

      // Campos normales
      request.fields['titulo'] = titulo;
      request.fields['tipoProyecto'] = tipoProyecto;
      request.fields['idEstudiante'] = idEstudiante;
      request.fields['descripcion'] = descripcion;

      // Archivo adjunto
      request.files.add(await http.MultipartFile.fromPath('archivo', archivo.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error al registrar proyecto: $e');
      return false;
    }
  }
}
