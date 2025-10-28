import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_movil/controllers/docente/plan_entrega_controller.dart';
import 'package:proyecto_movil/widgets/docente/formulario_plan_entrega.dart';
import 'package:proyecto_movil/widgets/docente/lista_planes_entrega.dart';

class PlanearEntregaScreen extends StatefulWidget {
  final int idProyecto;
  final String correoEstudiante;

  const PlanearEntregaScreen({
    super.key,
    required this.idProyecto,
    required this.correoEstudiante,
  });

  @override
  State<PlanearEntregaScreen> createState() => _PlanearEntregaScreenState();
}

class _PlanearEntregaScreenState extends State<PlanearEntregaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<PlanEntregaController>();
      controller.cargarPlanes(widget.idProyecto);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlanEntregaController(),
      child: Builder(
        builder: (context) {
          // Cargar planes cuando se crea el provider
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final controller = context.read<PlanEntregaController>();
            if (controller.planes.isEmpty && !controller.cargando) {
              controller.cargarPlanes(widget.idProyecto);
            }
          });

          return Scaffold(
            appBar: AppBar(
              title: const Text('📌 Planificación de Entregas'),
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
            ),
            body: Consumer<PlanEntregaController>(
              builder: (context, controller, child) {
                // Mostrar mensajes
                if (controller.mensaje != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(controller.mensaje!),
                        backgroundColor: controller.mensaje!.contains('✅')
                            ? Colors.green
                            : Colors.orange,
                      ),
                    );
                    controller.limpiarMensaje();
                  });
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Formulario
                      FormularioPlanEntrega(
                        idProyecto: widget.idProyecto,
                        correoEstudiante: widget.correoEstudiante,
                      ),

                      const SizedBox(height: 32),

                      // Lista de planes existentes
                      const Text(
                        'Planes de entrega ya creados:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (controller.cargando)
                        const Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        )
                      else if (controller.error != null)
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Error al cargar planes',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.error!,
                                style: TextStyle(color: Colors.grey[600]),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else if (controller.planes.isEmpty)
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No hay planes de entrega creados',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ListaPlanesEntrega(
                          planes: controller.planes,
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}