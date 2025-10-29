import 'package:flutter/material.dart';
import 'package:proyecto_movil/screens/login_screen.dart';
import 'proyectos_asignados_page.dart';

class HomeDocente extends StatefulWidget {
  const HomeDocente({super.key});

  @override
  State<HomeDocente> createState() => _HomeDocentePageState();
}

class _HomeDocentePageState extends State<HomeDocente> {
  int _selectedIndex = 0;

  void cambiarPagina(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      BienvenidaDocentePage(onVerProyectos: () => cambiarPagina(1)),
      const ProyectosAsignadosScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _cerrarSesion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Estás seguro de que deseas cerrar sesión?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
            ),
            child: const Text("Cerrar sesión"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GRADUTECH'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.green),
            ),
            onSelected: (value) {
              if (value == 'cerrar') {
                _cerrarSesion();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'cerrar',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Cerrar sesión'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Proyectos',
          ),
        ],
      ),
    );
  }
}

class BienvenidaDocentePage extends StatelessWidget {
  final VoidCallback onVerProyectos;

  const BienvenidaDocentePage({
    super.key,
    required this.onVerProyectos,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🔹 Imagen de fondo
        Positioned.fill(
          child: Image.asset(
            'assets/homedocente/FOTO-FACHADA-SABANAS112.jpg',
            fit: BoxFit.cover,
          ),
        ),
        // 🔹 Filtro semitransparente
        Container(
          color: Colors.black.withOpacity(0.4),
        ),
        // 🔹 Contenido principal
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school, size: 100, color: Colors.white),
                const SizedBox(height: 20),
                const Text(
                  '¡Bienvenido, Docente!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Aquí podrás gestionar tus proyectos académicos de forma rápida y sencilla.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(217, 255, 255, 255),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const Text(
                  '👉 Para poder ver tus proyectos asignados, planear entregas o programar reuniones, '
                  'puedes presionar el botón de abajo o ir al ítem "Proyectos" en la parte inferior.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(182, 255, 255, 255),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: onVerProyectos,
                  icon: const Icon(Icons.assignment),
                  label: const Text('Ver proyectos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
