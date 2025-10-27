import 'package:flutter/material.dart';
import 'package:proyecto_movil/services/docente/entregas_service.dart';

class EntregasController extends ChangeNotifier {
  final EntregasService _service = EntregasService();
  List<dynamic> entregas = [];
  bool cargando = false;
  String? error;

  Future<void> cargarEntregas(int idPlanEntrega) async {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      entregas = await _service.obtenerEntregasPorPlan(idPlanEntrega);
    } catch (e) {
      error = e.toString();
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> enviarRetroalimentacion(int idEntrega, String comentario, String? filePath) async {
    try {
      String? rutaArchivo;
      if (filePath != null) {
        rutaArchivo = await _service.subirArchivo(filePath);
      }
      await _service.guardarRetroalimentacion(idEntrega, comentario, rutaArchivo);
      await cargarEntregas(entregas.first['id_plan_entrega']);
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}
