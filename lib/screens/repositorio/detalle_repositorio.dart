import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/repositorio/repositorio_controller.dart';
import '../../widgets/repositorio/proyecto_card.dart';

class DetalleRepositorioScreen extends StatefulWidget {
  final String tipo;
  const DetalleRepositorioScreen({super.key, required this.tipo});

  @override
  State<DetalleRepositorioScreen> createState() => _DetalleRepositorioScreenState();
}

class _DetalleRepositorioScreenState extends State<DetalleRepositorioScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Provider.of<RepositorioController>(context, listen: false);
    controller.cargarProyectos(widget.tipo);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RepositorioController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Proyectos de ${widget.tipo}'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: controller.cargando
          ? const Center(child: CircularProgressIndicator())
          : controller.proyectos.isEmpty
              ? const Center(child: Text('No hay proyectos disponibles'))
              : ListView.builder(
                  itemCount: controller.proyectos.length,
                  itemBuilder: (context, index) {
                    final proyecto = controller.proyectos[index];
                    return ProyectoCard(proyecto: proyecto);
                  },
                ),
    );
  }
}
