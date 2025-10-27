import 'package:flutter/material.dart';
import 'package:proyecto_movil/screens/docente/plan_entrega.dart';
import 'package:proyecto_movil/screens/docente/proyectos_asignados_page.dart';
import 'package:proyecto_movil/screens/docente/programar_reunion_page.dart';

class HomeDocente extends StatefulWidget {
  const HomeDocente({super.key});

  @override
  State<HomeDocente> createState() => _HomeDocenteState();
}

class _HomeDocenteState extends State<HomeDocente> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ProyectosAsignadosPage(),
    PlanearEntregaPage(),
    ProgramarReunionPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // Cambié el color azul por verde
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.green[300],
        backgroundColor: Colors.green[50],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Proyectos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_file),
            label: "Planear Entregas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call),
            label: "Programar Reunión",
          ),
        ],
      ),
    );
  }
}

