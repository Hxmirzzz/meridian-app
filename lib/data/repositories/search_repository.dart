import '../datasources/remote_search_source.dart';
import '../models/location_model.dart';

/// Repositorio simple para búsqueda de ubicaciones
/// NO usa BLoC, solo Future-based (simple)
class SearchRepository {
  final RemoteSearchSource remoteSource;

  SearchRepository({required this.remoteSource});

  Future<List<LocationModel>> searchLocations(String query) async {
    if (query.isEmpty) return [];
    return await remoteSource.searchLocations(query);
  }

  Future<String> getReverseAddress(double lat, double lon) async {
    return await remoteSource.reverseSearch(lat, lon);
  }
}
