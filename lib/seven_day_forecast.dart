import 'package:flutter/material.dart';
import 'day_forecast.dart';
import 'package:intl/intl.dart'; // For getting the current day name



class WeatherHomePage extends StatelessWidget {
  final List<String> hourlyTimes; // Added for hourly forecast
  final List<double> hourlyTemps; // Added for hourly forecast

  WeatherHomePage({required this.hourlyTimes, required this.hourlyTemps}); 

  @override
  Widget build(BuildContext context) {
    // Define all 7 days of the week
    List<String> daysOfWeek = [
      "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
    ];

    // Get today's weekday name
    String today = DateFormat('EEEE').format(DateTime.now()); 

    // Find the index of today in the list
    int todayIndex = daysOfWeek.indexOf(today);

    // Create a reordered list starting from today
    List<String> reorderedDays = [
      ...daysOfWeek.sublist(todayIndex), // Days from today onward
      ...daysOfWeek.sublist(0, todayIndex) // Wrap around the beginning
    ];

    return Scaffold(
      appBar: AppBar(title: Text("7-Day Forecast")),
      body: ListView.builder(
        itemCount: reorderedDays.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              reorderedDays[index],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ForecastPage(hourlyTimes: hourlyTimes, hourlyTemps: hourlyTemps), // Pass the data to the ForecastPage
                ),
              );
            },
          );
        },
      ),
    );
  }
}
