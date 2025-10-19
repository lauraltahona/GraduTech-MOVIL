import 'package:flutter/material.dart';
import '../../controllers/estudiante/registrar_proyecto_controller.dart';

class RegistrarProyectoScreen extends StatefulWidget {
  const RegistrarProyectoScreen({super.key});

  @override
  State<RegistrarProyectoScreen> createState() => _RegistrarProyectoScreenState();
}

class _RegistrarProyectoScreenState extends State<RegistrarProyectoScreen> {
  final controller = RegistrarProyectoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Registrar Proyecto',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 8),
                const Text('Completa la información de tu proyecto académico'),
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
                  initialValue: controller.tipoProyecto.isEmpty ? null : controller.tipoProyecto,
                  items: const [
                    DropdownMenuItem(value: 'Pasantía', child: Text('Pasantía')),
                    DropdownMenuItem(value: 'Proyecto de grado', child: Text('Proyecto de grado')),
                    DropdownMenuItem(value: 'Tesis', child: Text('Tesis')),
                  ],
                  onChanged: (value) => setState(() => controller.tipoProyecto = value!),
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

                // Subir archivo
                ElevatedButton.icon(
                  onPressed: () => controller.seleccionarArchivo(context),
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Subir archivo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
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
                      onPressed: () => controller.subirProyecto(context),
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
      ),
    );
  }
}
