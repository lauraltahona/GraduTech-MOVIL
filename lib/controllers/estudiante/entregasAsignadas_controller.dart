import 'package:flutter/material.dart';
import 'package:proyecto_movil/services/estudiante/entrega_service.dart';

class EntregasController extends ChangeNotifier {
  final EntregaService _service = EntregaService();
  
  List<Map<String, dynamic>> entregas = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> cargarEntregas(int idUsuario) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      entregas = await _service.obtenerEntregasAsignadas(idUsuario);
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("Error al cargar entregas: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void limpiar() {
    entregas = [];
    errorMessage = '';
    isLoading = false;
    notifyListeners();
  }
}