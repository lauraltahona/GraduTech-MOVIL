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
      backgroundColor: const Color(0xFFE8F5E9), // Verde suave de fondo
      body: controller.cargando
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2E7D32), // Verde oscuro
              ),
            )
          : controller.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Color(0xFFFF6F00), // Naranja
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.error!,
                        style: const TextStyle(color: Color(0xFF424242)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _cargarProyecto,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : controller.proyecto == null
                  ? const Center(
                      child: Text(
                        "No se encontró proyecto.",
                        style: TextStyle(color: Color(0xFF424242)),
                      ),
                    )
                  : MiProyectoCard(
                      proyecto: controller.proyecto!,
                      fechaFormateada: controller.formatearFecha(
                        controller.proyecto!['updatedAt'] ?? 
                        controller.proyecto!['createdAt'],
                      ),
                      onEditar: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Función de editar en desarrollo'),
                            backgroundColor: Color(0xFF2E7D32),
                          ),
                        );
                      },
                    ),
    );
  }
}