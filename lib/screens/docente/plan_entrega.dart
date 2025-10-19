import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/docente/plan_entrega_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlanEntregaScreen extends StatefulWidget {
  const PlanEntregaScreen({super.key});

  @override
  State<PlanEntregaScreen> createState() => _PlanEntregaScreenState();
}

class _PlanEntregaScreenState extends State<PlanEntregaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nroEntregaController = TextEditingController();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _fechaController = TextEditingController();
  int? idProyecto;
  String? correoEstudiante;

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();
  }

  Future<void> _cargarDatosIniciales() async {
    final prefs = await SharedPreferences.getInstance();
    idProyecto = prefs.getInt('id_proyecto');
    correoEstudiante = prefs.getString('correo');

    if (idProyecto != null) {
      await Provider.of<PlanEntregaController>(context, listen: false)
          .cargarPlanes(idProyecto!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PlanEntregaController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📌 Planificación de Entregas'),
        backgroundColor: Colors.green[700],
      ),
      body: controller.cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nroEntregaController,
                          decoration: const InputDecoration(labelText: "N° Entrega"),
                        ),
                        TextFormField(
                          controller: _tituloController,
                          decoration: const InputDecoration(labelText: "Título"),
                        ),
                        TextFormField(
                          controller: _descripcionController,
                          decoration: const InputDecoration(labelText: "Descripción"),
                        ),
                        TextFormField(
                          controller: _fechaController,
                          decoration: const InputDecoration(labelText: "Fecha límite (YYYY-MM-DD)"),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate() && idProyecto != null) {
                              final nuevoPlan = {
                                "id_proyecto": idProyecto,
                                "nro_entrega": _nroEntregaController.text,
                                "titulo": _tituloController.text,
                                "descripcion": _descripcionController.text,
                                "fecha_limite": _fechaController.text,
                                "correo": correoEstudiante,
                              };

                              final creado = await controller.crearPlanEntrega(nuevoPlan);
                              if (creado) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Plan de entrega creado ✅")),
                                );
                                await controller.cargarPlanes(idProyecto!);
                                _nroEntregaController.clear();
                                _tituloController.clear();
                                _descripcionController.clear();
                                _fechaController.clear();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Error al crear plan")),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                          ),
                          child: const Text("Agregar"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Planes existentes:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  ...controller.planes.map((plan) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text("Entrega #${plan['nro_entrega']}: ${plan['titulo']}"),
                          subtitle: Text(
                              "Fecha límite: ${plan['fecha_limite']}\n${plan['descripcion']}"),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/entregaPorPlan',
                              arguments: plan['id_plan_entrega'],
                            );
                          },
                        ),
                      )),
                ],
              ),
            ),
    );
  }
}
