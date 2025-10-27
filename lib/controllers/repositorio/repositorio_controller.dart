import 'package:flutter/material.dart';
import '../../models/proyecto_model.dart';
import 'package:proyecto_movil/services/estudiante/proyecto_service.dart';
import 'package:proyecto_movil/screens/repositorio/detalle_repositorio.dart';

class RepositorioController extends ChangeNotifier {
  final ProyectoService _service = ProyectoService();
  List<Proyecto> proyectos = [];
  bool cargando = false;

  Future<void> cargarProyectos(String tipo) async {
    cargando = true;
    notifyListeners();
    try {
      proyectos = await _service.obtenerProyectos(tipo);
    } catch (e) {
      debugPrint("Error cargando proyectos: $e");
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  void irADetalleProyecto(BuildContext context, String tipo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleRepositorioScreen(tipo: tipo),
      ),
    );
  }
}
