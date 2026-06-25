import '../entities/alarm.dart';
import '../entities/holiday.dart';
import '../repositories/holiday_repository.dart';
import '../../core/utils/date_extensions.dart';

/// Resultado de la verificación de festivo para una alarma.
class HolidayVerificationResult {
  /// Si la alarma debe ejecutarse hoy.
  final bool shouldTrigger;

  /// Si hoy es festivo.
  final bool isTodayHoliday;

  /// El festivo de hoy (null si no es festivo).
  final Holiday? todayHoliday;

  /// Razón por la que no se dispara (si aplica).
  final String? reason;

  const HolidayVerificationResult({
    required this.shouldTrigger,
    required this.isTodayHoliday,
    this.todayHoliday,
    this.reason,
  });
}

/// Caso de uso: Verificar si una alarma debe dispararse teniendo en cuenta
/// si hoy es festivo en Colombia y la configuración de la alarma.
class VerifyHolidayAlarm {
  final HolidayRepository _holidayRepository;

  const VerifyHolidayAlarm(this._holidayRepository);

  /// Verifica si la [alarm] debe dispararse en [date] (por defecto hoy).
  Future<HolidayVerificationResult> execute({
    required Alarm alarm,
    DateTime? date,
  }) async {
    final DateTime checkDate = (date ?? DateTime.now()).startOfDay;

    // Si la alarma no excluye festivos, siempre debe dispararse
    if (!alarm.excludeHolidays) {
      return const HolidayVerificationResult(
        shouldTrigger: true,
        isTodayHoliday: false,
      );
    }

    // Consultar festivos
    final List<Holiday> holidays = await _holidayRepository.getHolidays();
    Holiday? todayHoliday;

    for (final holiday in holidays) {
      if (holiday.date.startOfDay.isSameDay(checkDate)) {
        todayHoliday = holiday;
        break;
      }
    }

    final bool isHoliday = todayHoliday != null;

    if (isHoliday) {
      return HolidayVerificationResult(
        shouldTrigger: false,
        isTodayHoliday: true,
        todayHoliday: todayHoliday,
        reason: 'Festivo: ${todayHoliday!.name}. La alarma está desactivada hoy.',
      );
    }

    return const HolidayVerificationResult(
      shouldTrigger: true,
      isTodayHoliday: false,
    );
  }
}