import 'package:flutter/material.dart';

class ProgramarReunionScreen extends StatelessWidget {
  const ProgramarReunionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Aquí podrás programar reuniones 📅',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

