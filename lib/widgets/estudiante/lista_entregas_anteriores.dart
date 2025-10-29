import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class ListaEntregasAnteriores extends StatelessWidget {
  final List<Map<String, dynamic>> entregas;

  const ListaEntregasAnteriores({
    super.key,
    required this.entregas,
  });

  Future<void> _abrirDocumento(String ruta) async {
    final url = ruta.startsWith('http') 
          ? Uri.parse(ruta)
          : Uri.parse('${dotenv.env['IP']}$ruta'); 
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Entregas para este plan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          ...entregas.map((entrega) {
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'titulo: ${entrega['titulo']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Fecha Envío:',
                      dateFormat.format(DateTime.parse(entrega['fecha_envio'])),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Descripción:',
                      entrega['descripcion'] ?? 'Sin descripción',
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => _abrirDocumento(entrega['ruta_documento']),
                      icon: const Icon(Icons.description),
                      label: const Text('Ver documento'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    if (entrega['retroalimentacion'] != null) ...[
                      const Divider(height: 24),
                      _buildInfoRow(
                        'Retroalimentación:',
                        entrega['retroalimentacion'],
                      ),
                    ],
                    if (entrega['ruta_retroalimentacion'] != null) ...[
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => _abrirDocumento(
                          entrega['ruta_retroalimentacion'],
                        ),
                        icon: const Icon(Icons.feedback),
                        label: const Text('Ver documento de retroalimentación'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}