import '../../domain/entities/holiday.dart';
import '../../domain/repositories/holiday_repository.dart';
import '../datasources/holiday_local_source.dart';
import '../../core/utils/date_extensions.dart';

class HolidayRepositoryImpl implements HolidayRepository {
  final HolidayLocalSource _localSource;

  const HolidayRepositoryImpl(this._localSource);

  @override
  Future<List<Holiday>> getHolidays() async {
    final models = await _localSource.loadHolidays();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<bool> isHoliday(DateTime date) async {
    final holidays = await getHolidays();
    return holidays.any((h) => h.date.startOfDay.isSameDay(date.startOfDay));
  }

  @override
  Future<List<Holiday>> getHolidaysByYear(int year) async {
    final holidays = await getHolidays();
    return holidays.where((h) => h.date.year == year).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }
}