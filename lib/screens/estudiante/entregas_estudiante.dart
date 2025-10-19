import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_movil/controllers/estudiante/entregasAsignadas_controller.dart';
import 'package:proyecto_movil/widgets/estudiante/entregas_card.dart';

class EntregasEstudianteScreen extends StatefulWidget {
  final int idUsuario;

  const EntregasEstudianteScreen({
    super.key,
    required this.idUsuario,
  });

  @override
  State<EntregasEstudianteScreen> createState() =>
      _EntregasEstudianteScreenState();
}

class _EntregasEstudianteScreenState extends State<EntregasEstudianteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EntregasController>().cargarEntregas(widget.idUsuario);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EntregasController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${controller.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.cargarEntregas(widget.idUsuario);
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (controller.entregas.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No tienes entregas asignadas',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.cargarEntregas(widget.idUsuario),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.entregas.length,
              itemBuilder: (context, index) {
                return EntregaCard(
                  entrega: controller.entregas[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}