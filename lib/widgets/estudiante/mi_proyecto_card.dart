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
    return SingleChildScrollView(
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con icono naranja - CORREGIDO
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE0B2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.school,
                      color: Color(0xFFFF6F00),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          proyecto['title'] ?? 'Sin título',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Proyecto de Grado",
                          style: TextStyle(
                            color: Color(0xFF757575),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Estado - Movido fuera del Row
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 14,
                  ),
                  child: Text(
                    proyecto['estado'] ?? 'Pendiente',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),

              // Descripción
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.description,
                          color: Color(0xFFFF6F00),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Descripción",
                          style: TextStyle(
                            color: Color(0xFF1B5E20),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      proyecto['descripcion'] ?? 'Sin descripción disponible.',
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        color: Color(0xFF424242),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Detalles
              Row(
                children: [
                  Expanded(
                    child: _detalle(
                      Icons.person,
                      "Estudiante",
                      "ID: ${proyecto['idEstudiante'] ?? 'N/A'}",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _detalle(
                      Icons.supervisor_account,
                      "Asesor",
                      "ID: ${proyecto['idDocente'] ?? 'N/A'}",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Documento
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFC5E1A5)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.insert_drive_file,
                        color: Color(0xFF2E7D32),
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Documento del Proyecto",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                          Text(
                            "Modificado: $fechaFormateada",
                            style: const TextStyle(
                              color: Color(0xFF757575),
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.visibility),
                      color: const Color(0xFFFF6F00),
                      onPressed: () => _abrirDocumento(proyecto['rutaDocumento']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.download),
                      color: const Color(0xFFFF6F00),
                      onPressed: () => _abrirDocumento(proyecto['rutaDocumento']),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Botón editar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onEditar,
                  icon: const Icon(Icons.edit),
                  label: const Text(
                    "Editar Proyecto",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detalle(IconData icono, String titulo, String valor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          Icon(icono, color: const Color(0xFFFF6F00), size: 24),
          const SizedBox(height: 6),
          Text(
            titulo,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            valor,
            style: const TextStyle(
              color: Color(0xFF757575),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}