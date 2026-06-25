import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/holiday_model.dart';
import '../../core/errors/failures.dart';

/// Fuente de datos local para los festivos de Colombia.
/// Lee el JSON estático desde assets/data/holidays_colombia.json.
class HolidayLocalSource {
  static const String _assetPath = 'assets/data/holidays_colombia.json';

  /// Cache en memoria para evitar re-lecturas del asset.
  List<HolidayModel>? _cache;

  /// Carga y retorna todos los festivos desde el JSON de assets.
  /// Usa cache en memoria para lecturas subsiguientes.
  Future<List<HolidayModel>> loadHolidays() async {
    if (_cache != null) return _cache!;

    try {
      final String jsonString = await rootBundle.loadString(_assetPath);
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

      _cache = jsonList
          .map((e) => HolidayModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return _cache!;
    } catch (e, stackTrace) {
      throw HolidayDataFailure(
        'No se pudo cargar el archivo de festivos: $e',
        stackTrace,
      );
    }
  }

  /// Invalida el cache (útil para tests).
  void clearCache() => _cache = null;
}