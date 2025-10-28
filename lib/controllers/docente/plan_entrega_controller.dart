import 'package:flutter/material.dart';
import 'package:proyecto_movil/models/plan_entrega_model.dart';
import 'package:proyecto_movil/services/docente/plan_entrega_service.dart';

class PlanEntregaController extends ChangeNotifier {
  final PlanEntregaService _service = PlanEntregaService();
  
  List<PlanEntrega> planes = [];
  bool cargando = false;
  String? error;
  String? mensaje;

  // Campos del formulario
  final nroEntregaController = TextEditingController();
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  DateTime? fechaLimite;

  Future<void> cargarPlanes(int idProyecto) async {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      final data = await _service.obtenerPlanesPorProyecto(idProyecto);
      planes = data.map((json) => PlanEntrega.fromJson(json)).toList();
      
      // Ordenar por número de entrega
      planes.sort((a, b) => a.nroEntrega.compareTo(b.nroEntrega));
    } catch (e) {
      error = e.toString();
      debugPrint('Error al cargar planes: $e');
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<bool> crearPlanEntrega({
    required int idProyecto,
    required String correoEstudiante,
  }) async {
    // Validar campos
    if (nroEntregaController.text.isEmpty ||
        tituloController.text.isEmpty ||
        descripcionController.text.isEmpty ||
        fechaLimite == null) {
      mensaje = '⚠️ Por favor completa todos los campos';
      notifyListeners();
      return false;
    }

    try {
      final nuevoPlan = {
        'id_proyecto': idProyecto,
        'nro_entrega': int.parse(nroEntregaController.text),
        'titulo': tituloController.text.trim(),
        'descripcion': descripcionController.text.trim(),
        'fecha_limite': fechaLimite!.toIso8601String(),
        'correo': correoEstudiante,
      };

      final exito = await _service.crearPlanEntrega(nuevoPlan);

      if (exito) {
        mensaje = '✅ Plan de entrega creado con éxito';
        limpiarFormulario();
        await cargarPlanes(idProyecto); // Recargar lista
        return true;
      } else {
        mensaje = '❌ Error al crear el plan de entrega';
        return false;
      }
    } catch (e) {
      error = e.toString();
      mensaje = '❌ Error: $e';
      notifyListeners();
      return false;
    }
  }

  void setFechaLimite(DateTime fecha) {
    fechaLimite = fecha;
    notifyListeners();
  }

  void limpiarFormulario() {
    nroEntregaController.clear();
    tituloController.clear();
    descripcionController.clear();
    fechaLimite = null;
    notifyListeners();
  }

  void limpiarMensaje() {
    mensaje = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nroEntregaController.dispose();
    tituloController.dispose();
    descripcionController.dispose();
    super.dispose();
  }
}