import 'package:flutter/material.dart';
import 'weather_service.dart';
import 'weather_card.dart'; // Import your WeatherCard widget 
import 'hourly_weather.dart'; // Import your HourlyForecastWidget widget
import 'seven_day_forecast.dart'; // Import your SevenDayForecast widget


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: FutureBuilder<List<Map<String, dynamic>>>(
      future: Future.wait([
    WeatherService().fetchWeather("Missoula", "/current.json"), // Fetch current weather
    WeatherService().fetchWeather("Missoula", "/forecast.json") // Fetch forecast weather
  ]),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator()); // Show loading spinner while waiting
    } else if (snapshot.hasError) {
      return Center(child: Text("Error: ${snapshot.error}")); // Handle errors
    } else if (snapshot.hasData) {
      // Extract data from both responses
      final currentData = snapshot.data![0]; // First API response (current weather)
      final forecastData = snapshot.data![1]; // Second API response (forecast)

      // Extract current weather details
      String location = currentData["location"]["name"];
      double tempf = currentData["current"]["temp_f"];
      String condition = currentData["current"]["condition"]["text"];
      double feelslikef = currentData["current"]["feelslike_f"];
      double uv = currentData["current"]["uv"];
      double wind_mph = currentData["current"]["wind_mph"];
      double gust_mph = currentData["current"]["gust_mph"];
      double winddegree = currentData["current"]["wind_degree"];
      String winddir = currentData["current"]["wind_dir"];
      double vis = currentData["current"]["vis_miles"];
      double humid = currentData["current"]["humidity"];

      // Extract forecast details
      String sunset = forecastData["forecast"]["forecastday"][0]["astro"]["sunset"];
      double predictprecipin = forecastData["forecast"]["forecastday"][0]["day"]["totalprecip_in"];
      String moonphase = forecastData["forecast"]["forecastday"][0]["astro"]["moon_phase"];
      double moonillumination = forecastData["forecast"]["forecastday"][0]["astro"]["moon_illumination"];
      String moonset = forecastData["forecast"]["forecastday"][0]["astro"]["moonset"];
      List<dynamic> hourlyData = forecastData["forecast"]["forecastday"][0]["hour"];

      List<double> hourlytemps = [];
      List<String> hourlytimes = [];

      for (var hour in hourlyData) {
        hourlytemps.add(hour["temp_f"].toDouble()); // Ensure it's a double
        hourlytimes.add(hour["time"].toString());  // Ensure it's a string
      }

          return MyHomePage(loc: location, tempF: tempf, cond: condition, feelslikeF: feelslikef, uvIndex: uv, windMPH: wind_mph, gustMPH: gust_mph, windDegree: winddegree, windDir: winddir, visibility: vis, humidity: humid, sundown: sunset, predictPrecipIn: predictprecipin, moonPhase: moonphase, moonSet: moonset, moonIllumination: moonillumination, hourlyTimes: hourlytimes, hourlyTemps: hourlytemps); // Pass it to your home screen
      } else {
        return Center(child: Text("No data available"));
      }
      },
    ),

    );
  }
}

class MyHomePage extends StatelessWidget {
  final String loc;
  final double tempF;
  final String cond;
  final double feelslikeF;
  final double uvIndex;
  final double windMPH; 
  final double gustMPH;
  final double windDegree;
  final String windDir;
  final double visibility;
  final double humidity;
  final String sundown;
  final double predictPrecipIn;
  final String moonPhase;
  final String moonSet;
  final double moonIllumination;
  final List<String> hourlyTimes; // Added for hourly forecast
  final List<double> hourlyTemps; // Added for hourly forecast
  

  const MyHomePage({super.key, required this.loc, required this.tempF, required this.cond, required this.feelslikeF, required this.uvIndex, required this.windMPH, required this.gustMPH, required this.windDegree, required this.windDir, required this.visibility, required this.humidity, required this.sundown, required this.predictPrecipIn, required this.moonPhase, required this.moonSet, required this.moonIllumination, required this.hourlyTimes, required this.hourlyTemps});

  @override
 Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("Weather App")),
    body: 
      SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Location: $loc\n"
            "Temperature: $tempF°F\n"
            "Condition: $cond",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20), // Spacing

          HourlyForecastWidget(
            hourlyTimes: hourlyTimes,
            hourlyTemps: hourlyTemps,
          ), // Hourly forecast widget
//////////////////////////////////////////////////////////////////////////////////////////////////////
          SizedBox(
          height: 400,  // Adjust the height as needed
          child: WeatherHomePage(),
    ),
          // Row containing "Feels like" and "UV Index"
          Row(
            children: [
              Expanded(
                child: WeatherCard(
                  title: "Feels like",
                  value: "$feelslikeF°F",
                ),
              ),
              SizedBox(width: 10), // Spacing between cards
              Expanded(
                child: WeatherCard(
                  title: "UV Index",
                  value: "$uvIndex",
                ),
              ),
            ],
          ),

          SizedBox(height: 10), // Spacing

          // "Wind" card takes the full width of the two above combined
          Container(
            width: double.infinity, // Match parent width
            child: WeatherCard(
              title: "Wind",
              value: """Speed: ${windMPH.toString()} mph
Gust: ${gustMPH.toString()} mph
Direction: ${windDegree.toString()}° $windDir""",
            ),
          ),

          Row(
            children: [
              Expanded(
                child: WeatherCard(
                  title: "Sunset",
                  value: "$sundown",
                ),
              ),
              SizedBox(width: 10), // Spacing between cards
              Expanded(
                child: WeatherCard(
                  title: "Total Precipitation",
                  value: "$predictPrecipIn in",
                ),

                
              ),
            ],
          ),

           Row(
            children: [
              Expanded(
                child: WeatherCard(
                  title: "Visibility",
                  value: "$visibility miles",
                ),
              ),
              SizedBox(width: 10), // Spacing between cards
              Expanded(
                child: WeatherCard(
                  title: "Humidity",
                  value: "$humidity%",
                ),

                
              ),
            ],
          ),

          SizedBox(height: 10), // Spacing

          // "Wind" card takes the full width of the two above combined
          Container(
            width: double.infinity, // Match parent width
            child: WeatherCard(
              title: "$moonPhase",
              value: """Illumination: ${moonIllumination.toString()}%
Next Moonset: $moonSet""",
            ),
           ),

          ],
          
      ),
    ),
  );
}

}

