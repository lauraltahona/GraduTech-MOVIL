import 'package:flutter/material.dart';
import 'package:proyecto_movil/services/jurado/proyectos_asignados_service.dart';
import 'package:proyecto_movil/models/proyecto_asignado_model.dart';

class ProyectosAsignadosControllerJurado extends ChangeNotifier {
  final ProyectosAsignadosService _service = ProyectosAsignadosService();
  
  List<ProyectoAsignado> proyectos = [];
  bool cargando = false;
  String? error;
  String? mensaje;

   Future<void> cargarProyectos(int idUsuario) async {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      final data = await _service.obtenerProyectosAsignados(idUsuario);
      final todosLosProyectos = data.map((json) => ProyectoAsignado.fromJson(json)).toList();
      
      // ✅ Filtrar solo los APROBADO POR DOCENTE
      proyectos = todosLosProyectos
          .where((proyecto) => proyecto.estado == "APROBADO POR DOCENTE")
          .toList();
          
    } catch (e) {
      error = e.toString();
      debugPrint('Error al cargar proyectos: $e');
    } finally {
      cargando = false;
      
      notifyListeners();
    }
  }

  Future<void> cambiarEstado(int idProyecto, String nuevoEstado) async {
    try {
      final exito = await _service.cambiarEstadoProyecto(idProyecto, nuevoEstado);
      
      if (exito) {
        // Actualizar localmente
        proyectos = proyectos.map((p) {
          if (p.idProyecto == idProyecto) {
            return p.copyWith(estado: nuevoEstado);
          }
          return p;
        }).toList();
        
        mensaje = 'Estado actualizado correctamente';
        notifyListeners();
      }
    } catch (e) {
      error = 'Error al cambiar estado: $e';
      notifyListeners();
    }
  }

  void limpiarMensaje() {
    mensaje = null;
    notifyListeners();
  }
}