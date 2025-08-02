import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>?> searchPlace(String place) async {
  final url = Uri.parse("https://nominatim.openstreetmap.org/search?q=$place&format=json&addressdetails=1");

  final response = await http.get(url, headers: {
    'User-Agent' : 'FlutterApp', //TODO: Pq ela exige isso e bloqueia se não tiver?
    }
  );

  if(response.statusCode == 200) {
    // final List data = json.decode(response.body);
    // return data.map((e) => {
    //   'nome': e['display_name'],
    //   'latitude': e['lat'],
    //   'longitude': e['lon'],
    // }).toList();

    return jsonDecode(response.body);
  } else {
    throw Exception('There was an error on the attempt of searching places');
  }
}