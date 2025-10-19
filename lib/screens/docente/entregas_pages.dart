import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_movil/controllers/docente/entregas_controller.dart';
import 'package:proyecto_movil/widgets/docente/entrega_card.dart';

class EntregasPage extends StatelessWidget {
  final int idPlanEntrega;

  const EntregasPage({super.key, required this.idPlanEntrega});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<EntregasController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Entregas")),
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
                          builder: (context) => AlertDialog(
                            title: const Text('Retroalimentar entrega'),
                            content: const Text(
                              'Aquí podrías escribir tu retroalimentación para esta entrega.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cerrar'),
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

