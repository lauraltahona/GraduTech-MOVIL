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

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[100],
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
            // Título del proyecto
            Text(
              proyecto.titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),

            // Información del estudiante
            Row(
              children: [
                const Icon(Icons.person, size: 18, color: Colors.green),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "Estudiante: ${proyecto.estudiante}",
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Estado
            Row(
              children: [
                const Icon(Icons.info_outline, size: 18, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  "Estado: ${proyecto.estado}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Botones de acción
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
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
                    backgroundColor: Colors.green[400],
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

            // Dropdown para cambiar estado
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: DropdownButton<String>(
                value: proyecto.estado,
                isExpanded: true,
                underline: const SizedBox(),
                dropdownColor: Colors.green[50],
                icon: const Icon(Icons.arrow_drop_down, color: Colors.green),
                style: const TextStyle(color: Colors.green, fontSize: 14),
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
    );
  }
}