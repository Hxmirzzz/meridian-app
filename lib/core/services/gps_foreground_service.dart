import 'dart:io';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'gps_task_handler.dart';

class GpsForegroundService {
  static Future<void> initialize() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'meridian_gps_channel',
        channelName: 'Meridian GPS Service',
        channelDescription: 'Monitoreo de ubicación para alarmas de proximidad',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,
        onlyAlertOnce: true,
        showWhen: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.once(),
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  static Future<bool> requestPermissions() async {
    final status = await FlutterForegroundTask.checkNotificationPermission();
    if (status != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
    if (Platform.isAndroid) {
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }
    }
    return await FlutterForegroundTask.checkNotificationPermission() ==
        NotificationPermission.granted;
  }

  static Future<ServiceRequestResult> start() async {
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    }
    return FlutterForegroundTask.startService(
      serviceId: 256,
      notificationTitle: 'Meridian - Monitoreando ubicación',
      notificationText: 'Buscando alarmas de proximidad...',
      // Los botones van aquí en startService, no en AndroidNotificationOptions
      notificationButtons: [
        const NotificationButton(id: 'stop', text: 'Detener'),
      ],
      notificationInitialRoute: '/',
      callback: startGpsCallback,
    );
  }

  static Future<ServiceRequestResult> stop() async {
    return FlutterForegroundTask.stopService();
  }
}