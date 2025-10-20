import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RepositorioService {
  final String baseUrl = dotenv.env['IP'] ?? ''; 

  Future<void> obtenerProyectosPorTipo(String tipo) async {
    final url = Uri.parse('$baseUrl/mostrarProyectosRepositorio?tipo=$tipo');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('✅ Datos recibidos correctamente');
      // Aquí podrías decodificar el JSON si deseas usar los datos
    } else {
      throw Exception('❌ Error al obtener los proyectos del repositorio');
    }
  }
}
