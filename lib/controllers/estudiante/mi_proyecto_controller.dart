import 'package:flutter/material.dart';
import 'package:proyecto_movil/services/estudiante/proyecto_service.dart';

class MiProyectoController extends ChangeNotifier {
  final ProyectoService _service = ProyectoService();
  Map<String, dynamic>? proyecto;
  bool cargando = true;
  String? error;

  Future<void> cargarProyecto(int idUsuario) async {
    try {
      cargando = true;
      error = null;
      notifyListeners();
      proyecto = await _service.obtenerProyecto(idUsuario);
      cargando = false;
      notifyListeners();
    } catch (e) {
      cargando = false;
      error = "Error al obtener el proyecto: $e";
      notifyListeners();
    }
  }

  // Acepta valores nullable y maneja errores
  String formatearFecha(dynamic fecha) {
    if (fecha == null) return "Fecha no disponible";
    
    try {
      // Convierte a String si no lo es
      final fechaStr = fecha.toString();
      final date = DateTime.parse(fechaStr);
      return "${date.day.toString().padLeft(2, '0')}/${_nombreMes(date.month)} de ${date.year}";
    } catch (e) {
      return "Fecha inválida";
    }
  }

  String _nombreMes(int mes) {
    const meses = [
      "enero", "febrero", "marzo", "abril", "mayo", "junio",
      "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"
    ];
    return meses[mes - 1];
  }
}