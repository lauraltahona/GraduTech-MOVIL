  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'package:proyecto_movil/screens/docente/plan_entrega.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:proyecto_movil/controllers/docente/proyectos_asignados_controller.dart';
  import 'package:proyecto_movil/widgets/docente/proyecto_asignado_card.dart';
  import 'package:proyecto_movil/widgets/docente/modal_programar_reunion.dart';
  import 'package:proyecto_movil/screens/docente/plan_entrega.dart';

  class ProyectosAsignadosScreen extends StatefulWidget {
    const ProyectosAsignadosScreen({super.key});

    @override
    State<ProyectosAsignadosScreen> createState() => _ProyectosAsignadosScreenState();
  }

  class _ProyectosAsignadosScreenState extends State<ProyectosAsignadosScreen> {
    int? _idUsuario;

    @override
    void initState() {
      super.initState();
      _cargarDatos();
    }

    Future<void> _cargarDatos() async {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt('idUsuario');
      
      if (id != null) {
        setState(() {
          _idUsuario = id;
        });
        
        if (mounted) {
          await context.read<ProyectosAsignadosController>().cargarProyectos(id);
        }
      }
    }

    Future<void> _refrescar() async {
      if (_idUsuario != null) {
        await context.read<ProyectosAsignadosController>().cargarProyectos(_idUsuario!);
      }
    }

    void _mostrarModalReunion(String correoEstudiante) {
      showDialog(
        context: context,
        builder: (context) => ModalProgramarReunion(
          correoEstudiante: correoEstudiante,
          onEnviar: (fecha, hora, lugar) async {
            final controller = context.read<ProyectosAsignadosController>();
            await controller.programarReunion(
              correo: correoEstudiante,
              fecha: fecha,
              hora: hora,
              lugar: lugar,
            );

            if (mounted && controller.mensaje != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(controller.mensaje!),
                  backgroundColor: controller.mensaje!.contains('✅') 
                      ? Colors.green 
                      : Colors.red,
                ),
              );
              controller.limpiarMensaje();
            }
          },
        ),
      );
    }

    void _irAPlanEntrega(int idProyecto, String correo) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlanearEntregaScreen(idProyecto: idProyecto, correoEstudiante: correo),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      if (_idUsuario == null) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: Colors.green),
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('✅ Proyectos Asignados'),
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
        ),
        body: Consumer<ProyectosAsignadosController>(
          builder: (context, controller, child) {
            if (controller.cargando) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.green),
              );
            }

            if (controller.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar proyectos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _refrescar,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (controller.proyectos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay proyectos asignados',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refrescar,
              color: Colors.green,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.proyectos.length,
                itemBuilder: (context, index) {
                  final proyecto = controller.proyectos[index];
                  
                  return ProyectoAsignadoCard(
                    proyecto: proyecto,
                    onCambiarEstado: (nuevoEstado) {
                      controller.cambiarEstado(proyecto.idProyecto, nuevoEstado);
                    },
                    onPlanearEntrega: () => _irAPlanEntrega(proyecto.idProyecto, proyecto.correo),
                    onProgramarReunion: () => _mostrarModalReunion(proyecto.correo),
                  );
                },
              ),
            );
          },
        ),
      );
    }
  }