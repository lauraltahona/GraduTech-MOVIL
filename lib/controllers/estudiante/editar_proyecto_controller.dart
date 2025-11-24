import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:proyecto_movil/services/estudiante/proyecto_service.dart';

class EditarProyectoController {
  final titleController = TextEditingController();
  final descripcionController = TextEditingController();
  File? archivoSeleccionado;
  final ProyectoService api = ProyectoService();

  Future<void> seleccionarArchivo(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        archivoSeleccionado = File(result.files.single.path!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Archivo seleccionado correctamente ✅')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar el archivo: $e')),
      );
    }
  }

  Future<void> editarProyecto(BuildContext context) async {
    if (titleController.text.isEmpty ||
        descripcionController.text.isEmpty ||
        archivoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos y sube un archivo'),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final idProyecto = prefs.getInt('idProyecto');

    print('ID del proyecto a editar: $idProyecto');
    if (idProyecto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo habilitar la edición del proyecto')),
      );
      return;
    }

    final exito = await api.editarProyecto(
      titulo: titleController.text,
      descripcion: descripcionController.text,
      archivo: archivoSeleccionado!,
      idProyecto: idProyecto,
    );

    print('Resultado de la edición del proyecto: $exito');

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proyecto editado exitosamente 🎉')),
      );
      limpiarCampos();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al editar el proyecto 😢')),
      );
    }
  }

  void limpiarCampos() {
    titleController.clear();
    descripcionController.clear();
    archivoSeleccionado = null;
  }

  Future<void> abrirDocumentoEnNavegador(String rutaDocumento) async {
    try {
      final Uri url = Uri.parse(rutaDocumento);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('No se pudo abrir el documento');
      }
    } catch (e) {
      debugPrint('Error al abrir documento: $e');
    }
  }
}
