import 'package:geolocator/geolocator.dart';

abstract class LocationRepository {
  Future<bool> requestPermissions();
  Future<Position> getCurrentPosition();
  Stream<Position> getPositionStream({required int intervalSeconds});
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkPermission();
}

// AQUI VOY -> INSTALAR LIBRERIA DE GEOLOCATOR Y CREAR LA IMPLEMENTACION CONCRETAMENTE PARA ANDROID Y IOS, USANDO EL REPOSITORIO ABSTRACTO.