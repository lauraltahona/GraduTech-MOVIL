import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoProyectoScreen extends StatelessWidget {
  final dynamic proyecto;

  const InfoProyectoScreen({super.key, required this.proyecto});

  @override
  Widget build(BuildContext context) {
    if (proyecto == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalles del Proyecto')),
        body: const Center(
          child: Text('No se encontró la información del proyecto'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('📄 Detalles del Proyecto'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              '📌 Título: ${proyecto.titulo}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text('🧑‍🎓 Estudiante: ${proyecto.estudiante}'),
            const SizedBox(height: 8),
            Text('📂 Tipo: ${proyecto.tipo}'),
            const SizedBox(height: 8),
            Text('📊 Estado: ${proyecto.estado}'),
            const SizedBox(height: 8),
            Text('📧 Correo: ${proyecto.correo}'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                abrirDocumento(proyecto.rutaDocumento);
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Ver documento'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> abrirDocumento(String rutaDocumento) async {
    try {
      print('Intentando abrir: $rutaDocumento');
      final url = Uri.parse(rutaDocumento);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
          ),
        );
      } else {
        debugPrint('❌ No se puede abrir la URL');
      }
    } catch (e) {
      debugPrint('Error al abrir documento: $e');
    }
  }
}
