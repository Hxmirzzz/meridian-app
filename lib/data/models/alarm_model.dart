import 'package:isar_community/isar.dart';
import '../../domain/entities/alarm.dart';

part 'alarm_model.g.dart';

@collection
class AlarmModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String name;

  late double latitude;
  late double longitude;
  late int radiusMeters;
  late bool isActive;
  late bool excludeHolidays;
  late DateTime createdAt;
  late int alarmHour;
  late int alarmMinute;
  List<bool> activeDays = [true, true, true, true, true, false, false];
  DateTime? lastTriggered;

  /// Convierte el modelo de Isar en la entidad de dominio.
  Alarm toEntity() => Alarm(
        id: id,
        name: name,
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
        isActive: isActive,
        excludeHolidays: excludeHolidays,
        createdAt: createdAt,
        alarmHour: alarmHour,
        alarmMinute: alarmMinute,
        activeDays: activeDays,
      );

  /// Crea un modelo de Isar desde una entidad de dominio.
  static AlarmModel fromEntity(Alarm alarm) {
    final model = AlarmModel()
      ..id = alarm.id == 0 ? Isar.autoIncrement : alarm.id
      ..name = alarm.name
      ..latitude = alarm.latitude
      ..longitude = alarm.longitude
      ..radiusMeters = alarm.radiusMeters
      ..isActive = alarm.isActive
      ..excludeHolidays = alarm.excludeHolidays
      ..createdAt = alarm.createdAt
      ..alarmHour = alarm.alarmHour
      ..alarmMinute = alarm.alarmMinute
      ..activeDays = List<bool>.from(alarm.activeDays)
      ..lastTriggered = null;
    return model;
  }
}