import 'package:flutter/material.dart';
import 'package:proyecto_movil/services/docente/plan_entrega_service.dart';

class PlanEntregaController extends ChangeNotifier {
  final PlanEntregaService _service = PlanEntregaService();
  List<dynamic> planes = [];
  bool cargando = false;
  String? error;

  Future<void> cargarPlanes(int idProyecto) async {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      planes = await _service.obtenerPlanesPorProyecto(idProyecto);
    } catch (e) {
      error = e.toString();
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<bool> crearPlanEntrega(Map<String, dynamic> nuevoPlan) async {
    try {
      return await _service.crearPlanEntrega(nuevoPlan);
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
