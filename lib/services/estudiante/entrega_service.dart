import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:flutter/material.dart';

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

  /// 📤 SUBIR ARCHIVO A CLOUDINARY
  Future<String> subirArchivo(File archivo) async {
    try {
      final url = Uri.parse("$baseUrl/cloudinary/upload");
      
      debugPrint('🔄 Iniciando subida de archivo: ${archivo.path}');
      
      // Detectar el MIME type
      final mimeType = lookupMimeType(archivo.path) ?? 'application/octet-stream';
      final mimeTypeData = mimeType.split('/');

      // Crear request multipart
      var request = http.MultipartRequest('POST', url);
      
      // Agregar el archivo
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // ⚠️ Debe coincidir con req.files.file en backend
          archivo.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ),
      );

      debugPrint('📤 Enviando archivo al servidor...');
      
      // Enviar request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('📦 Respuesta recibida: ${response.statusCode}');
      debugPrint('📦 Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // ✅ Cloudinary devuelve la URL completa
        final fileUrl = data['fileUrl'];
        
        if (fileUrl == null || fileUrl.isEmpty) {
          throw Exception('El servidor no devolvió una URL válida');
        }
        
        debugPrint('✅ Archivo subido correctamente: $fileUrl');
        return fileUrl;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Error al subir archivo');
      }
    } catch (e) {
      debugPrint('❌ Error en subirArchivo: $e');
      throw Exception("Error al subir archivo: ${e.toString()}");
    }
  }

  /// 💾 GUARDAR ENTREGA EN LA BASE DE DATOS
  Future<Map<String, dynamic>> subirEntrega({
    required int idPlanEntrega,
    required int idUsuario,
    required String descripcion,
    required String rutaDocumento, // URL de Cloudinary
    required String correoDocente,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/entrega/subir");

      debugPrint('💾 Guardando entrega en BD...');
      debugPrint('  - idPlanEntrega: $idPlanEntrega');
      debugPrint('  - idUsuario: $idUsuario');
      debugPrint('  - rutaDocumento: $rutaDocumento');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id_plan_entrega': idPlanEntrega,
          'id_usuario': idUsuario,
          'descripcion': descripcion,
          'ruta_documento': rutaDocumento, // URL de Cloudinary
          'correo_docente': correoDocente,
        }),
      );

      debugPrint('📦 Respuesta BD: ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('✅ Entrega guardada exitosamente');
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Error al guardar entrega');
      }
    } catch (e) {
      debugPrint('❌ Error en subirEntrega: $e');
      throw Exception("Error al subir entrega: ${e.toString()}");
    }
  }
}