import 'package:latlong2/latlong.dart';

/// Modelo para resultados de múltiples APIs de geocodificación
class LocationModel {
  final int placeId;
  final String displayName;
  final double lat;
  final double lon;
  final String type; // "amenity", "building", "road", etc.

  LocationModel({
    required this.placeId,
    required this.displayName,
    required this.lat,
    required this.lon,
    required this.type,
  });

  /// Factory para parsear JSON de Nominatim
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      placeId: json['place_id'] ?? 0,
      displayName: json['display_name'] ?? 'Sin nombre',
      lat: double.parse(json['lat']?.toString() ?? '0'),
      lon: double.parse(json['lon']?.toString() ?? '0'),
      type: json['type'] ?? 'unknown',
    );
  }

  /// Factory para parsear JSON de OpenCage Geocoder
  factory LocationModel.fromOpenCageJson(Map<String, dynamic> json) {
    final geometry = json['geometry'] as Map<String, dynamic>? ?? {};
    final components = json['components'] as Map<String, dynamic>? ?? {};
    
    String displayName = json['formatted'] ?? 'Sin nombre';
    
    return LocationModel(
      placeId: json['place_id']?.hashCode ?? 0,
      displayName: displayName,
      lat: double.parse(geometry['lat']?.toString() ?? '0'),
      lon: double.parse(geometry['lng']?.toString() ?? '0'),
      type: components['_type'] ?? 'place',
    );
  }

  /// Factory para parsear JSON de Geoapify
  /// Busca lugares, negocios y POIs
  factory LocationModel.fromGeoapifyJson(Map<String, dynamic> json) {
    final properties = json['properties'] as Map<String, dynamic>? ?? {};
    final geometry = json['geometry'] as Map<String, dynamic>? ?? {};
    final coords = geometry['coordinates'] as List<dynamic>? ?? [0, 0];
    
    // Construir displayName con información disponible
    final name = properties['name'] ?? '';
    final street = properties['street'] ?? '';
    final city = properties['city'] ?? '';
    final country = properties['country'] ?? '';
    
    String displayName = name;
    if (street.isNotEmpty) displayName += ', $street';
    if (city.isNotEmpty) displayName += ', $city';
    
    // lon, lat (Geoapify usa [lon, lat])
    final lon = coords.isNotEmpty ? double.parse(coords[0].toString()) : 0.0;
    final lat = coords.length > 1 ? double.parse(coords[1].toString()) : 0.0;
    
    return LocationModel(
      placeId: properties['place_id']?.hashCode ?? displayName.hashCode,
      displayName: displayName.isNotEmpty ? displayName : 'Ubicación',
      lat: lat,
      lon: lon,
      type: properties['type'] ?? properties['result_type'] ?? 'place',
    );
  }

  /// Factory para parsear JSON de Google Places API
  factory LocationModel.fromGooglePlacesJson(Map<String, dynamic> json) {
    final geometry = json['geometry'] as Map<String, dynamic>? ?? {};
    final location = geometry['location'] as Map<String, dynamic>? ?? {};
    
    final name = json['name'] ?? '';
    final address = json['formatted_address'] ?? '';
    final types = json['types'] as List<dynamic>? ?? [];
    
    String displayName = name;
    if (address.isNotEmpty && address != name) {
      displayName = '$name, $address';
    } else if (address.isNotEmpty) {
      displayName = address;
    }
    
    final lat = double.parse(location['lat']?.toString() ?? '0');
    final lon = double.parse(location['lng']?.toString() ?? '0');
    final typeStr = types.isNotEmpty ? types[0] : 'place';
    
    return LocationModel(
      placeId: json['place_id']?.hashCode ?? displayName.hashCode,
      displayName: displayName.isNotEmpty ? displayName : 'Ubicación',
      lat: lat,
      lon: lon,
      type: typeStr,
    );
  }

  /// Factory para parsear JSON de Mapbox Geocoding
  factory LocationModel.fromMapboxJson(Map<String, dynamic> json) {
    final coords = json['geometry']['coordinates'] as List<dynamic>? ?? [0, 0];
    
    return LocationModel(
      placeId: (json['id']?.toString() ?? 'place').hashCode,
      displayName: json['place_name'] ?? json['text'] ?? 'Ubicación',
      lat: double.parse(coords[1].toString()), // Mapbox: [lon, lat]
      lon: double.parse(coords[0].toString()),
      type: json['properties']?['category'] ?? json['relevance']?.toString() ?? 'place',
    );
  }

  /// Convierte a LatLng para flutter_map
  LatLng toLatLng() => LatLng(lat, lon);

  @override
  String toString() => displayName;
}
