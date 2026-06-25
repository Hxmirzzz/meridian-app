import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/location_model.dart';
import '../../core/constants/api_keys.dart';

class RemoteSearchSource {
  static const String _userAgent = 'MeridianApp/1.0';
  final http.Client client;

  RemoteSearchSource({http.Client? client}) : client = client ?? http.Client();

  Future<List<LocationModel>> searchLocations(String query) async {
    try {
      print('🔍 Buscando en Mapbox: $query');
      
      final uri = Uri.parse('https://api.mapbox.com/search/searchbox/v1/forward').replace(
        queryParameters: {
          'q': query,
          'access_token': ApiKeys.mapboxToken,
          'proximity': '-74.0721,4.6097',
          'country': 'CO',
          'language': 'es',
          'limit': '5',
        }
      );

      final response = await client.get(
        uri,
        headers: {'User-Agent': _userAgent},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Timeout en búsqueda'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List<dynamic>? ?? [];
        
        if (features.isEmpty) {
          print("⚠️ Sin resultados para: $query");
          return [];
        }

        return features.map<LocationModel>((feature) {
          final coords = feature['geometry']['coordinates'] as List<dynamic>;
          final props = feature['properties'] as Map<String, dynamic>;
          final name = props['name'] ?? '';
          final address = props['full_address'] ?? '';
          
          String displayName = '';
          if (name.isNotEmpty && address.isNotEmpty) {
            displayName = '$name, $address';
          } else if (name.isNotEmpty) {
            displayName = name;
          } else {
            displayName = address;
          }

          return LocationModel(
            placeId: (props['mapbox_id']?.toString() ?? query).hashCode,
            displayName: displayName,
            lat: double.parse(coords[1].toString()),
            lon: double.parse(coords[0].toString()),
            type: props['feature_type'] ?? 'place',
          );
        }).toList();
        
      } else {
        throw Exception('Error API: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  Future<String> reverseSearch(double lat, double lon) async {
    try {
      final uri = Uri.parse('https://api.mapbox.com/geocoding/v5/mapbox.places/$lon,$lat.json').replace(
        queryParameters: {
          'access_token': ApiKeys.mapboxToken,
          'language': 'es',
        }
      );

      final response = await client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List<dynamic>? ?? [];
        if (features.isNotEmpty) {
          return features[0]['place_name'] ?? 'Ubicación desconocida';
        }
      }
      return 'Ubicación desconocida';
    } catch (e) {
      return 'Error al obtener dirección';
    }
  }
}
