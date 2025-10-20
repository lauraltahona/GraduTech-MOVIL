import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_movil/controllers/estudiante/calendario_controller.dart';
import 'package:proyecto_movil/controllers/estudiante/mi_proyecto_controller.dart';
import 'package:proyecto_movil/screens/docente/proyectos_asignados_page.dart';
import 'package:proyecto_movil/screens/estudiante/home_estudiante.dart';
import 'package:proyecto_movil/screens/docente/homeDocente.dart';
import 'package:proyecto_movil/screens/estudiante/menu_estudiante.dart';
import 'package:proyecto_movil/controllers/estudiante/entregasAsignadas_controller.dart';
import 'package:proyecto_movil/controllers/estudiante/subir_entrega_controller.dart';
import 'package:proyecto_movil/screens/estudiante/subir_entrega_screen.dart';
import 'package:proyecto_movil/screens/login_screen.dart';
// Importa tus otras pantallas aquí

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 IMPORTANTE: Los providers se crean UNA SOLA VEZ aquí
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalendarioController()),
        ChangeNotifierProvider(create: (_) => MiProyectoController()),
        ChangeNotifierProvider(create: (_) => EntregasController()),
        ChangeNotifierProvider(create: (_) => SubirEntregaController()),
      ],
      child: MaterialApp(
        title: 'GraduTech',
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/homeEstudiante': (context) => const HomeEstudiante(),
          '/menuEstudiante': (context) => const MenuEstudiante(),
          '/homeDocente': (context) => const HomeDocente(),
          '/proyectosAsignados': (context) => const ProyectosAsignadosPage(),
          '/subir-entrega': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return SubirEntregaScreen(
              idPlanEntrega: args['idPlanEntrega'],
              fechaLimite: args['fechaLimite'],
            );
          },
          // '/homeJurado': (context) => const HomeJurado(),
        },
      ),
    );
  }
}