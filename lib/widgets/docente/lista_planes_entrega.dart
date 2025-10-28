import 'package:flutter/material.dart';
import 'package:proyecto_movil/models/plan_entrega_model.dart';
import 'package:proyecto_movil/screens/docente/entregas_por_plan.dart';
import 'package:intl/intl.dart';

class ListaPlanesEntrega extends StatelessWidget {
  final List<PlanEntrega> planes;

  const ListaPlanesEntrega({
    super.key,
    required this.planes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: planes.map((plan) {
        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              // Navegar a la pantalla de entregas por plan
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EntregasPlanScreen(
                    idPlanEntrega: plan.idPlanEntrega!,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título con número de entrega
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[700],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Entrega #${plan.nroEntrega}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          plan.titulo,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Descripción
                  Text(
                    plan.descripcion,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Fecha límite
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Fecha límite: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(plan.fechaLimite),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}