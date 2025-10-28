import 'package:flutter/material.dart';
import 'package:proyecto_movil/screens/estudiante/calendario.dart';
import 'package:proyecto_movil/screens/estudiante/entregas_estudiante.dart';
import 'registrar_proyecto.dart';
import 'package:proyecto_movil/screens/estudiante/mi_proyecto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_movil/screens/estudiante/revision_jurados.dart';

class MenuEstudiante extends StatefulWidget {
  final int tabIndex;
  const MenuEstudiante({super.key, this.tabIndex = 0});

  @override
  State<MenuEstudiante> createState() => _MenuEstudianteState();
}

class _MenuEstudianteState extends State<MenuEstudiante> {
  int _currentIndex = 0;
  int? _idUsuario;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.tabIndex;
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('idUsuario');
    setState(() {
      _idUsuario = id;
    });
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.green),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.school, color: Colors.white, size: 48),
                SizedBox(height: 8),
                Text(
                  'Menú Estudiante',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.folder_open),
            title: const Text('Registrar Proyecto'),
            selected: _currentIndex == 0,
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Calendario'),
            selected: _currentIndex == 1,
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Mi Proyecto'),
            selected: _currentIndex == 2,
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Entregas'),
            selected: _currentIndex == 3,
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 3);
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified),
            title: const Text('Entregas'),
            selected: _currentIndex == 4,
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 4);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_idUsuario == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Los providers ya existen globalmente, solo usamos el Scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Estudiante'),
        backgroundColor: Colors.green,
      ),
      drawer: _buildDrawer(context),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const RegistrarProyectoScreen(),
          CalendarioScreen(idUsuario: _idUsuario!),
          MiProyectoScreen(idUsuario: _idUsuario!),
          EntregasEstudianteScreen(idUsuario: _idUsuario!),
          const RevisionJuradoScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open),
            label: 'Proyecto',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Mi Proyecto',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_file),
            label: 'Entregas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified),
            label: 'Revisión Jurado',
          ),
        ],
      ),
    );
  }
}
