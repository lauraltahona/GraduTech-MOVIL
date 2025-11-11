import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario no encontrado')),
        );
        return;
      }

      final rol = user['rol'];
      final idUsuario = user['id_usuario'];
      final token = result['token'];

      print('Login exitoso: ID=$idUsuario, Rol=$rol');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('idUsuario', idUsuario);
      await prefs.setString('rol', rol);
      if (token != null) await prefs.setString('token', token);

      switch (rol) {
        case 'Estudiante':
          Navigator.pushReplacementNamed(context, '/homeEstudiante');
          break;

        case 'Docente':
          Navigator.pushReplacementNamed(context, '/homeDocente');
          break;

        case 'Jurado':
          Navigator.pushReplacementNamed(context, '/homeJurado');
          break;

        case 'Administrador':
          Navigator.pushReplacementNamed(context, '/menuAdmin');
          break;

        default:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Rol no reconocido: $rol')),
          );
      }
    } catch (e) {
      print('Error durante login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Credenciales incorrectas o servidor no disponible')),
      );
    }
  }
}

