import 'package:flutter/material.dart';

class EntregaCard extends StatelessWidget {
  final Map<String, dynamic> entrega;
  final VoidCallback onRetroalimentar;

  const EntregaCard({
    super.key,
    required this.entrega,
    required this.onRetroalimentar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.green[300],
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          entrega['titulo'],
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: ${entrega['fecha']}'),
            Text('Estado: ${entrega['estado']}'),
            Text('Comentario: ${entrega['comentario']}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.feedback, color: Colors.green[700]),
          onPressed: onRetroalimentar,
        ),
      ),
    );
  }
}
