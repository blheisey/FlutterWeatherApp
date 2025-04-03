import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TemperatureLineChart extends StatelessWidget {
  final List<double> hourlyTemps;
  final List<String> hourlyTimes;

  TemperatureLineChart({required this.hourlyTemps, required this.hourlyTimes});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Adjust height as needed
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index % 3 == 0 && index < hourlyTimes.length) { 
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(hourlyTimes[index].split(" ")[1], // Extracts just the time part
                          style: TextStyle(fontSize: 12)),
                    );
                  }
                  return Container();
                },
                reservedSize: 22,
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          gridData: FlGridData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(hourlyTemps.length, 
                (index) => FlSpot(index.toDouble(), hourlyTemps[index])),
              isCurved: true,
              color: Colors.blue,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
