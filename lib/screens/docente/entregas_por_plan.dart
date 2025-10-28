// screens/docente/entregas_plan_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_movil/controllers/docente/entregas_plan_controller.dart';
import 'package:proyecto_movil/widgets/docente/entregas_por_plan_card.dart';

class EntregasPlanScreen extends StatefulWidget {
  final int idPlanEntrega;

  const EntregasPlanScreen({
    super.key,
    required this.idPlanEntrega,
  });

  @override
  State<EntregasPlanScreen> createState() => _EntregasPlanScreenState();
}

class _EntregasPlanScreenState extends State<EntregasPlanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EntregasPlanController>().cargarEntregas(widget.idPlanEntrega);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('📋 Entregas - Plan #${widget.idPlanEntrega}'),
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
        ),
        body: Consumer<EntregasPlanController>(
          builder: (context, controller, child) {
            // Mostrar mensajes
            if (controller.mensaje != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(controller.mensaje!),
                    backgroundColor: Colors.green,
                  ),
                );
                controller.limpiarMensaje();
              });
            }

            if (controller.cargando) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.green),
              );
            }

            if (controller.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar entregas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => controller.cargarEntregas(widget.idPlanEntrega),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (controller.entregas.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay entregas para este plan',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lista de entregas
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.entregas.length,
                    itemBuilder: (context, index) {
                      final entrega = controller.entregas[index];
                      return EntregaCard(
                        entrega: entrega,
                        onToggleRetro: () => controller.toggleFormRetro(entrega.idEntrega),
                        isFormVisible: controller.isFormVisible(entrega.idEntrega),
                        onComentarioChange: (comentario) => 
                            controller.setComentario(entrega.idEntrega, comentario),
                        comentario: controller.getComentario(entrega.idEntrega),
                        estadoRetro: controller.getEstadoRetro(entrega.idEntrega),
                        onEnviarRetro: () => controller.enviarRetroalimentacion(entrega.idEntrega),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      );
  }
}