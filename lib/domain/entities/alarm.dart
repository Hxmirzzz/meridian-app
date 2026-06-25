import 'package:equatable/equatable.dart';

/// Entidad de dominio que representa una alarma de proximidad.
class Alarm extends Equatable {
  /// Identificador único (generado por Isar DB).
  final int id;

  /// Nombre descriptivo de la parada. Ej: "Portal 80 - Carrera 80"
  final String name;

  /// Latitud del punto de destino en grados decimales.
  final double latitude;

  /// Longitud del punto de destino en grados decimales.
  final double longitude;

  /// Radio de alerta en metros. Rango: 100 – 2000 m.
  final int radiusMeters;

  /// Si la alarma está habilitada y debe escuchar la ubicación.
  final bool isActive;

  /// Si es true, la alarma no se dispara en días festivos de Colombia.
  final bool excludeHolidays;

  /// Fecha y hora de creación (para ordenar la lista).
  final DateTime createdAt;
  final int alarmHour;
  final int alarmMinute;
  final List<bool> activeDays;

  const Alarm({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    required this.isActive,
    required this.excludeHolidays,
    required this.createdAt,
    this.alarmHour = 0,
    this.alarmMinute = 0,
    this.activeDays = const [true, true, true, true, true, false, false],
  });

  Alarm copyWith({
    int? id,
    String? name,
    double? latitude,
    double? longitude,
    int? radiusMeters,
    bool? isActive,
    bool? excludeHolidays,
    DateTime? createdAt,
    int? alarmHour,
    int? alarmMinute,
    List<bool>? activeDays,
  }) {
    return Alarm(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusMeters: radiusMeters ?? this.radiusMeters,
      isActive: isActive ?? this.isActive,
      excludeHolidays: excludeHolidays ?? this.excludeHolidays,
      createdAt: createdAt ?? this.createdAt,
      alarmHour: alarmHour ?? this.alarmHour,
      alarmMinute: alarmMinute ?? this.alarmMinute,
      activeDays: activeDays ?? this.activeDays
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        latitude,
        longitude,
        radiusMeters,
        isActive,
        excludeHolidays,
        createdAt,
        alarmHour,
        alarmMinute,
        activeDays,
      ];

  @override
  String toString() =>
      'Alarm(id: $id, name: "$name", radius: ${radiusMeters}m, active: $isActive)';
}