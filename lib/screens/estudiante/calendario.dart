import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_movil/controllers/estudiante/calendario_controller.dart';
import 'package:proyecto_movil/widgets/estudiante/calendario_widgets.dart';

class CalendarioScreen extends StatefulWidget {
  final int idUsuario;
  const CalendarioScreen({super.key, required this.idUsuario});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CalendarioController>(context, listen: false)
          .cargarFechas(widget.idUsuario);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CalendarioController>(context);

    return Scaffold(
      floatingActionButton: SafeArea(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(Icons.home, color: Colors.white, size: 24),
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/homeEstudiante',
            (route) => false,
          );
        },
      ),
    ),
  ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Encabezado
            Container(
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  )
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: Colors.white, size: 35),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Calendario de Entregas",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Consulta las fechas límite de tus entregas aquí 📚",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Calendario
            TableCalendar(
              focusedDay: DateTime.now(),
              firstDay: DateTime(2020),
              lastDay: DateTime(2100),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.green.shade400,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green.shade700,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  shape: BoxShape.circle,
                ),
              ),
              selectedDayPredicate: (day) =>
                  controller.fechaSeleccionada != null &&
                  controller.esMismaFecha(day, controller.fechaSeleccionada!),
              onDaySelected: (selectedDay, _) {
                setState(() {
                  controller.fechaSeleccionada = selectedDay;
                });
              },
              eventLoader: (day) => controller.fechasImportantes
                  .where((f) => controller.esMismaFecha(f['fecha'], day))
                  .toList(),
            ),

            const SizedBox(height: 20),

            // Detalle de entrega
            if (controller.fechaSeleccionada != null)
              CalendarioCard(
                fechaSeleccionada: controller.fechaSeleccionada!,
                descripcion: controller
                        .obtenerEntrega(controller.fechaSeleccionada!)?['descripcion'] ??
                    "Sin entregas programadas.",
              ),
          ],
        ),
      ),
    );
  }
}
