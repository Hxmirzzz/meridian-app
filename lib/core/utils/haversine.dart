import 'dart:math' as math;

/// Implementación de la Fórmula de Haversine.
/// Calcula la distancia en metros entre dos puntos GPS sobre la esfera terrestre.
///
/// La fórmula tiene en cuenta la curvatura de la Tierra y es precisa
/// para distancias cortas y medias (error < 0.5% hasta ~1000 km).
class Haversine {
  Haversine._();

  /// Radio medio de la Tierra en metros (WGS-84).
  static const double _earthRadiusMeters = 6371000.0;

  /// Calcula la distancia en metros entre [lat1, lon1] y [lat2, lon2].
  ///
  /// - [lat1], [lon1]: Coordenadas del punto de origen en grados decimales.
  /// - [lat2], [lon2]: Coordenadas del punto de destino en grados decimales.
  ///
  /// Retorna la distancia en metros.
  static double distanceInMeters({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return _earthRadiusMeters * c;
  }

  /// Convierte grados a radianes.
  static double _toRadians(double degrees) => degrees * math.pi / 180.0;

  /// Retorna una descripción legible de la distancia.
  /// Ejemplo: "1.2 km" o "350 m"
  static String formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
    return '${meters.round()} m';
  }
}