import 'package:geolocator/geolocator.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_hardware_source.dart';

/// Implementación concreta de LocationRepository usando geolocator.
class LocationRepositoryImpl implements LocationRepository {
  final LocationHardwareSource _hardwareSource;

  const LocationRepositoryImpl(this._hardwareSource);

  @override
  Future<bool> requestPermissions() =>
      _hardwareSource.requestAllPermissions();

  @override
  Future<Position> getCurrentPosition() =>
      _hardwareSource.getCurrentPosition();

  @override
  Stream<Position> getPositionStream({required int intervalSeconds}) =>
      _hardwareSource.getPositionStream(intervalSeconds: intervalSeconds);

  @override
  Future<bool> isLocationServiceEnabled() =>
      _hardwareSource.isLocationServiceEnabled();

  @override
  Future<LocationPermission> checkPermission() =>
      _hardwareSource.checkPermission();
}