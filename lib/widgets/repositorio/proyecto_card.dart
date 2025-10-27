import 'package:flutter/material.dart';
import 'package:proyecto_movil/models/proyecto_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProyectoCard extends StatelessWidget {
  final Proyecto proyecto;

  const ProyectoCard({Key? key, required this.proyecto}) : super(key: key);

  String _formatearFecha(String? fecha) {
    if (fecha == null) return 'Sin fecha';
    try {
      final DateTime dateTime = DateTime.parse(fecha);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return fecha;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Encabezado verde
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF00A651), // Verde del diseño
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Text(
              proyecto.titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Contenido
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Columna izquierda (texto)
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        proyecto.descripcion,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("Tipo: ${proyecto.tipo}",
                          style: const TextStyle(fontSize: 13)),
                      Text("Carrera: ${proyecto.carrera ?? 'N/A'}",
                          style: const TextStyle(fontSize: 13)),
                      Text("Fecha: ${_formatearFecha(proyecto.fecha)}",
                          style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Columna derecha (portada y botón)
                Column(
                  children: [
                    // Portada
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Image.asset(
                        'assets/repositorio/portada.png',
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Botón “Ver documento”
                    SizedBox(
                      width: 110,
                      child: ElevatedButton(
                        onPressed: () async {
                          final ruta = proyecto.rutaDocumento;
                          if (ruta == null || ruta.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No hay documento disponible.'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          final url = "${dotenv.env['IP']}$ruta";
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url),
                                mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('No se pudo abrir el documento.'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD700), // Amarillo
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 1,
                        ),
                        child: const Text(
                          "Ver documento",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
