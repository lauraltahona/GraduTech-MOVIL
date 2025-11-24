import 'package:flutter/material.dart';
import 'package:proyecto_movil/models/proyecto_asignado_model.dart';

class ProyectoAsignadoCard extends StatelessWidget {
  final ProyectoAsignado proyecto;
  final Function(String) onCambiarEstado;
  final VoidCallback onPlanearEntrega;
  final VoidCallback onProgramarReunion;

  const ProyectoAsignadoCard({
    super.key,
    required this.proyecto,
    required this.onCambiarEstado,
    required this.onPlanearEntrega,
    required this.onProgramarReunion,
  });

  Color _getEstadoColor() {
    switch (proyecto.estado) {
      case "APROBADO POR DOCENTE":
        return Colors.green;
      case "EN REVISIÓN":
        return Colors.blue;
      case "RECHAZADO":
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[50], // Lighter background
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    proyecto.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getEstadoColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getEstadoColor(), width: 1.5),
                  ),
                  child: Text(
                    proyecto.estado,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _getEstadoColor(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.person, size: 20, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      proyecto.estudiante,
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onPlanearEntrega,
                  icon: const Icon(Icons.upload_file, size: 18),
                  label: const Text('Planear entrega'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onProgramarReunion,
                  icon: const Icon(Icons.event, size: 18),
                  label: const Text('Programar Reunión'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[100]!, Colors.green[50]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade400, width: 1.5),
              ),
              child: Row(
                children: [
                  Icon(Icons.sync_alt, size: 18, color: Colors.green[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<String>(
                      value: proyecto.estado,
                      isExpanded: true,
                      underline: const SizedBox(),
                      dropdownColor: Colors.green[50],
                      icon: Icon(Icons.arrow_drop_down, color: Colors.green[700]),
                      style: TextStyle(
                        color: Colors.green[900],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "PENDIENTE",
                          child: Text("PENDIENTE"),
                        ),
                        DropdownMenuItem(
                          value: "EN REVISIÓN",
                          child: Text("EN REVISIÓN"),
                        ),
                        DropdownMenuItem(
                          value: "APROBADO POR DOCENTE",
                          child: Text("APROBADO POR DOCENTE"),
                        ),
                        DropdownMenuItem(
                          value: "RECHAZADO",
                          child: Text("RECHAZADO"),
                        ),
                        DropdownMenuItem(
                          value: "APROBADO",
                          child: Text("APROBADO"),
                        ),
                      ],
                      onChanged: (nuevoEstado) {
                        if (nuevoEstado != null && nuevoEstado != proyecto.estado) {
                          onCambiarEstado(nuevoEstado);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
