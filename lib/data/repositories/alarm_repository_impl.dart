import 'package:isar_community/isar.dart';
import '../../domain/entities/alarm.dart';
import '../../domain/repositories/alarm_repository.dart';
import '../models/alarm_model.dart';
import '../../core/errors/failures.dart';

class AlarmRepositoryImpl implements AlarmRepository {
  final Isar _isar;

  const AlarmRepositoryImpl(this._isar);

  @override
  Future<List<Alarm>> getAlarms() async {
    try {
      final models = await _isar.alarmModels.where().findAll();
      return models.map((m) => m.toEntity()).toList();
    } catch (e, st) {
      throw DatabaseFailure('Error al leer alarmas: $e', st);
    }
  }

  @override
  Future<Alarm> saveAlarm(Alarm alarm) async {
    try {
      final model = AlarmModel.fromEntity(alarm);
      await _isar.writeTxn(() async {
        await _isar.alarmModels.put(model);
      });
      return model.toEntity();
    } catch (e, st) {
      throw DatabaseFailure('Error al guardar alarma: $e', st);
    }
  }

  @override
  Future<Alarm> updateAlarm(Alarm alarm) async {
    try {
      final model = AlarmModel.fromEntity(alarm);
      await _isar.writeTxn(() async {
        await _isar.alarmModels.put(model);
      });
      return model.toEntity();
    } catch (e, st) {
      throw DatabaseFailure('Error al actualizar alarma: $e', st);
    }
  }

  @override
  Future<void> deleteAlarm(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.alarmModels.delete(id);
      });
    } catch (e, st) {
      throw DatabaseFailure('Error al eliminar alarma (id=$id): $e', st);
    }
  }

  @override
  Future<Alarm> toggleAlarm(int id, {required bool isActive}) async {
    try {
      late Alarm updated;
      await _isar.writeTxn(() async {
        final model = await _isar.alarmModels.get(id);
        if (model == null) {
          throw DatabaseFailure('Alarma con id=$id no encontrada.');
        }
        model.isActive = isActive;
        await _isar.alarmModels.put(model);
        updated = model.toEntity();
      });
      return updated;
    } catch (e, st) {
      if (e is DatabaseFailure) rethrow;
      throw DatabaseFailure('Error al cambiar estado de alarma: $e', st);
    }
  }

  @override
  Future<Alarm?> getAlarmById(int id) async {
    try {
      final model = await _isar.alarmModels.get(id);
      return model?.toEntity();
    } catch (e, st) {
      throw DatabaseFailure('Error al obtener alarma (id=$id): $e', st);
    }
  }
}