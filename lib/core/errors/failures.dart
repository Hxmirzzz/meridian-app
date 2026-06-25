/// Jerarquía de errores tipados de Meridian.
/// Basado en el patrón Either / Failure de Clean Architecture.
abstract class Failure {
  final String message;
  final StackTrace? stackTrace;

  const Failure(this.message, [this.stackTrace]);

  @override
  String toString() => '$runtimeType: $message';
}

/// Error al acceder o escribir en Isar DB.
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, [super.stackTrace]);
}

/// Error al obtener permisos de ubicación / notificaciones.
class PermissionFailure extends Failure {
  const PermissionFailure(super.message, [super.stackTrace]);
}

/// Error al obtener la ubicación del GPS.
class LocationFailure extends Failure {
  const LocationFailure(super.message, [super.stackTrace]);
}

/// Error al leer el JSON de festivos.
class HolidayDataFailure extends Failure {
  const HolidayDataFailure(super.message, [super.stackTrace]);
}

/// Error al lanzar / cancelar notificación local.
class NotificationFailure extends Failure {
  const NotificationFailure(super.message, [super.stackTrace]);
}