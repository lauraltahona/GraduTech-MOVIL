import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_movil/controllers/estudiante/revision_jurado_controller.dart';
import 'package:proyecto_movil/widgets/estudiante/jurado_card.dart';

class RevisionJuradoScreen extends StatefulWidget {
  const RevisionJuradoScreen({super.key});

  @override
  State<RevisionJuradoScreen> createState() => _RevisionJuradoScreenState();
}

class _RevisionJuradoScreenState extends State<RevisionJuradoScreen> {
  int? _idUsuario;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final idUsuario = prefs.getInt('idUsuario');

    if (idUsuario != null) {
      setState(() => _idUsuario = idUsuario);
      final controller = context.read<RevisionJuradoController>();
      controller.cargarDatos(idUsuario);
    }
  }

  String formatearFecha(String fechaStr) {
    final fecha = DateTime.parse(fechaStr);
    return "${fecha.day}/${fecha.month}/${fecha.year}";
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RevisionJuradoController>();

    if (_idUsuario == null) {
      // 👇 esperamos a que se cargue el id
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (controller.cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final proyecto = controller.proyecto;

    return Scaffold(
      appBar: AppBar(title: const Text("Revisión de Jurados")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Jurados Asignados",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...controller.jurados.map((j) => JuradoCard(jurado: j)),

            const SizedBox(height: 20),
            const Text(
              "Estado Final",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (proyecto != null)
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.assignment_turned_in,
                    color: Colors.green,
                  ),
                  title: Text(proyecto.estado ?? "Pendiente"),
                  subtitle: Text(
                    proyecto.estado == "APROBADO"
                        ? "Tu proyecto ha sido aprobado. ¡Felicidades!"
                        : "Tu proyecto aún está en revisión.",
                  ),
                  trailing: Text(
                    formatearFecha(
                      proyecto.updatedAt ?? DateTime.now().toString(),
                    ),
                  ),
                ),
              ),

            if (proyecto?.estado == "APROBADO") ...[
              const SizedBox(height: 20),
              const Text(
                "Próximos pasos",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Con la aprobación del jurado, ahora puedes subir tu proyecto al repositorio institucional.",
              ),
              const SizedBox(height: 10),

              ElevatedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text("Dar autorización"),
                onPressed: () async {
                  // 🔹 Mostrar diálogo de términos y condiciones
                  final aceptar = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Términos y Condiciones"),
                      content: const SingleChildScrollView(
                        child: Text(
                          "Al aceptar, autorizas que tu proyecto sea publicado en el "
                          "repositorio institucional de la Universidad. Tu trabajo podrá ser "
                          "consultado por la comunidad académica y será de acceso público con "
                          "fines educativos y de investigación. Conservas los derechos de "
                          "autor sobre tu obra.",
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text("Cancelar"),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text("Aceptar"),
                          onPressed: () => Navigator.pop(context, true),
                        ),
                      ],
                    ),
                  );

                  // 🔹 Si aceptó, autoriza el proyecto
                  if (aceptar == true) {
                    await controller.autorizarProyecto(context);
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
