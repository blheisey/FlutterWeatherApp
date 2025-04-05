import 'dart:convert';  
import 'package:http/http.dart' as http;  // For making HTTP requests

class WeatherService {
  // Define the API endpoint (e.g., OpenWeatherMap API)
  final String apiUrl = 'http://api.weatherapi.com/v1'; 
  final String apiKey = '5a2b518baaa643d297871947251003'; 

  // Function to fetch weather data by city name
  Future<Map<String, dynamic>> fetchWeather(String city, String method) async {

    try {

    Uri url;
    if (method == '/forecast.json'){
      url = Uri.parse('$apiUrl$method?q=$city&key=$apiKey');
    }
    else{
      url = Uri.parse('$apiUrl$method?q=$city&key=$apiKey');
    }
      // Make the HTTP request
      final response = await http.get(url);
      
      // Check if the response was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse and return the JSON data
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Failed to fetch weather data: $e');
    }
  }
}
