// controllers/docente/entregas_plan_controller.dart
import 'package:flutter/material.dart';
import 'package:proyecto_movil/models/entrega_model.dart';
import 'package:proyecto_movil/services/docente/entregas_service.dart';

class EntregasPlanController extends ChangeNotifier {
  final EntregaService _entregaService = EntregaService();

  List<Entrega> _entregas = [];
  bool _cargando = false;
  String? _error;
  String? _mensaje;

  // Estados para formularios de retroalimentación
  final Map<int, bool> _mostrarFormRetro = {};
  final Map<int, String> _comentariosRetro = {};
  final Map<int, String> _estadosRetro = {};

  List<Entrega> get entregas => _entregas;
  bool get cargando => _cargando;
  String? get error => _error;
  String? get mensaje => _mensaje;

  // controllers/docente/entregas_plan_controller.dart
  Future<void> cargarEntregas(int idPlanEntrega) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('🔄 Cargando entregas para plan: $idPlanEntrega');
      _entregas = await _entregaService.obtenerEntregasPorPlan(idPlanEntrega);
      debugPrint('✅ Entregas cargadas: ${_entregas.length}');
    } catch (e) {
      debugPrint('❌ Error en cargarEntregas: $e');
      _error = "Error al cargar entregas: ${e.toString()}";
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  void toggleFormRetro(int idEntrega) {
    _mostrarFormRetro[idEntrega] = !(_mostrarFormRetro[idEntrega] ?? false);
    if (!(_mostrarFormRetro[idEntrega] ?? false)) {
      _comentariosRetro.remove(idEntrega);
      _estadosRetro.remove(idEntrega);
    }
    notifyListeners();
  }

  bool isFormVisible(int idEntrega) {
    return _mostrarFormRetro[idEntrega] ?? false;
  }

  void setComentario(int idEntrega, String comentario) {
    _comentariosRetro[idEntrega] = comentario;
  }

  String getComentario(int idEntrega) {
    return _comentariosRetro[idEntrega] ?? '';
  }

  String getEstadoRetro(int idEntrega) {
    return _estadosRetro[idEntrega] ?? '';
  }

  Future<void> enviarRetroalimentacion(int idEntrega) async {
    final comentario = _comentariosRetro[idEntrega];

    if (comentario == null || comentario.isEmpty) {
      _estadosRetro[idEntrega] = "Debes escribir un comentario";
      notifyListeners();
      return;
    }

    _estadosRetro[idEntrega] = "Guardando retroalimentación... ⏳";
    notifyListeners();

    try {
      await _entregaService.enviarRetroalimentacion(
        idEntrega: idEntrega,
        retroalimentacion: comentario,
      );

      // Actualizar la entrega localmente
      final index = _entregas.indexWhere((e) => e.idEntrega == idEntrega);
      if (index != -1) {
        _entregas[index] = _entregas[index].copyWith(
          retroalimentacion: comentario,
        );
      }

      _estadosRetro[idEntrega] = "✅ Retroalimentación guardada";
      _mostrarFormRetro[idEntrega] = false;
      _comentariosRetro.remove(idEntrega);

      _mensaje = "Retroalimentación guardada exitosamente";
    } catch (e) {
      _estadosRetro[idEntrega] = "❌ Error: ${e.toString()}";
    } finally {
      notifyListeners();
    }
  }

  void limpiarMensaje() {
    _mensaje = null;
    notifyListeners();
  }

  void limpiarEstados() {
    _mostrarFormRetro.clear();
    _comentariosRetro.clear();
    _estadosRetro.clear();
    notifyListeners();
  }
}
