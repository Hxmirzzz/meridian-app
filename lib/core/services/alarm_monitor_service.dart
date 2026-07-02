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
import 'holiday_service.dart';

class AlarmMonitorService {
  static final AlarmMonitorService _instance = AlarmMonitorService._internal();
  factory AlarmMonitorService() => _instance;
  AlarmMonitorService._internal();

  Timer? _timeMonitor;
  bool _isAlarmRinging = false;
  AlarmModel? _currentAlarm; 

  bool get isAlarmRingingPublic => _isAlarmRinging;
  AlarmModel? get currentAlarm => _currentAlarm;

  void iniciarMonitoreo(BuildContext context) {
    _iniciarMonitoreoReloj(context);
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

        if (alarma.excludeHolidays) {
          if (HolidayService().isHoliday(ahora)) {
            print("   ❌ Saltada: hoy es festivo");
            continue;
          }
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

  void procesarPosicionForeground(double lat, double lng) async {
    print("📍 [Main] Posición desde foreground: $lat, $lng");

    if (_isAlarmRinging) {
      print("⏰ Ya hay alarma sonando, saltando");
      return;
    }

    final ahora = DateTime.now();
    final isar = DatabaseManager.instance;
    if (isar == null) {
      print("❌ isar es null");
      return;
    }

    final alarmas = await isar.alarmModels.where().anyId().findAll();
    final activas = alarmas.where((a) => a.isActive).toList();
    print("📍 Alarmas activas: ${activas.length}");

    for (var alarma in activas) {
      print("   Revisando: ${alarma.name}, lat:${alarma.latitude}, lng:${alarma.longitude}");
      if (alarma.latitude == 0.0) {
        print("   ❌ Saltada: es alarma de reloj");
        continue;
      }

      // Control anti-repetición de 24 horas
      if (alarma.lastTriggered != null) {
        final diff = ahora.difference(alarma.lastTriggered!);
        if (diff.inHours < 24) {
          print("   ❌ Saltada: ya sonó hoy (GPS)");
          continue;
        }
      }

      double distancia = Geolocator.distanceBetween(
        lat,
        lng,
        alarma.latitude,
        alarma.longitude,
      );

      print("   📏 Distancia: ${distancia.toInt()}m (radio: ${alarma.radiusMeters}m)");

      if (distancia <= alarma.radiusMeters) {
        if (alarma.isInsideRadius) {
          print("   ⏳ Ya está dentro del radio, no sonar");
          continue;
        }

        print("   ✅ ENTRÓ AL RADIO! Disparando...");

        await isar.writeTxn(() async {
          alarma.isInsideRadius = true;
          alarma.lastTriggered = DateTime.now();
          await isar.alarmModels.put(alarma);
        });

        _dispararAlarmaDesdeForeground(alarma, distancia);
        break;
      } else {
        if (alarma.isInsideRadius) {
          print("   🚪 Salió del radio, reseteando...");
          await isar.writeTxn(() async {
            alarma.isInsideRadius = false;
            await isar.alarmModels.put(alarma);
          });
        }
        print("   ❌ Fuera del radio");
      }
    }
  }

  void _dispararAlarmaDesdeForeground(AlarmModel alarma, double distancia) async {
    _isAlarmRinging = true;
    _currentAlarm = alarma;

    await AlarmSoundService.playAlarm();

    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(pattern: [0, 1000, 500, 1000], repeat: 1);
    }

    await NotificationService.showAlarmNotification(
      alarma.id,
      '¡Alarma: ${alarma.name}!',
      'Estás a ${distancia.toInt()} metros de tu destino.',
    );
  }

  void _dispararAlarma(BuildContext? context, AlarmModel alarma, 
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

    if (context != null && context.mounted) {
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
                Vibration.cancel();
                await AlarmSoundService.stop();

                final isar = DatabaseManager.instance!;
                await isar.writeTxn(() async {
                  alarma.lastTriggered = DateTime.now();
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
  }

  void apagarAlarmaDesdeNotificacion() async {
    if (!_isAlarmRinging) return;
    
    print('🔴 Apagando alarma desde notificación...');
    Vibration.cancel();
    await AlarmSoundService.stop();
    _isAlarmRinging = false;
    _currentAlarm = null;
  }

  void detenerTodo() {
    _timeMonitor?.cancel();
    Vibration.cancel();
  }
}