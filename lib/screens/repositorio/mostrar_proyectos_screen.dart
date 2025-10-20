import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_movil/controllers/repositorio/mostrar_proyecto_controller.dart';
import 'package:proyecto_movil/widgets/repositorio/proyecto_card.dart';

class MostrarProyectosScreen extends StatelessWidget {
  final String tipo;
  const MostrarProyectosScreen({super.key, required this.tipo});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MostrarProyectosController>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), 
      appBar: AppBar(
        title: Text(
          "Proyectos tipo: $tipo",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50), // Verde
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Header verde con título
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              'PROYECTOS TIPO: ${tipo.toUpperCase()}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Lista de proyectos
          Expanded(
            child: FutureBuilder(
              future: controller.cargarProyectos(tipo),
              builder: (context, snapshot) {
                if (controller.loading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: Color(0xFF4CAF50),
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Cargando proyectos...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.error != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEBEE),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Icon(
                              Icons.error_outline,
                              color: Color(0xFFD32F2F),
                              size: 64,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Error',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (controller.proyectos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Icons.folder_open,
                            color: Color(0xFF4CAF50),
                            size: 64,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Sin proyectos',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No hay proyectos aprobados para el tipo "$tipo"',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.proyectos.length,
                  itemBuilder: (context, index) {
                    final proyecto = controller.proyectos[index];
                    return ProyectoCard(proyecto: proyecto);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}