import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:proyecto_movil/screens/docente/entregas_pages.dart';

class ProyectosAsignadosPage extends StatefulWidget {
  const ProyectosAsignadosPage({super.key});

  @override
  State<ProyectosAsignadosPage> createState() => _ProyectosAsignadosPageState();
}

class _ProyectosAsignadosPageState extends State<ProyectosAsignadosPage> {
  List proyectos = [];
  bool cargando = true;
  String mensaje = "";

  @override
  void initState() {
    super.initState();
    cargarProyectos();
  }

  Future<void> cargarProyectos() async {
    try {
      final baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:5001';
      final idUsuario = "1"; // ⚠️ Cambiar por ID real del login
      final url = Uri.parse('$baseUrl/proyectos/asignados/$idUsuario');

      final res = await http.get(url);
      if (res.statusCode == 200) {
        setState(() {
          proyectos = json.decode(res.body);
          cargando = false;
        });
      } else {
        setState(() {
          mensaje = "Error al cargar proyectos (${res.statusCode})";
          cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        mensaje = "Error de conexión con el servidor";
        cargando = false;
      });
    }
  }

  Future<void> cambiarEstado(int idProyecto, String nuevoEstado) async {
    try {
      final baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:5001';
      final url = Uri.parse('$baseUrl/proyectos/cambiar-estado');
      final res = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idProyecto': idProyecto, 'estado': nuevoEstado}),
      );
      if (res.statusCode == 200) {
        setState(() {
          proyectos = proyectos.map((p) {
            if (p['idProyecto'] == idProyecto) {
              p['estado'] = nuevoEstado;
            }
            return p;
          }).toList();
        });
      }
    } catch (e) {
      setState(() => mensaje = "Error al cambiar estado");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.green)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Proyectos Asignados"),
        backgroundColor: Colors.green[700], // Verde intenso
      ),
      body: proyectos.isEmpty
          ? Center(
              child: Text(
                mensaje.isNotEmpty ? mensaje : "No hay proyectos asignados.",
                style: const TextStyle(color: Colors.green),
              ),
            )
          : ListView.builder(
              itemCount: proyectos.length,
              itemBuilder: (context, index) {
                final proyecto = proyectos[index];
                return Card(
                  color: Colors.green[100], // Fondo verde suave
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          proyecto['titulo'] ?? '',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        Text(
                          "👤 Estudiante: ${proyecto['estudiante']}",
                          style: const TextStyle(color: Colors.green),
                        ),
                        Text(
                          "📊 Estado: ${proyecto['estado']}",
                          style: const TextStyle(color: Colors.green),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[600]),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EntregasPage(
                                        idPlanEntrega:
                                            proyecto['idPlanEntrega']),
                                  ),
                                );
                              },
                              child: const Text("Ver entregas"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[400]),
                              onPressed: () {
                                // Aquí podrías abrir un modal para programar reunión
                              },
                              child: const Text("Programar reunión"),
                            ),
                            DropdownButton<String>(
                              value: proyecto['estado'],
                              dropdownColor: Colors.green[50],
                              items: const [
                                DropdownMenuItem(
                                    value: "EN REVISIÓN",
                                    child: Text("EN REVISIÓN")),
                                DropdownMenuItem(
                                    value: "APROBADO POR DOCENTE",
                                    child: Text("APROBADO POR DOCENTE")),
                                DropdownMenuItem(
                                    value: "RECHAZADO", child: Text("RECHAZADO")),
                              ],
                              onChanged: (nuevoEstado) {
                                if (nuevoEstado != null) {
                                  cambiarEstado(
                                      proyecto['idProyecto'], nuevoEstado);
                                }
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
