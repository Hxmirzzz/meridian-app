import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class HolidayService extends ChangeNotifier {
  static final HolidayService _instance = HolidayService._internal();
  factory HolidayService() => _instance;
  HolidayService._internal();

  List<DateTime> _defaultHolidays = [];
  List<DateTime> _customHolidays = [];
  List<DateTime> _removedHolidays = [];
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    
    final String jsonString = await rootBundle.loadString('assets/data/holidays_colombia.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _defaultHolidays = jsonList
        .map((item) => DateTime.parse(item['date']))
        .toList();

    final prefs = await SharedPreferences.getInstance();
    final customList = prefs.getStringList('custom_holidays') ?? [];
    final removedList = prefs.getStringList('removed_holidays') ?? [];
    
    _customHolidays = customList.map((d) => DateTime.parse(d)).toList();
    _removedHolidays = removedList.map((d) => DateTime.parse(d)).toList();
    
    _initialized = true;
  }

  bool isHoliday(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    
    final isDefault = _defaultHolidays.any((h) => 
      h.year == normalized.year && h.month == normalized.month && h.day == normalized.day
    );
    final isRemoved = _removedHolidays.any((h) => 
      h.year == normalized.year && h.month == normalized.month && h.day == normalized.day
    );
    
    final isCustom = _customHolidays.any((h) => 
      h.year == normalized.year && h.month == normalized.month && h.day == normalized.day
    );

    return (isDefault && !isRemoved) || isCustom;
  }

  bool isDefaultHoliday(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return _defaultHolidays.any((h) => 
      h.year == normalized.year && h.month == normalized.month && h.day == normalized.day
    );
  }

  List<DateTime> getAllHolidaysForYear(int year) {
    final List<DateTime> result = [];
    
    for (final h in _defaultHolidays) {
      if (h.year == year && !_removedHolidays.any((r) => 
        r.year == h.year && r.month == h.month && r.day == h.day)) {
        result.add(h);
      }
    }
    
    for (final h in _customHolidays) {
      if (h.year == year && !result.any((r) => 
        r.year == h.year && r.month == h.month && r.day == h.day)) {
        result.add(h);
      }
    }
    
    return result..sort((a, b) => a.compareTo(b));
  }

  Future<void> addCustomHoliday(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);
    if (!_customHolidays.any((h) => h.isAtSameMomentAs(normalized))) {
      _customHolidays.add(normalized);
      await _save();
      notifyListeners();
    }
  }

  Future<void> removeHoliday(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);
    
    if (_defaultHolidays.any((h) => h.isAtSameMomentAs(normalized))) {
      if (!_removedHolidays.any((h) => h.isAtSameMomentAs(normalized))) {
        _removedHolidays.add(normalized);
      }
    }
    
    _customHolidays.removeWhere((h) => h.isAtSameMomentAs(normalized));
    
    await _save();
    notifyListeners();
  }

  Future<void> restoreDefaultHolidays() async {
    _customHolidays.clear();
    _removedHolidays.clear();
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('custom_holidays', 
      _customHolidays.map((d) => d.toIso8601String().substring(0, 10)).toList());
    await prefs.setStringList('removed_holidays', 
      _removedHolidays.map((d) => d.toIso8601String().substring(0, 10)).toList());
  }
}