import 'package:flutter/material.dart';
import 'package:proyecto_movil/models/jurado_model.dart';

class JuradoCard extends StatelessWidget {
  final Jurado jurado;

  const JuradoCard({super.key, required this.jurado});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade200,
          child: Text(
            jurado.name.split(' ').length > 1
                ? '${jurado.name.split(' ')[0][0]}${jurado.name.split(' ')[1][0]}'
                : jurado.name[0],
          ),
        ),
        title: Text(jurado.name),
        subtitle: Text(jurado.specialty),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 18),
            const SizedBox(width: 4),
            Text(jurado.status),
          ],
        ),
      ),
    );
  }
}
