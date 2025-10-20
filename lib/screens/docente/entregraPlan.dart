import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_movil/controllers/docente/entregas_controller.dart';
import 'package:proyecto_movil/widgets/docente/entrega_card.dart';

class EntregasPorPlanScreen extends StatefulWidget {
  final int idPlanEntrega;
  const EntregasPorPlanScreen({super.key, required this.idPlanEntrega});

  @override
  State<EntregasPorPlanScreen> createState() => _EntregasPorPlanScreenState();
}

class _EntregasPorPlanScreenState extends State<EntregasPorPlanScreen> {
  final comentarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargar las entregas después de que se construya el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EntregasController>().cargarEntregas(widget.idPlanEntrega);
    });
  }

  @override
  void dispose() {
    comentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EntregasController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Entregas del Plan"),
        backgroundColor: Colors.green[700],
      ),
      body: controller.cargando
          ? const Center(child: CircularProgressIndicator())
          : controller.error != null
              ? Center(child: Text(controller.error!))
              : controller.entregas.isEmpty
                  ? const Center(child: Text("No hay entregas registradas."))
                  : ListView.builder(
                      itemCount: controller.entregas.length,
                      itemBuilder: (context, index) {
                        final entrega = controller.entregas[index];
                        return EntregaCard(
                          entrega: entrega,
                          onRetroalimentar: () {
                            comentarioController.clear(); // limpiar antes de abrir
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Agregar retroalimentación"),
                                content: TextField(
                                  controller: comentarioController,
                                  decoration: const InputDecoration(
                                    labelText: "Comentario",
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("Cancelar"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    child: const Text("Guardar"),
                                    onPressed: () {
                                      final comentario =
                                          comentarioController.text.trim();
                                      if (comentario.isEmpty) return;

                                      controller.enviarRetroalimentacion(
                                        entrega['idEntrega'],
                                        comentario,
                                        null,
                                      );

                                      comentarioController.clear();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
    );
  }
}
