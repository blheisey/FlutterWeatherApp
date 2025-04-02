import 'package:flutter/material.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<String> hourlyTimes;
  final List<double> hourlyTemps;

  const HourlyForecastWidget({
    Key? key,
    required this.hourlyTimes,
    required this.hourlyTemps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current hour and filter data to start from the current time
    DateTime now = DateTime.now();
    int currentIndex = hourlyTimes.indexWhere((time) {
      DateTime parsedTime = DateTime.parse(time);
      return parsedTime.hour >= now.hour;
    });

    // If currentIndex is -1 (not found), start from 0
    currentIndex = (currentIndex == -1) ? 0 : currentIndex;

    List<String> filteredTimes = hourlyTimes.sublist(currentIndex);
    List<double> filteredTemps = hourlyTemps.sublist(currentIndex);

    return SizedBox(
      height: 120, // Adjust height as needed
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(filteredTimes.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(filteredTimes[index]), // Format time nicely
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "${filteredTemps[index]}°F",
                        style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // Helper function to format time as "HH:mm AM/PM"
  String _formatTime(String time) {
    DateTime parsedTime = DateTime.parse(time);
    return "${parsedTime.hour % 12 == 0 ? 12 : parsedTime.hour % 12}:${parsedTime.minute.toString().padLeft(2, '0')} ${parsedTime.hour >= 12 ? "PM" : "AM"}";
  }
}
