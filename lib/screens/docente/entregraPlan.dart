import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_movil/widget/entrega_card.dart';
import '../../controllers/entregas_controller.dart';

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
    Future.microtask(() {
      context.read<EntregasController>().cargarEntregas(widget.idPlanEntrega);
    });
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
              : ListView.builder(
                  itemCount: controller.entregas.length,
                  itemBuilder: (context, index) {
                    final entrega = controller.entregas[index];
                    return EntregaCard(
                      entrega: entrega,
                      onRetroalimentar: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Agregar retroalimentación"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: comentarioController,
                                  decoration: const InputDecoration(
                                    labelText: "Comentario",
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                ),
                              ],
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
                                  controller.enviarRetroalimentacion(
                                    entrega['idEntrega'],
                                    comentarioController.text,
                                    null,
                                  );
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
