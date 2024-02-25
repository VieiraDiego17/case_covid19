import 'dart:convert';
import 'package:http/http.dart' as http;

class CovidDataService {
  static const String _apiUrl = 'https://api.covidtracking.com/v1/us/current.json';

  Future<Map<String, dynamic>> fetchCovidData() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)[0];
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
