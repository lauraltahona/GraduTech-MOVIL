import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_movil/controllers/estudiante/calendario_controller.dart';
import 'package:proyecto_movil/screens/estudiante/calendario.dart';
import 'registrar_proyecto.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  Widget build(BuildContext context) {
    if (_idUsuario == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<Widget> pages = [
      const RegistrarProyectoScreen(),
      // Aquí agregamos el provider solo para esta pantalla
      ChangeNotifierProvider(
        create: (_) => CalendarioController(),
        child: CalendarioScreen(idUsuario: _idUsuario!),
      ),
      const Center(child: Text('Mi Proyecto')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Estudiante'),
        backgroundColor: Colors.green,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.folder_open), label: 'Proyecto'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendario'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: 'Mi Proyecto'),
        ],
      ),
    );
  }
}
