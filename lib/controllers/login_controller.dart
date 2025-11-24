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
    // Mostrar indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      ),
    );

    try {
      final result = await apiService.login(correo, password);
      final user = result['user'];

      if (user == null) {
        Navigator.pop(context); // Cerrar el diálogo de carga
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

      // Cerrar el diálogo de carga
      Navigator.pop(context);

      // Pequeña espera para asegurar que todo está listo
      await Future.delayed(const Duration(milliseconds: 100));

      // Navegar según el rol
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

        default:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Rol no reconocido: $rol')),
          );
      }
    } catch (e) {
      Navigator.pop(context); // Cerrar el diálogo de carga en caso de error
      print('Error durante login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Credenciales incorrectas o servidor no disponible'),
        ),
      );
    }
  }
}