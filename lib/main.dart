import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_movil/controllers/docente/entregas_plan_controller.dart';
import 'package:proyecto_movil/controllers/docente/plan_entrega_controller.dart';
import 'package:proyecto_movil/controllers/docente/proyectos_asignados_controller.dart';
import 'package:proyecto_movil/controllers/estudiante/calendario_controller.dart';
import 'package:proyecto_movil/controllers/estudiante/mi_proyecto_controller.dart';
import 'package:proyecto_movil/controllers/estudiante/revision_jurado_controller.dart';
import 'package:proyecto_movil/screens/docente/proyectos_asignados_page.dart';
import 'package:proyecto_movil/screens/estudiante/home_estudiante.dart';
import 'package:proyecto_movil/screens/docente/homeDocente.dart';
import 'package:proyecto_movil/screens/estudiante/menu_estudiante.dart';
import 'package:proyecto_movil/controllers/estudiante/entregasAsignadas_controller.dart';
import 'package:proyecto_movil/controllers/estudiante/subir_entrega_controller.dart';
import 'package:proyecto_movil/screens/estudiante/subir_entrega_screen.dart';
import 'package:proyecto_movil/screens/login_screen.dart';
import 'package:proyecto_movil/screens/repositorio/home_repo.dart';
import 'package:proyecto_movil/controllers/repositorio/repositorio_controller.dart';
import 'package:proyecto_movil/services/notificacion/notificacion_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await NotificationService().initialize();
  await initializeDateFormatting('es_ES', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalendarioController()),
        ChangeNotifierProvider(create: (_) => MiProyectoController()),
        ChangeNotifierProvider(create: (_) => EntregasController()),
        ChangeNotifierProvider(create: (_) => SubirEntregaController()),
        ChangeNotifierProvider(create: (_) => RepositorioController()),
        ChangeNotifierProvider(create: (_) => RevisionJuradoController()),
        ChangeNotifierProvider(create: (_) => ProyectosAsignadosController()),
        ChangeNotifierProvider(create: (_) => PlanEntregaController()),
        ChangeNotifierProvider(create: (_) => EntregasPlanController()),
      ],
      child: MaterialApp(
        title: 'GraduTech',
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', 'ES'), // Soporte para español
        ],
        routes: {
          '/login': (context) => const LoginScreen(),
          '/homeEstudiante': (context) => const HomeEstudiante(),
          '/menuEstudiante': (context) => const MenuEstudiante(),
          '/homeDocente': (context) => const HomeDocente(),
          '/proyectosAsignados': (context) => const ProyectosAsignadosScreen(),
          '/subir-entrega': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>;
            return SubirEntregaScreen(
              idPlanEntrega: args['idPlanEntrega'],
              fechaLimite: args['fechaLimite'],
            );
          },
          '/homeRepo': (context) => const HomeRepoScreen(),
          // '/homeJurado': (context) => const HomeJurado(),
        },
      ),
    );
  }
}
