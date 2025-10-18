import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';  // 👈 importa dotenv
import 'screens/login_screen.dart';
import 'screens/estudiante/home_estudiante.dart';
import 'screens/estudiante/menu_estudiante.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 👇 Carga el archivo .env antes de iniciar la app
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GraduTech',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/homeEstudiante': (context) => const HomeEstudiante(),
        '/menuEstudiante': (context) => MenuEstudiante(),
      },
    );
  }
}

