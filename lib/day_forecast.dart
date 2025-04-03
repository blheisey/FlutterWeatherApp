import 'package:flutter/material.dart';
import 'temperature_graph.dart'; // Import your TemperatureLineChart widget 

class ForecastPage extends StatelessWidget {
  final List<String> hourlyTimes; // Added for hourly forecast
  final List<double> hourlyTemps; // Added for hourly forecast
  

  ForecastPage({required this.hourlyTimes, required this.hourlyTemps}); // Accept day as a parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forecast")),
      body: Center(
        child: 
        TemperatureLineChart(
        hourlyTemps: hourlyTemps, 
        hourlyTimes: hourlyTimes,
        )
      ),
    );
  }
}
