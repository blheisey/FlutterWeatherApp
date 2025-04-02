import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
    final String title;
    final dynamic value;
    const WeatherCard({
        Key? key,
        required this.title,
        required this.value,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                            title,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                            ),
                        ),
                        SizedBox(height: 8),
                        Text(
                            value,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}