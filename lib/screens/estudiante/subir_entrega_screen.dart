import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_movil/controllers/estudiante/subir_entrega_controller.dart';
import 'package:proyecto_movil/widgets/estudiante/formulario_subir_entrega.dart';
import 'package:proyecto_movil/widgets/estudiante/lista_entregas_anteriores.dart';

class SubirEntregaScreen extends StatefulWidget {
  final int idPlanEntrega;
  final DateTime fechaLimite;

  const SubirEntregaScreen({
    super.key,
    required this.idPlanEntrega,
    required this.fechaLimite,
  });

  @override
  State<SubirEntregaScreen> createState() => _SubirEntregaScreenState();
}

class _SubirEntregaScreenState extends State<SubirEntregaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubirEntregaController>().cargarEntregasPorPlan(widget.idPlanEntrega);
    });
  }

  @override
  void dispose() {
    context.read<SubirEntregaController>().limpiarTodo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subir Entrega'),
        backgroundColor: Colors.green,
      ),
      body: Consumer<SubirEntregaController>(
        builder: (context, controller, child) {
          if (controller.isLoadingEntregas) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.entregasAnteriores.isNotEmpty) {
            return ListaEntregasAnteriores(
              entregas: controller.entregasAnteriores,
            );
          }

          return FormularioSubirEntrega(
            idPlanEntrega: widget.idPlanEntrega,
            fechaLimite: widget.fechaLimite,
          );
        },
      ),
    );
  }
}