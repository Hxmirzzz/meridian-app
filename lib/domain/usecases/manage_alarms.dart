import '../entities/alarm.dart';
import '../repositories/alarm_repository.dart';
import '../../core/constants/app_dimensions.dart';

/// Caso de uso: Gestión completa del ciclo de vida de las alarmas (CRUD).
/// Wrappea AlarmRepository añadiendo validaciones de dominio.
class ManageAlarms {
  final AlarmRepository _repository;

  const ManageAlarms(this._repository);

  // ── Read ───────────────────────────────────────────────────────────────────

  /// Obtiene todas las alarmas, ordenadas de más reciente a más antigua.
  Future<List<Alarm>> getAllAlarms() async {
    final alarms = await _repository.getAlarms();
    return alarms..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<Alarm?> getById(int id) => _repository.getAlarmById(id);

  // ── Create ─────────────────────────────────────────────────────────────────

  /// Crea y guarda una nueva alarma con validaciones de dominio.
  Future<Alarm> createAlarm({
    required String name,
    required double latitude,
    required double longitude,
    int radiusMeters = AppDimensions.radiusDefaultMeters,
    bool excludeHolidays = false,
  }) async {
    _validateName(name);
    _validateCoordinates(latitude, longitude);
    _validateRadius(radiusMeters);

    final alarm = Alarm(
      id: 0, // Isar asignará el ID real
      name: name.trim(),
      latitude: latitude,
      longitude: longitude,
      radiusMeters: radiusMeters,
      isActive: true, // Activa por defecto al crear
      excludeHolidays: excludeHolidays,
      createdAt: DateTime.now(),
    );

    return _repository.saveAlarm(alarm);
  }

  // ── Update ─────────────────────────────────────────────────────────────────

  /// Actualiza los datos de una alarma existente.
  Future<Alarm> updateAlarm(Alarm alarm) async {
    _validateName(alarm.name);
    _validateCoordinates(alarm.latitude, alarm.longitude);
    _validateRadius(alarm.radiusMeters);
    return _repository.updateAlarm(alarm);
  }

  /// Activa o desactiva una alarma por su ID.
  Future<Alarm> toggleAlarm(int id, {required bool isActive}) =>
      _repository.toggleAlarm(id, isActive: isActive);

  // ── Delete ─────────────────────────────────────────────────────────────────

  Future<void> deleteAlarm(int id) => _repository.deleteAlarm(id);

  // ── Validaciones de dominio ────────────────────────────────────────────────

  void _validateName(String name) {
    if (name.trim().isEmpty) {
      throw ArgumentError('El nombre de la alarma no puede estar vacío.');
    }
    if (name.trim().length > 50) {
      throw ArgumentError('El nombre no puede superar 50 caracteres.');
    }
  }

  void _validateCoordinates(double lat, double lon) {
    if (lat < -90 || lat > 90) {
      throw ArgumentError('Latitud inválida: $lat');
    }
    if (lon < -180 || lon > 180) {
      throw ArgumentError('Longitud inválida: $lon');
    }
  }

  void _validateRadius(int radiusMeters) {
    if (radiusMeters < AppDimensions.radiusMinMeters ||
        radiusMeters > AppDimensions.radiusMaxMeters) {
      throw ArgumentError(
        'El radio debe estar entre ${AppDimensions.radiusMinMeters}m '
        'y ${AppDimensions.radiusMaxMeters}m.',
      );
    }
  }
}