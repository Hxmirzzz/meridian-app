import 'package:geolocator/geolocator.dart';
import '../../core/errors/failures.dart';

/// Fuente de datos de hardware para la geolocalización.
/// Wrappea el plugin geolocator con manejo de errores y configuración.
class LocationHardwareSource {
  /// Configuración de precisión alta (para modo alerta y primer uso).
  static const LocationSettings _highAccuracySettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // solo emite si se mueve > 10 m
  );

  /// Configuración de precisión balanceada (para distancias medias).
  static const LocationSettings _balancedSettings = LocationSettings(
    accuracy: LocationAccuracy.medium,
    distanceFilter: 50,
  );

  /// Configuración de bajo consumo (para distancias > 5 km).
  static const LocationSettings _lowPowerSettings = LocationSettings(
    accuracy: LocationAccuracy.low,
    distanceFilter: 100,
  );

  // ── Permisos ──────────────────────────────────────────────────────────────

  Future<LocationPermission> checkPermission() =>
      Geolocator.checkPermission();

  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  /// Solicita permisos de ubicación completos (siempre + en segundo plano).
  /// Retorna true si se concedieron permisos suficientes para operar.
  Future<bool> requestAllPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationFailure(
        'Los servicios de ubicación están desactivados. '
        'Actívalos en Configuración del dispositivo.',
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const PermissionFailure(
          'Permiso de ubicación denegado. '
          'Meridian necesita acceso a la ubicación para funcionar.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const PermissionFailure(
        'Permiso de ubicación denegado permanentemente. '
        'Ve a Configuración > Aplicaciones > Meridian para habilitarlo.',
      );
    }

    return true;
  }

  // ── Posición actual ───────────────────────────────────────────────────────

  /// Obtiene la posición actual del dispositivo (consulta puntual).
  Future<Position> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: _highAccuracySettings,
      );
    } catch (e, st) {
      throw LocationFailure('Error al obtener ubicación actual: $e', st);
    }
  }

  // ── Stream de posición ────────────────────────────────────────────────────

  /// Retorna un stream de actualizaciones de ubicación.
  /// [intervalSeconds] determina la configuración de precisión/batería.
  Stream<Position> getPositionStream({required int intervalSeconds}) {
    final settings = _settingsForInterval(intervalSeconds);
    return Geolocator.getPositionStream(locationSettings: settings);
  }

  /// Selecciona la configuración de GPS adecuada según el intervalo.
  LocationSettings _settingsForInterval(int intervalSeconds) {
    if (intervalSeconds <= 10) return _highAccuracySettings;
    if (intervalSeconds <= 30) return _balancedSettings;
    return _lowPowerSettings;
  }
}