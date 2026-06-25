import 'package:geolocator/geolocator.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/haversine.dart';
import '../entities/alarm.dart';

/// Resultado del cálculo de geofence.
class GeofenceResult {
  /// Distancia actual al destino en metros.
  final double distanceMeters;

  /// Intervalo de consulta GPS recomendado en segundos (frecuencia dinámica).
  final int recommendedIntervalSeconds;

  /// Si la distancia es menor o igual al radio de la alarma.
  final bool isInsideGeofence;

  /// Descripción legible de la distancia.
  final String formattedDistance;

  const GeofenceResult({
    required this.distanceMeters,
    required this.recommendedIntervalSeconds,
    required this.isInsideGeofence,
    required this.formattedDistance,
  });
}

/// Caso de uso: Calcular si el usuario está dentro del geofence de una alarma
/// y qué frecuencia GPS debe usarse (algoritmo de frecuencia dinámica).
///
/// Algoritmo de frecuencia dinámica:
/// - distancia > 5 km   → 60 s
/// - distancia 1–5 km   → 30 s
/// - distancia < 1 km   → 10 s
/// - distancia < 300 m  → 5 s (modo alerta)
class CalculateGeofence {
  const CalculateGeofence();

  /// Ejecuta el cálculo dado la [currentPosition] y la [alarm] objetivo.
  GeofenceResult execute({
    required Position currentPosition,
    required Alarm alarm,
  }) {
    final double distanceMeters = Haversine.distanceInMeters(
      lat1: currentPosition.latitude,
      lon1: currentPosition.longitude,
      lat2: alarm.latitude,
      lon2: alarm.longitude,
    );

    final bool isInside = distanceMeters <= alarm.radiusMeters;

    final int interval = _resolveInterval(distanceMeters);

    return GeofenceResult(
      distanceMeters: distanceMeters,
      recommendedIntervalSeconds: interval,
      isInsideGeofence: isInside,
      formattedDistance: Haversine.formatDistance(distanceMeters),
    );
  }

  /// Determina el intervalo GPS óptimo según la distancia al destino.
  int _resolveInterval(double distanceMeters) {
    if (distanceMeters < AppDimensions.thresholdNear) {
      // < 300 m → modo alerta, máxima frecuencia
      return AppDimensions.gpsIntervalAlert;
    } else if (distanceMeters < AppDimensions.thresholdMedium) {
      // < 1 km
      return AppDimensions.gpsIntervalNear;
    } else if (distanceMeters < AppDimensions.thresholdFar) {
      // 1 – 5 km
      return AppDimensions.gpsIntervalMedium;
    } else {
      // > 5 km
      return AppDimensions.gpsIntervalFar;
    }
  }
}