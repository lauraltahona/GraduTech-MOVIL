import 'package:flutter/material.dart';
import 'menu_estudiante.dart';

class HomeEstudiante extends StatefulWidget {
  const HomeEstudiante({super.key});

  @override
  State<HomeEstudiante> createState() => _HomeEstudianteState();
}

class _HomeEstudianteState extends State<HomeEstudiante> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido a GraduTech'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer( // 👈 este es el menú tipo hamburguesa
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.school, size: 48, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Menú Estudiante',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: const Text('Registrar Proyecto'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MenuEstudiante(tabIndex: 0)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendario'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MenuEstudiante(tabIndex: 1)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          '¡Bienvenido, estudiante!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
