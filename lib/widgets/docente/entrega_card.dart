import 'package:flutter/material.dart';

class EntregaCard extends StatelessWidget {
  final Map entrega;
  final VoidCallback onRetroalimentar;

  const EntregaCard({
    super.key,
    required this.entrega,
    required this.onRetroalimentar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE8F5E9),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          '📅 ${DateTime.parse(entrega['fecha_envio']).toLocal().toString().split(' ')[0]}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📝 ${entrega['descripcion']}'),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                // abrir enlace
              },
              child: Text(
                '📄 Ver documento',
                style: TextStyle(
                  color: Colors.green[800],
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            if (entrega['retroalimentacion'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('💬 Retroalimentación: ${entrega['retroalimentacion']}'),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.feedback, color: Colors.green),
          onPressed: onRetroalimentar,
        ),
      ),
    );
  }
}
