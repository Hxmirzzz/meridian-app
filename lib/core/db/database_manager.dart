import 'package:isar_community/isar.dart';

class DatabaseManager {
  static Isar? get instance => Isar.getInstance("meridian_db");
}