import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String baseUrl = 'https://8212000ghosn.000webhostapp.com/weather_history.php';

  Future<Map<String, dynamic>> getCurrentWeather(String location) async {
    final response = await http.get(Uri.parse('$baseUrl?q=$location'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<void> insertWeather(String location, double temperature, String description, int timestamp) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'location': location,
        'temperature': temperature,
        'description': description,
        'timestamp': timestamp,
      }),
    );

    if (response.statusCode == 200) {
      print('Weather history saved successfully');
    } else {
      throw Exception('Failed to save weather history');
    }
  }

  Future<List<Map<String, dynamic>>> getWeatherHistory() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather history');
    }
  }
}
