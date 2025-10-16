import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/api_service.dart';

class RegistrarProyectoController {
  final titleController = TextEditingController();
  final idController = TextEditingController();
  final descripcionController = TextEditingController();
  String tipoProyecto = '';
  File? archivoSeleccionado;
  final ApiService api = ApiService();

  Future<void> seleccionarArchivo(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      archivoSeleccionado = File(result.files.single.path!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Archivo seleccionado: ${result.files.single.name}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se seleccionó ningún archivo')),
      );
    }
  }

  Future<void> subirProyecto(BuildContext context) async {
    if (titleController.text.isEmpty ||
        tipoProyecto.isEmpty ||
        idController.text.isEmpty ||
        descripcionController.text.isEmpty ||
        archivoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos y sube un archivo')),
      );
      return;
    }

    final exito = await api.registrarProyecto(
      titulo: titleController.text,
      tipoProyecto: tipoProyecto,
      idEstudiante: idController.text,
      descripcion: descripcionController.text,
      archivo: archivoSeleccionado!,
    );

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proyecto registrado exitosamente 🎉')),
      );
      limpiarCampos();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al registrar el proyecto 😢')),
      );
    }
  }

  void limpiarCampos() {
    titleController.clear();
    idController.clear();
    descripcionController.clear();
    tipoProyecto = '';
    archivoSeleccionado = null;
  }
}
