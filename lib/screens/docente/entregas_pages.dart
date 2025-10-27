import 'package:flutter/material.dart';
import 'package:proyecto_movil/widgets/docente/entrega_card.dart';

class EntregasPage extends StatelessWidget {
  final int idPlanEntrega;

  const EntregasPage({super.key, required this.idPlanEntrega});

  // Simulación de lista de entregas
  final List<Map<String, dynamic>> entregas = const [
    {'titulo': 'Entrega 1', 'descripcion': 'Descripción de la entrega 1'},
    {'titulo': 'Entrega 2', 'descripcion': 'Descripción de la entrega 2'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entregas del Plan $idPlanEntrega'),
        backgroundColor: Colors.green[700], // Verde intenso
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: entregas.length,
        itemBuilder: (context, index) {
          final entrega = entregas[index];
          return Card(
            color: Colors.green[100], // Fondo verde suave
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: EntregaCard(
                entrega: entrega,
                onRetroalimentar: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Retroalimentar: ${entrega['titulo']}'),
                      backgroundColor: Colors.green[700],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
