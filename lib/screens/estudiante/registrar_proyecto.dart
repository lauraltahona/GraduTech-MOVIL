import 'package:flutter/material.dart';
import '../../controllers/estudiante/registrar_proyecto_controller.dart';

class RegistrarProyectoScreen extends StatefulWidget {
  const RegistrarProyectoScreen({super.key});

  @override
  State<RegistrarProyectoScreen> createState() =>
      _RegistrarProyectoScreenState();
}

class _RegistrarProyectoScreenState extends State<RegistrarProyectoScreen> {
  final controller = RegistrarProyectoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Stack(
        children: [
          // Contenido principal
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 50), // Espacio para el botón de regreso
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Registrar Proyecto',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Completa la información de tu proyecto académico',
                        ),
                        const SizedBox(height: 20),

                        // Título
                        TextField(
                          controller: controller.titleController,
                          decoration: const InputDecoration(
                            labelText: 'Título del proyecto',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Tipo
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Tipo de proyecto',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: controller.tipoProyecto.isEmpty
                              ? null
                              : controller.tipoProyecto,
                          items: const [
                            DropdownMenuItem(
                              value: 'Pasantía',
                              child: Text('Pasantía'),
                            ),
                            DropdownMenuItem(
                              value: 'Proyecto de grado',
                              child: Text('Proyecto de grado'),
                            ),
                            DropdownMenuItem(
                              value: 'Tesis',
                              child: Text('Tesis'),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => controller.tipoProyecto = value!),
                        ),
                        const SizedBox(height: 16),

                        // ID estudiante
                        TextField(
                          controller: controller.idController,
                          decoration: const InputDecoration(
                            labelText: 'ID del estudiante',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),

                        // Descripción
                        TextField(
                          controller: controller.descripcionController,
                          decoration: const InputDecoration(
                            labelText: 'Descripción',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 20),

                        /// Subir archivo
                        ElevatedButton.icon(
                          onPressed: () async {
                            await controller.seleccionarArchivo(context);
                            setState(
                              () {},
                            ); // 🔄 actualiza la vista con el nombre del archivo
                          },
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Seleccionar archivo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // 👇 Mostrar el archivo seleccionado
                        if (controller.archivoSeleccionado != null)
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    controller.archivoSeleccionado!.path
                                        .split('/')
                                        .last,
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.visibility,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    // Si quisieras abrirlo en el navegador
                                    controller.abrirDocumentoEnNavegador(
                                      controller.archivoSeleccionado!.path,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),

                        // Guardar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.green,
                                side: const BorderSide(color: Colors.green),
                              ),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  controller.subirProyecto(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('Guardar Proyecto'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Botón de regreso al home - pequeño en la esquina superior izquierda
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.home, color: Colors.white, size: 24),
                  onPressed: () {
                    // Navegar al home principal del estudiante
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/homeEstudiante',
                      (route) => false,
                    );
                  },
                  tooltip: 'Volver al inicio',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
