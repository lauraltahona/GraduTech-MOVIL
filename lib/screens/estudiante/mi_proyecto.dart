import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_movil/controllers/estudiante/mi_proyecto_controller.dart';
import 'package:proyecto_movil/widgets/estudiante/mi_proyecto_card.dart';

class MiProyectoScreen extends StatefulWidget {
  final int idUsuario;

  const MiProyectoScreen({super.key, required this.idUsuario});

  @override
  State<MiProyectoScreen> createState() => _MiProyectoScreenState();
}

class _MiProyectoScreenState extends State<MiProyectoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarProyecto();
    });
  }

  Future<void> _cargarProyecto() async {
    await Provider.of<MiProyectoController>(
      context,
      listen: false,
    ).cargarProyecto(widget.idUsuario);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MiProyectoController>(context);

    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: controller.cargando
          ? const Center(child: CircularProgressIndicator())
          : controller.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(controller.error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _cargarProyecto,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : controller.proyecto == null
                  ? const Center(child: Text("No se encontró proyecto."))
                  : MiProyectoCard(
                      proyecto: controller.proyecto!,
                      fechaFormateada: controller.formatearFecha(
                        controller.proyecto!['updatedAt'] ?? 
                        controller.proyecto!['createdAt'],
                      ),
                      onEditar: () {
                        // Implementa la navegación a editar proyecto
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Función de editar en desarrollo'),
                          ),
                        );
                      },
                    ),
    );
  }
}