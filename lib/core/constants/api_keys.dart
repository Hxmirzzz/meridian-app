import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  static String get mapboxToken => dotenv.env['MAPBOX_TOKEN'] ?? '';
}