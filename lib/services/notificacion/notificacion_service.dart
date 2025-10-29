import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    
    // Configuración para Android
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Aquí puedes manejar cuando el usuario toca la notificación
        print('Notificación tocada: ${details.payload}');
      },
    );

    // Solicitar permisos
    await _solicitarPermisos();
  }

  Future<void> _solicitarPermisos() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> programarNotificacionEntrega({
    required int id,
    required String titulo,
    required String descripcion,
    required DateTime fechaEntrega,
  }) async {
    // Programar notificación para el día de la entrega a las 5:15 PM
    final fechaNotificacion = DateTime(
      fechaEntrega.year,
      fechaEntrega.month,
      fechaEntrega.day,
      13, // Hora: 5 PM
      30, // Minutos
    );

    // Solo programar si la fecha es futura
    if (fechaNotificacion.isAfter(DateTime.now())) {
      await _notifications.zonedSchedule(
        id,
        '📚 Entrega Hoy',
        '$descripcion - ¡No olvides entregar hoy!',
        tz.TZDateTime.from(fechaNotificacion, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'entregas_channel',
            'Notificaciones de Entregas',
            channelDescription: 'Notificaciones para recordar entregas de proyectos',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    // Notificación recordatorio 1 día antes a las 5:00 PM
    final fechaRecordatorio = DateTime(
      fechaEntrega.year,
      fechaEntrega.month,
      fechaEntrega.day - 1,
      13, // 5 PM
      30,
    );

    if (fechaRecordatorio.isAfter(DateTime.now())) {
      await _notifications.zonedSchedule(
        id + 10000, // ID diferente para evitar conflictos
        '⏰ Recordatorio: Entrega Mañana',
        '$descripcion - Entrega mañana',
        tz.TZDateTime.from(fechaRecordatorio, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'entregas_channel',
            'Notificaciones de Entregas',
            channelDescription: 'Notificaciones para recordar entregas de proyectos',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<void> cancelarNotificacion(int id) async {
    await _notifications.cancel(id);
    await _notifications.cancel(id + 10000); // Cancelar también el recordatorio
  }

  Future<void> cancelarTodasLasNotificaciones() async {
    await _notifications.cancelAll();
  }

  Future<List<PendingNotificationRequest>> obtenerNotificacionesPendientes() async {
    return await _notifications.pendingNotificationRequests();
  }
}