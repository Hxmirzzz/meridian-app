import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';

@pragma('vm:entry-point')
void startGpsCallback() {
  FlutterForegroundTask.setTaskHandler(GpsTaskHandler());
}

class GpsTaskHandler extends TaskHandler {
  StreamSubscription<Position>? _positionStream;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
      ),
    ).listen((position) {
      FlutterForegroundTask.sendDataToMain({
        'type': 'location',
        'lat': position.latitude,
        'lng': position.longitude,
        'accuracy': position.accuracy,
      });
    });
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _positionStream?.cancel();
  }

  @override
  void onNotificationButtonPressed(String id) {
    if (id == 'stop') FlutterForegroundTask.stopService();
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp('/');
  }

  @override
  void onReceiveData(Object data) {}
  @override
  void onNotificationDismissed() {}
}