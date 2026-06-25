import '../entities/alarm.dart';

/// Contrato abstracto del repositorio de alarmas.
/// La implementación concreta vive en data/repositories/alarm_repository_impl.dart.
abstract class AlarmRepository {
  /// Obtiene todas las alarmas guardadas en Isar DB.
  Future<List<Alarm>> getAlarms();

  /// Guarda una nueva alarma. Retorna la alarma con el ID asignado por Isar.
  Future<Alarm> saveAlarm(Alarm alarm);

  /// Actualiza una alarma existente (por ID).
  Future<Alarm> updateAlarm(Alarm alarm);

  /// Elimina la alarma con el [id] dado.
  Future<void> deleteAlarm(int id);

  /// Activa o desactiva la alarma con el [id] dado.
  Future<Alarm> toggleAlarm(int id, {required bool isActive});

  /// Obtiene una sola alarma por ID. Retorna null si no existe.
  Future<Alarm?> getAlarmById(int id);
}