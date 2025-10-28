// widgets/docente/entrega_card.dart
import 'package:flutter/material.dart';
import 'package:proyecto_movil/models/entrega_model.dart';

class EntregaCard extends StatelessWidget {
  final Entrega entrega;
  final VoidCallback onToggleRetro;
  final bool isFormVisible;
  final Function(String) onComentarioChange;
  final String comentario;
  final String estadoRetro;
  final VoidCallback onEnviarRetro;

  const EntregaCard({
    super.key,
    required this.entrega,
    required this.onToggleRetro,
    required this.isFormVisible,
    required this.onComentarioChange,
    required this.comentario,
    required this.estadoRetro,
    required this.onEnviarRetro,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información de la entrega
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📅 ${_formatearFecha(entrega.fechaEnvio)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '📝 ${entrega.descripcion}',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text(
                          'Estudiante ${entrega.idEstudiante}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.blue[700],
                      ),
                    ],
                  ),
                ),
                if (entrega.rutaDocumento.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      // Abrir documento
                      _abrirDocumento(context, entrega.rutaDocumento);
                    },
                    icon: const Icon(Icons.document_scanner, color: Colors.green),
                    tooltip: 'Ver documento',
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Retroalimentación existente
            if (entrega.retroalimentacion != null && entrega.retroalimentacion!.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📝 Retroalimentación dada:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(entrega.retroalimentacion!),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Botón de retroalimentación
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onToggleRetro,
                icon: Icon(isFormVisible ? Icons.close : Icons.comment),
                label: Text(isFormVisible ? 'Cancelar' : '💬 Agregar retroalimentación'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormVisible ? Colors.grey : Colors.green[700],
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            // Formulario de retroalimentación
            if (isFormVisible) _buildRetroForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildRetroForm() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Agregar Retroalimentación',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Comentario:',
              border: OutlineInputBorder(),
              hintText: 'Escribe tu retroalimentación aquí...',
            ),
            onChanged: onComentarioChange,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: onEnviarRetro,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                ),
                child: const Text('Guardar retroalimentación'),
              ),
              const SizedBox(width: 12),
              if (estadoRetro.isNotEmpty)
                Text(
                  estadoRetro,
                  style: TextStyle(
                    color: estadoRetro.contains('✅') 
                        ? Colors.green 
                        : estadoRetro.contains('❌') 
                            ? Colors.red 
                            : Colors.orange,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  void _abrirDocumento(BuildContext context, String rutaDocumento) {
    final url = 'http://localhost:5001$rutaDocumento';
    // Aquí puedes usar url_launcher para abrir el enlace
    // o mostrar un diálogo con opciones
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Documento'),
        content: Text('Abrir: $url'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implementar apertura de URL
              Navigator.pop(context);
            },
            child: const Text('Abrir en navegador'),
          ),
        ],
      ),
    );
  }
}