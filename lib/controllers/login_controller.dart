import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LoginController {
  final ApiService apiService = ApiService();

  Future<void> login(
    String correo,
    String password,
    BuildContext context,
  ) async {
    try {
      final result = await apiService.login(correo, password);
      final user = result['user'];
      final rol = user['rol'];

      if (rol == 'Estudiante') {
        Navigator.pushReplacementNamed(context, '/homeEstudiante');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rol no permitido en móvil')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales incorrectas')),
      );
    }
  }
}
