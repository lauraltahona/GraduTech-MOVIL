import 'package:proyecto_movil/services/repositorio/repositorio_service.dart';
import 'package:flutter/material.dart';

class RepositorioController with ChangeNotifier {
  final RepositorioService _service = RepositorioService();

  Future<void> irADetalleProyecto(BuildContext context, String tipo) async {
    try {
      await _service.obtenerProyectosPorTipo(tipo);
      Navigator.pushNamed(
        context,
        '/mostrarProyectosRepositorio',
        arguments: {'tipo': tipo},
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar proyectos: $e')),
      );
    }
  }
}
