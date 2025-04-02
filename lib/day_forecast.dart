import 'package:flutter/material.dart';

class ForecastPage extends StatelessWidget {
  final String day;

  ForecastPage({required this.day}); // Accept day as a parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$day Forecast")),
      body: Center(
        child: Text(
          "Weather forecast for $day",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
