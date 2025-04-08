import 'package:flutter/material.dart';
import 'weather_service.dart';
import 'weather_card.dart'; // Import your WeatherCard widget 
import 'hourly_weather.dart'; // Import your HourlyForecastWidget widget
import 'seven_day_forecast.dart'; // Import your SevenDayForecast widget
import 'package:firebase_core/firebase_core.dart';




Future<void> main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: FutureBuilder<List<Map<String, dynamic>>>(
        future: Future.wait([
          WeatherService().fetchCurrentWeather(),
          WeatherService().fetchForecastWeather(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final currentData = snapshot.data![0];
            final forecastData = snapshot.data![1];

            // 🌤️ Extract current weather fields
            final String location = currentData['location'];
            final double tempf = (currentData['temp_f'] as num).toDouble();
            final String condition = currentData['condition'];
            final double feelslikef = (currentData['feelslike_f'] as num).toDouble();
            final double uv = (currentData['uv'] as num).toDouble();
            final double wind_mph = (currentData['wind_mph'] as num).toDouble();
            final double gust_mph = (currentData['gust_mph'] as num).toDouble();
            final double winddegree = currentData['wind_degree'].toDouble();
            final String winddir = currentData['wind_dir'];
            final double vis = (currentData['vis_miles'] as num).toDouble();
            final double humid = currentData['humidity'].toDouble();

            // 🌙 Extract forecast fields
            final forecastCurrent = forecastData['forecast'];
            final astro = forecastCurrent['forecastday'][0]['astro'];
            final hourList = forecastCurrent['forecastday'][0]['hour'];

            final String sunset = astro['sunset'];
            final double predictprecipin = (hourList[0]['precip_in'] as num).toDouble();
            final String moonphase = astro['moon_phase'];
            final String moonset = astro['moonset'];
            final double moonillumination = astro['moon_illumination'].toDouble();

            // 🕒 Prepare hourly forecast lists
            List<double> hourlytemps = [];
            List<String> hourlytimes = [];

            for (var hour in hourList) {
              hourlytemps.add((hour['temp_f'] as num).toDouble());
              hourlytimes.add(hour['time'].toString());
            }

            return MyHomePage(
              loc: location,
              tempF: tempf,
              cond: condition,
              feelslikeF: feelslikef,
              uvIndex: uv,
              windMPH: wind_mph,
              gustMPH: gust_mph,
              windDegree: winddegree,
              windDir: winddir,
              visibility: vis,
              humidity: humid,
              sundown: sunset,
              predictPrecipIn: predictprecipin,
              moonPhase: moonphase,
              moonSet: moonset,
              moonIllumination: moonillumination,
              hourlyTimes: hourlytimes,
              hourlyTemps: hourlytemps,
            );
          } else {
            return const Center(child: Text("No data available"));
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
          child: WeatherHomePage(hourlyTimes: hourlyTimes, hourlyTemps: hourlyTemps),
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

