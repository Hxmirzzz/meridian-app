import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/services/holiday_service.dart';

class HolidaysScreen extends StatefulWidget {
  const HolidaysScreen({super.key});

  @override
  State<HolidaysScreen> createState() => _HolidaysScreenState();
}

class _HolidaysScreenState extends State<HolidaysScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final holidayService = HolidayService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Festivos de Colombia'),
        actions: [
          TextButton(
            onPressed: () async {
              await holidayService.restoreDefaultHolidays();
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Festivos restaurados')),
              );
            },
            child: const Text('RESTAURAR', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2024),
            lastDay: DateTime(2030),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
            },
            holidayPredicate: (day) {
              return holidayService.isHoliday(day);
            },
            calendarStyle: CalendarStyle(
              holidayDecoration: BoxDecoration(
                color: Colors.red.shade100,
                shape: BoxShape.circle,
              ),
              holidayTextStyle: TextStyle(color: Colors.red.shade800),
            ),
          ),
          const SizedBox(height: 20),
          if (_selectedDay != null) ...[
            Text(
              'Fecha seleccionada: ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (holidayService.isHoliday(_selectedDay!))
              ElevatedButton.icon(
                onPressed: () async {
                  await holidayService.removeHoliday(_selectedDay!);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Festivo eliminado')),
                  );
                },
                icon: const Icon(Icons.delete),
                label: const Text('Eliminar festivo'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              )
            else
              ElevatedButton.icon(
                onPressed: () async {
                  await holidayService.addCustomHoliday(_selectedDay!);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Festivo agregado')),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Agregar festivo'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
          ],
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Los días en rojo son festivos. Las alarmas con "Silenciar en festivos" no sonarán esos días.',
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}