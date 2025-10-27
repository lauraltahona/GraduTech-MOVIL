import 'package:flutter/material.dart';
import 'package:proyecto_movil/services/estudiante/entrega_service.dart';
import 'package:proyecto_movil/services/notificacion/notificacion_service.dart';
class CalendarioController extends ChangeNotifier {
  final EntregaService _service = EntregaService();
  final NotificationService _notificationService = NotificationService();

  List<Map<String, dynamic>> fechasImportantes = [];
  DateTime? fechaSeleccionada;

  Future<void> cargarFechas(int idUsuario) async {
    try {
      fechasImportantes = await _service.obtenerFechasEntregas(idUsuario);
      
      // Programar notificaciones para cada entrega
      await programarNotificaciones();
      
      notifyListeners();
    } catch (e) {
      debugPrint("Error al cargar entregas: $e");
    }
  }

  Future<void> programarNotificaciones() async {
    // Cancelar notificaciones anteriores
    await _notificationService.cancelarTodasLasNotificaciones();

    // Programar nueva notificación para cada entrega
    for (var i = 0; i < fechasImportantes.length; i++) {
      final entrega = fechasImportantes[i];
      await _notificationService.programarNotificacionEntrega(
        id: i,
        titulo: 'Entrega Programada',
        descripcion: entrega['descripcion'],
        fechaEntrega: entrega['fecha'],
      );
    }

    debugPrint('✅ ${fechasImportantes.length} notificaciones programadas');
  }

  Future<void> verificarNotificacionesPendientes() async {
    final pendientes = await _notificationService.obtenerNotificacionesPendientes();
    debugPrint('📬 Notificaciones pendientes: ${pendientes.length}');
    for (var notif in pendientes) {
      debugPrint('  - ID: ${notif.id}, Título: ${notif.title}');
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