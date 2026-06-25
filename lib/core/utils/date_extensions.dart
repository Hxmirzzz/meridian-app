/// Extensiones de utilidad sobre [DateTime] para Meridian.
extension DateTimeExtensions on DateTime {
  /// Retorna true si este DateTime representa el mismo día calendario
  /// que [other], ignorando la hora.
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Retorna una representación legible en español.
  /// Ejemplo: "lunes, 10 de junio de 2026"
  String toSpanishReadable() {
    const months = [
      '', 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    const days = [
      '', 'lunes', 'martes', 'miércoles', 'jueves',
      'viernes', 'sábado', 'domingo',
    ];
    final weekday = days[this.weekday];
    return '$weekday, $day de ${months[month]} de $year';
  }

  /// Retorna solo la parte de fecha (sin hora) como String ISO.
  /// Ejemplo: "2026-06-10"
  String toDateOnlyString() =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';

  /// Retorna true si la fecha es fin de semana (sábado o domingo).
  bool get isWeekend => weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Retorna el inicio del día (00:00:00.000).
  DateTime get startOfDay => DateTime(year, month, day);
}