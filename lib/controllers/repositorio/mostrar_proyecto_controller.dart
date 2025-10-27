import 'package:flutter/material.dart';
import 'package:proyecto_movil/services/estudiante/proyecto_service.dart';
import 'package:proyecto_movil/models/proyecto_model.dart';

class MostrarProyectosController extends ChangeNotifier {
  final ProyectoService _service = ProyectoService();
  List<Proyecto> proyectos = [];
  bool loading = true;
  String? error;

  Future<void> cargarProyectos(String tipo) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      proyectos = await _service.obtenerProyectos(tipo);
    } catch (e) {
      error = "Error al cargar los proyectos";
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
