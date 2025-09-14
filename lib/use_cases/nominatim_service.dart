import 'dart:convert';
import 'package:http/http.dart' as http;

/// Searches for a place using the Nominatim OpenStreetMap API.
///
/// This asynchronous function sends a GET request to the Nominatim API
/// to find places that match the given [place] query string.
/// It includes a 'User-Agent' header, which is a requirement of the API.
///
/// Throws an [Exception] if the API call fails with a fail status code
///
/// Returns a [Future<List<dynamic>?>] containing the JSON-decoded response
/// from the API, which is a list of potential place matches.
Future<List<dynamic>?> searchPlace(String place) async {
  final url = Uri.parse(
    'https://nominatim.openstreetmap.org/search?q=$place&format=json&addressdetails=1',
  );

  final response = await http.get(url, headers: {'User-Agent': 'FlutterApp'});

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('There was an error on the attempt of searching places');
  }
}
