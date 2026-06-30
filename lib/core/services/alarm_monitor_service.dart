import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar_community/isar.dart';
import 'package:vibration/vibration.dart';
import '../db/database_manager.dart';
import '../../data/models/alarm_model.dart';
import 'notification_service.dart';
import 'alarm_sound_service.dart';

class AlarmMonitorService {
  static final AlarmMonitorService _instance = AlarmMonitorService._internal();
  factory AlarmMonitorService() => _instance;
  AlarmMonitorService._internal();

  Timer? _timeMonitor;
  StreamSubscription<Position>? _locationSubscription;
  bool _isAlarmRinging = false;

  void iniciarMonitoreo(BuildContext context) {
    _iniciarMonitoreoReloj(context);
    _iniciarMonitoreoGPS(context);
  }

  void _iniciarMonitoreoReloj(BuildContext context) {
    _timeMonitor = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (_isAlarmRinging) return;

      final isar = DatabaseManager.instance;
      if (isar == null) return;

      final ahora = DateTime.now();
      final hoy = (ahora.weekday - 1) % 7;

      final alarmas = await isar.alarmModels.where().anyId().findAll();
      final activas = alarmas.where((a) => a.isActive).toList();

      for (var alarma in activas) {
        if (alarma.latitude != 0.0) continue;

        if (!alarma.activeDays[hoy]) continue;

        if (alarma.lastTriggered != null) {
          final diff = ahora.difference(alarma.lastTriggered!);
          if (diff.inMinutes < 1) continue;
        }

        if (alarma.alarmHour == ahora.hour && 
            alarma.alarmMinute == ahora.minute) {
          await isar.writeTxn(() async {
            alarma.lastTriggered = ahora;
            await isar.alarmModels.put(alarma);
          });

          _dispararAlarma(context, alarma);
          break;
        }
      }
    });
  }

  void _iniciarMonitoreoGPS(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high, 
        distanceFilter: 10,
      ),
    ).listen((Position posicionActual) async {
      if (_isAlarmRinging) return;

      final isar = DatabaseManager.instance;
      if (isar == null) return;

      final alarmas = await isar.alarmModels.where().anyId().findAll();
      final activas = alarmas.where((a) => a.isActive).toList();

      for (var alarma in activas) {
        if (alarma.latitude == 0.0) continue;

        double distancia = Geolocator.distanceBetween(
          posicionActual.latitude,
          posicionActual.longitude,
          alarma.latitude,
          alarma.longitude,
        );

        if (distancia <= alarma.radiusMeters) {
          _dispararAlarma(context, alarma, distancia);
          break;
        }
      }
    });
  }

  void _dispararAlarma(BuildContext context, AlarmModel alarma, 
      [double? distancia]) async {
    _isAlarmRinging = true;

    await AlarmSoundService.playAlarm();

    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(
        pattern: [0, 1000, 500, 1000],
        repeat: 1,
      );
    }
    
    await NotificationService.showAlarmNotification(
      alarma.id,
      '¡Alarma: ${alarma.name}!',
      distancia != null 
          ? 'Estás a ${distancia.toInt()} metros de tu destino.'
          : 'Es hora de tu alarma programada.',
    );

    if (!context.mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Icon(
              alarma.latitude == 0.0 ? Icons.alarm_on : Icons.location_on, 
              size: 60, 
              color: Colors.red,
            ),
            const SizedBox(height: 10),
            Text(
              "¡Alarma: ${alarma.name}!", 
              textAlign: TextAlign.center, 
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          distancia != null 
              ? "Has entrado a la zona de tu destino. Estás a ${distancia.toInt()} metros." 
              : "Es hora de tu alarma programada.",
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () async {
              await AlarmSoundService.stop();
              Vibration.cancel();

              final isar = DatabaseManager.instance!;
              await isar.writeTxn(() async {
                await isar.alarmModels.put(alarma);
              });
              _isAlarmRinging = false;
              await NotificationService.cancelNotification(alarma.id);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text("APAGAR ALARMA"),
          ),
        ],
      ),
    );
  }

  void detenerTodo() {
    _timeMonitor?.cancel();
    _locationSubscription?.cancel();
    Vibration.cancel();
  }
}