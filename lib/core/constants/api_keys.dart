import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  static const String mapboxToken = '${dotenv.get("MAPBOX_TOKEN")}';
}