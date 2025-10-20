import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_movil/controllers/repositorio/repositorio_controller.dart';
import '../../widgets/repositorio/category_card.dart';

class HomeRepoScreen extends StatelessWidget {
  const HomeRepoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RepositorioController>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              color: Colors.blue.shade900,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Image.asset('assets/inicio/logoEnBlanco.png', height: 60),
            ),

            // TITLE
            const SizedBox(height: 20),
            const Text(
              'REPOSITORIO UNICESAR',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // SEARCH BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar en el repositorio...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Aquí podrías conectar una búsqueda real
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Text('🔍', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // CATEGORY CARDS
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  CategoryCard(
                    title: 'Tesis',
                    imagePath: 'assets/repositorio/logo-tesis.png',
                    onTap: () => controller.irADetalleProyecto(context, 'Tesis'),
                  ),
                  CategoryCard(
                    title: 'Pasantías',
                    imagePath: 'assets/repositorio/logo-pasantias.png',
                    onTap: () => controller.irADetalleProyecto(context, 'Pasantía'),
                  ),
                  CategoryCard(
                    title: 'Proyectos de grado',
                    imagePath: 'assets/repositorio/logo-proyectos.png',
                    onTap: () => controller.irADetalleProyecto(context, 'Proyecto de grado'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
