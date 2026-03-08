import 'dart:convert';

import 'package:http/http.dart' as http;

class GeocodingResult {
  const GeocodingResult({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

  final String displayName;
  final double latitude;
  final double longitude;
}

abstract class GeocodingService {
  Future<List<GeocodingResult>> searchAddress(String query);
}

class NominatimGeocodingService implements GeocodingService {
  NominatimGeocodingService({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<List<GeocodingResult>> searchAddress(String query) async {
    if (query.trim().isEmpty) return const [];
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent('$query, Kinshasa, RDC')}&format=jsonv2&limit=10',
    );
    final response = await _client.get(
      uri,
      headers: {'User-Agent': 'ndaku-mobile-app/1.0'},
    );
    if (response.statusCode != 200) return const [];
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((item) {
      final map = item as Map<String, dynamic>;
      return GeocodingResult(
        displayName: (map['display_name'] as String?) ?? '',
        latitude: double.tryParse((map['lat'] as String?) ?? '') ?? 0,
        longitude: double.tryParse((map['lon'] as String?) ?? '') ?? 0,
      );
    }).toList();
  }
}
