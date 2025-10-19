import 'package:flutter/material.dart';

class CalendarioCard extends StatelessWidget {
  final DateTime fechaSeleccionada;
  final String descripcion;

  const CalendarioCard({
    super.key,
    required this.fechaSeleccionada,
    required this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "${fechaSeleccionada.day}/${fechaSeleccionada.month}/${fechaSeleccionada.year}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              descripcion,
              style: TextStyle(
                fontSize: 16,
                color: Colors.green.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
