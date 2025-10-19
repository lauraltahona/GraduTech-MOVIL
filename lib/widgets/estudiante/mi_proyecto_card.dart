import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class MiProyectoCard extends StatelessWidget {
  final Map<String, dynamic> proyecto;
  final String fechaFormateada;
  final VoidCallback onEditar;

  const MiProyectoCard({
    super.key,
    required this.proyecto,
    required this.fechaFormateada,
    required this.onEditar,
  });

  Future<void> _abrirDocumento(String? ruta) async {
    if (ruta == null) {
      return; // Salir si la ruta es null
    }
    
    final String baseUrl = dotenv.env['IP'] ?? '';
    final Uri url = Uri.parse('$baseUrl$ruta');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('No se pudo abrir el documento: $url');
      }
    } catch (e) {
      debugPrint('Error al abrir documento: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Encabezado
            Row(
              children: [
                const Icon(Icons.book, color: Colors.green, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        proyecto['title'] ?? 'Sin título',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const Text(
                        "Proyecto de Grado",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 10,
                  ),
                  child: Text(
                    proyecto['estado'] ?? 'Pendiente',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Descripción
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Descripción del Proyecto",
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              proyecto['descripcion'] ?? 'Sin descripción disponible.',
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 20),

            // Detalles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _detalle("Estudiante", "ID: ${proyecto['idEstudiante'] ?? 'N/A'}"),
                _detalle("Asesor", "ID: ${proyecto['idDocente'] ?? 'N/A'}"),
              ],
            ),

            const SizedBox(height: 20),

            // Documento final
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Documento Final",
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(Icons.description, color: Colors.green, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Documento del Proyecto",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Modificado: $fechaFormateada",
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.green),
                    onPressed: () {
                      final ruta = proyecto['rutaDocumento'] as String?;
                      if (ruta != null) {
                        _abrirDocumento(ruta);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No hay documento disponible"),
                          ),
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.download, color: Colors.green),
                    onPressed: () {
                      final ruta = proyecto['rutaDocumento'] as String?;
                      if (ruta != null) {
                        _abrirDocumento(ruta);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No hay documento disponible"),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Botón editar
            ElevatedButton.icon(
              onPressed: onEditar,
              icon: const Icon(Icons.edit),
              label: const Text("Editar Proyecto"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detalle(String titulo, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(valor, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}