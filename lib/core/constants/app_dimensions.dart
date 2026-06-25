/// Constantes de dimensiones, intervalos y límites de la app.
class AppDimensions {
  AppDimensions._();

  // ── Radio de geofence ──────────────────────────────────────────────────────
  static const int radiusMinMeters = 100;
  static const int radiusDefaultMeters = 500;
  static const int radiusMaxMeters = 2000;

  // ── Algoritmo de frecuencia dinámica GPS (en segundos) ────────────────────
  static const int gpsIntervalFar = 60;       // > 5 km
  static const int gpsIntervalMedium = 30;    // 1 – 5 km
  static const int gpsIntervalNear = 10;      // < 1 km
  static const int gpsIntervalAlert = 5;      // < 300 m

  // ── Umbrales de distancia para frecuencia dinámica (en metros) ────────────
  static const double thresholdFar = 5000.0;
  static const double thresholdMedium = 1000.0;
  static const double thresholdNear = 300.0;

  // ── Vibración ─────────────────────────────────────────────────────────────
  /// Patrón: [espera, ON, OFF, ON, OFF, ...] en ms
  static const List<int> vibrationPattern = [
    0, 500, 300, 500, 300, 500, 300, 500, 300, 500,
  ];

  // ── UI ────────────────────────────────────────────────────────────────────
  static const double borderRadius = 16.0;
  static const double cardElevation = 0.0;
  static const double fabSize = 56.0;
  static const double mapPickerHeight = 300.0;

  // ── Notificación foreground service ───────────────────────────────────────
  static const int foregroundNotificationId = 888;
  static const int alarmNotificationId = 999;

  // ── Isar DB ───────────────────────────────────────────────────────────────
  static const String isarDbName = 'meridian_db';
}