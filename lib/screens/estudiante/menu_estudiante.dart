import 'package:flutter/material.dart';
import 'registrar_proyecto.dart';

class MenuEstudiante extends StatefulWidget {
  final int tabIndex;
  const MenuEstudiante({super.key, this.tabIndex = 0});

  @override 
  State<MenuEstudiante> createState() => _MenuEstudianteState();
}

class _MenuEstudianteState extends State<MenuEstudiante> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    RegistrarProyectoScreen(),
    Center(child: Text('Calendario')),
    Center(child: Text('Mi Proyecto')),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.tabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Estudiante'),
        backgroundColor: Colors.green,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.folder_open), label: 'Proyecto'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendario'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Mi Proyecto'),
        ],
      ),
    );
  }
}
