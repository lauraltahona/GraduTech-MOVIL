import 'package:flutter/material.dart';
import 'package:proyecto_movil/models/jurado_model.dart';
import 'package:proyecto_movil/models/proyecto_model.dart';
import 'package:proyecto_movil/services/estudiante/proyecto_service.dart';

class RevisionJuradoController extends ChangeNotifier {
  final ProyectoService _service = ProyectoService();

  Proyecto? proyecto;
  List<Jurado> jurados = [];
  bool cargando = true;

  Future<void> cargarDatos(int idUsuario) async {
    cargando = true;
    notifyListeners();

    Proyecto? proyectoObtenido = await _service.obtenerMiProyecto(idUsuario);

    if (proyectoObtenido == null) {
      cargando = false;
      notifyListeners();
      return; 
    }

    proyecto = proyectoObtenido;

    if (proyecto!.idJurado == null) {
      jurados = [
        Jurado(
          name: "No tienes jurado asignado",
          role: "-",
          specialty: "-",
          status: "Pendiente",
        )
      ];
    } else {
      Jurado? jurado = await _service.obtenerJurado(proyecto!.idJurado!);
      jurados = jurado != null
          ? [jurado]
          : [
              Jurado(
                name: "Error al cargar jurado",
                role: "-",
                specialty: "-",
                status: "Pendiente",
              )
            ];
    }

    cargando = false;
    notifyListeners();
  }

  Future<void> autorizarProyecto(BuildContext context) async {
    if (proyecto == null) return;

    bool exito = await _service.enviarAutorizacion(proyecto!.idProyecto);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          exito
              ? '✅ Autorización enviada con éxito'
              : '❌ Error al enviar autorización',
        ),
        backgroundColor: exito ? Colors.green : Colors.red,
      ),
    );
  }
}
