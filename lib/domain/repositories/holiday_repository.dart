import '../entities/holiday.dart';

/// Contrato abstracto del repositorio de festivos.
abstract class HolidayRepository {
  Future<List<Holiday>> getHolidays();
  Future<bool> isHoliday(DateTime date);
  Future<List<Holiday>> getHolidaysByYear(int year);
}