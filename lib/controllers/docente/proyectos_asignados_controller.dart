import 'package:flutter/material.dart';
import 'package:proyecto_movil/services/docente/proyectos_asignados_service.dart';
import 'package:proyecto_movil/models/proyecto_asignado_model.dart';

class ProyectosAsignadosController extends ChangeNotifier {
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
      proyectos = data.map((json) => ProyectoAsignado.fromJson(json)).toList();
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

  Future<bool> programarReunion({
    required String correo,
    required String fecha,
    required String hora,
    required String lugar,
  }) async {
    try {
      final exito = await _service.programarReunion(
        correo: correo,
        fecha: fecha,
        hora: hora,
        lugar: lugar,
      );

      if (exito) {
        mensaje = '✅ Reunión programada con éxito';
      } else {
        mensaje = '❌ Error al programar la reunión';
      }
      
      notifyListeners();
      return exito;
    } catch (e) {
      mensaje = '❌ Error de conexión con el servidor';
      notifyListeners();
      return false;
    }
  }

  void limpiarMensaje() {
    mensaje = null;
    notifyListeners();
  }
}