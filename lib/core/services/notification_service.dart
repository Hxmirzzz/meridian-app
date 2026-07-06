import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();

  static final StreamController<String> _alarmActionController = 
      StreamController<String>.broadcast();
  static Stream<String> get onAlarmAction => _alarmActionController.stream;

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    
    await _notifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationResponse,
    );

    final androidChannel = AndroidNotificationChannel(
      'alarm_channel_v3',
      'Alarmas',
      description: 'Canal para alarmas de Meridian',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000, 500, 1000]),
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  static Future<void> showAlarmNotification(int id, String title, String body) async {
    final androidDetails = AndroidNotificationDetails(
      'alarm_channel_v3',
      'Alarmas',
      channelDescription: 'Canal para alarmas',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000, 500, 1000, 500, 1000]),
      category: AndroidNotificationCategory.alarm,
      fullScreenIntent: true,
      autoCancel: false,
      ongoing: true,
      visibility: NotificationVisibility.public,
      actions: [
        const AndroidNotificationAction(
          'stop_alarm',
          '🔴 APAGAR ALARMA',
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentSound: true,
      presentAlert: true,
      presentBadge: true,
    );

    await _notifications.show(
      id,
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  static void _onNotificationResponse(NotificationResponse response) {
    if (response.actionId == 'stop_alarm') {
      _alarmActionController.add('stop');
    }
  }

  @pragma('vm:entry-point')
  static void _onBackgroundNotificationResponse(NotificationResponse response) {
    if (response.actionId == 'stop_alarm') {
      _alarmActionController.add('stop');
      _notifications.cancel(response.id ?? 0);
    }
  }
}