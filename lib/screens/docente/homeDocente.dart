import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_movil/controllers/docente/entregas_controller.dart';
import 'package:proyecto_movil/screens/docente/entregas_pages.dart';


class HomeDocente extends StatelessWidget {
  const HomeDocente({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio - Docente'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Bienvenido, Docente 👨‍🏫',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Desde aquí podrás gestionar tus estudiantes, revisar entregas y dar retroalimentación.',
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.assignment_turned_in),
              label: const Text("Ver Entregas"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider(
                      create: (_) =>
                          EntregasController()..cargarEntregas(1), // Ejemplo de idPlanEntrega
                      child: const EntregasPage(idPlanEntrega: 1),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
