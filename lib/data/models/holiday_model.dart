import '../../domain/entities/holiday.dart';

/// Modelo de datos para deserializar el JSON de festivos de Colombia.
/// No usa Isar porque los festivos son datos de solo lectura cargados desde assets.
class HolidayModel {
  final String date;   // formato "YYYY-MM-DD"
  final String name;

  const HolidayModel({
    required this.date,
    required this.name,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json) => HolidayModel(
        date: json['date'] as String,
        name: json['name'] as String,
      );

  /// Convierte al entity de dominio.
  Holiday toEntity() => Holiday(
        date: DateTime.parse(date),
        name: name,
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'name': name,
      };
}