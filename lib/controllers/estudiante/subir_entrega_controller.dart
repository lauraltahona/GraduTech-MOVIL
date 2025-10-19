import 'dart:io';
import 'package:flutter/material.dart';
import 'package:proyecto_movil/services/estudiante/entrega_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubirEntregaController extends ChangeNotifier {
  final EntregaService _service = EntregaService();

  List<Map<String, dynamic>> entregasAnteriores = [];
  List<Map<String, dynamic>> archivosSubiendo = [];
  
  bool isLoading = false;
  bool isLoadingEntregas = false;
  bool isUploadingFile = false;
  String errorMessage = '';
  String descripcion = '';
  String? rutaDocumentoServidor;

  Future<void> cargarEntregasPorPlan(int idPlanEntrega) async {
    isLoadingEntregas = true;
    errorMessage = '';
    notifyListeners();

    try {
      entregasAnteriores = await _service.obtenerEntregasPorPlan(idPlanEntrega);
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("Error al cargar entregas anteriores: $e");
    } finally {
      isLoadingEntregas = false;
      notifyListeners();
    }
  }

  Future<void> subirArchivo(File archivo) async {
    final id = 'file-${DateTime.now().millisecondsSinceEpoch}';
    
    archivosSubiendo.add({
      'id': id,
      'name': archivo.path.split('/').last,
      'status': 'cargando',
      'file': archivo,
      'fileUrlServer': null,
    });
    
    isUploadingFile = true;
    notifyListeners();

    try {
      final fileUrl = await _service.subirArchivo(archivo);
      rutaDocumentoServidor = fileUrl;
      
      archivosSubiendo = archivosSubiendo.map((item) {
        if (item['id'] == id) {
          return {
            ...item,
            'status': 'subido',
            'fileUrlServer': fileUrl,
          };
        }
        return item;
      }).toList();
    } catch (e) {
      archivosSubiendo = archivosSubiendo.map((item) {
        if (item['id'] == id) {
          return {
            ...item,
            'status': 'error',
          };
        }
        return item;
      }).toList();
      debugPrint("Error al subir archivo: $e");
    } finally {
      isUploadingFile = false;
      notifyListeners();
    }
  }

  Future<bool> guardarEntrega(int idPlanEntrega, int idUsuario) async {
    if (descripcion.isEmpty || rutaDocumentoServidor == null) {
      errorMessage = 'Por favor completa todos los campos y sube un archivo.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final correoDocente = prefs.getString('correo_docente') ?? '';

      await _service.subirEntrega(
        idPlanEntrega: idPlanEntrega,
        idUsuario: idUsuario,
        descripcion: descripcion,
        rutaDocumento: rutaDocumentoServidor!,
        correoDocente: correoDocente,
      );

      limpiar();
      return true;
    } catch (e) {
      errorMessage = 'Error al subir entrega: $e';
      debugPrint("Error al guardar entrega: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setDescripcion(String value) {
    descripcion = value;
    notifyListeners();
  }

  void limpiar() {
    descripcion = '';
    rutaDocumentoServidor = null;
    archivosSubiendo = [];
    errorMessage = '';
    notifyListeners();
  }

  void limpiarTodo() {
    descripcion = '';
    rutaDocumentoServidor = null;
    archivosSubiendo = [];
    entregasAnteriores = [];
    errorMessage = '';
    isLoading = false;
    isLoadingEntregas = false;
    notifyListeners();
  }
}