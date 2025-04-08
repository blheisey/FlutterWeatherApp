import 'package:cloud_firestore/cloud_firestore.dart';


class WeatherService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchCurrentWeather() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('weather').doc('current').get();
      if (!snapshot.exists) {
        throw Exception("No current weather data found in Firestore.");
      }

      final data = snapshot.data() as Map<String, dynamic>;
      final currentData = data['current'];

      return {
        'location': currentData["location"]["name"],
        'temp_f': currentData["current"]["temp_f"],
        'condition': currentData["current"]["condition"]["text"],
        'feelslike_f': currentData["current"]["feelslike_f"],
        'uv': currentData["current"]["uv"],
        'wind_mph': currentData["current"]["wind_mph"],
        'gust_mph': currentData["current"]["gust_mph"],
        'wind_degree': currentData["current"]["wind_degree"],
        'wind_dir': currentData["current"]["wind_dir"],
        'vis_miles': currentData["current"]["vis_miles"],
        'humidity': currentData["current"]["humidity"],
      };
    } catch (e) {
      throw Exception("Error fetching current weather: $e");
    }
  }

  Future<Map<String, dynamic>> fetchForecastWeather() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('weather').doc('forecast').get();
      if (!snapshot.exists) {
        throw Exception("No forecast weather data found in Firestore.");
      }

      final data = snapshot.data() as Map<String, dynamic>;
      final forecastData = data['current']; // this matches your Firebase doc structure

      return {
        'sunset': forecastData["forecast"]["forecastday"][0]["astro"]["sunset"],
        'predictprecipin':
            forecastData["forecast"]["forecastday"][0]["day"]["totalprecip_in"],
        'moon_phase':
            forecastData["forecast"]["forecastday"][0]["astro"]["moon_phase"],
        'moon_illumination': forecastData["forecast"]["forecastday"][0]["astro"]
            ["moon_illumination"],
        'moonset':
            forecastData["forecast"]["forecastday"][0]["astro"]["moonset"],
        // Add more if needed
      };
    } catch (e) {
      throw Exception("Error fetching forecast weather: $e");
    }
  }
}
