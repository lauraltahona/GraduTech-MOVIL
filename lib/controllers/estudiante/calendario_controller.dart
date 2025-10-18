import 'package:flutter/material.dart';
import 'package:proyecto_movil/services/entrega_service.dart';

class CalendarioController extends ChangeNotifier {
  final EntregaService _service = EntregaService();

  List<Map<String, dynamic>> fechasImportantes = [];
  DateTime? fechaSeleccionada;

  Future<void> cargarFechas(int idUsuario) async {
    try {
      fechasImportantes = await _service.obtenerFechasEntregas(idUsuario);
      notifyListeners();
    } catch (e) {
      debugPrint("Error al cargar entregas: $e");
    }
  }

  bool esMismaFecha(DateTime f1, DateTime f2) =>
      f1.year == f2.year && f1.month == f2.month && f1.day == f2.day;

  Map<String, dynamic>? obtenerEntrega(DateTime fecha) {
    try {
      return fechasImportantes.firstWhere(
        (f) => esMismaFecha(f['fecha'], fecha),
      );
    } catch (_) {
      return null;
    }
  }
}
