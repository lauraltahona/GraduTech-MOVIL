import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:proyecto_movil/controllers/estudiante/subir_entrega_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class FormularioSubirEntrega extends StatelessWidget {
  final int idPlanEntrega;
  final DateTime fechaLimite;

  const FormularioSubirEntrega({
    super.key,
    required this.idPlanEntrega,
    required this.fechaLimite,
  });

  Future<void> _seleccionarArchivo(BuildContext context) async {
    final controller = context.read<SubirEntregaController>();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      await controller.subirArchivo(file);
    }
  }

  Future<void> _guardarEntrega(BuildContext context) async {
    final controller = context.read<SubirEntregaController>();
    final prefs = await SharedPreferences.getInstance();
    final idUsuario = prefs.getInt('idUsuario');

    if (idUsuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Usuario no identificado')),
      );
      return;
    }

    final success = await controller.guardarEntrega(idPlanEntrega, idUsuario);

    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Entrega subida con éxito'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ahora = DateTime.now();
    final fechaPasada = ahora.isAfter(fechaLimite);

    return Consumer<SubirEntregaController>(
      builder: (context, controller, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Subir Entrega',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              if (fechaPasada)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '⚠️ ADVERTENCIA: La fecha límite ha pasado. Puedes enviar la evidencia, pero no podrás reclamar si tu docente demora en revisarla.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              TextField(
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Escribe una descripción',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => controller.setDescripcion(value),
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: () => _seleccionarArchivo(context),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green[50],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload, size: 48, color: Colors.green),
                      SizedBox(height: 8),
                      Text(
                        'Selecciona tu archivo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'PDF, Word',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (controller.archivosSubiendo.isNotEmpty)
                ...controller.archivosSubiendo.map((archivo) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.insert_drive_file),
                      title: Text(archivo['name']),
                      subtitle: _buildEstadoArchivo(archivo),
                    ),
                  );
                }),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: controller.isLoading || controller.isUploadingFile
                    ? null
                    : () => _guardarEntrega(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: controller.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Subir Entrega',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEstadoArchivo(Map<String, dynamic> archivo) {
    switch (archivo['status']) {
      case 'cargando':
        return const Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            Text('Cargando...', style: TextStyle(color: Colors.orange)),
          ],
        );
      case 'subido':
        final baseUrl = dotenv.env['IP'] ?? '';
        return GestureDetector(
          onTap: () async {
            final url = Uri.parse('$baseUrl${archivo['fileUrlServer']}');
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          },
          child: const Text(
            'Archivo subido - Ver archivo',
            style: TextStyle(
              color: Colors.green,
              decoration: TextDecoration.underline,
            ),
          ),
        );
      case 'error':
        return const Text(
          'Error al subir',
          style: TextStyle(color: Colors.red),
        );
      default:
        return const SizedBox();
    }
  }
}