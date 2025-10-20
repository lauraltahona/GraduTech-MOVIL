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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER verde con botón de regreso
              Container(
                color: const Color(0xFF4CAF50),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Botón de regreso a la izquierda
                    Positioned(
                      left: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    // Logo centrado
                    Image.asset(
                      'assets/inicio/logoEnBlanco.png',
                      height: 50,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // TÍTULO
              const Text(
                'REPOSITORIO UNICESAR',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar en el Repositorio...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // CATEGORY CARDS - Centradas verticalmente
              CategoryCard(
                title: 'Pasantías',
                imagePath: 'assets/repositorio/logo-pasantias.png',
                onTap: () => controller.irADetalleProyecto(context, 'Pasantía'),
              ),
              
              const SizedBox(height: 40),
              
              CategoryCard(
                title: 'Tesis',
                imagePath: 'assets/repositorio/logo-tesis.png',
                onTap: () => controller.irADetalleProyecto(context, 'Tesis'),
              ),
              
              const SizedBox(height: 40),
              
              CategoryCard(
                title: 'Proyectos',
                imagePath: 'assets/repositorio/logo-proyectos.png',
                onTap: () => controller.irADetalleProyecto(context, 'Proyecto de grado'),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}