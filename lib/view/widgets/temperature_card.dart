import 'package:flutter/material.dart';

class TemperatureCard extends StatelessWidget {
  final String date;
  final double temperature;

  const TemperatureCard({
    super.key,
    required this.date,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    MaterialColor color = Colors.green;
    String text = 'NORMAL';
    if (temperature > 37.5) {
      text = 'TINGGI';
      color = Colors.red;
    } else if (temperature < 36) {
      text = 'RENDAH';
      color = Colors.blue;
    }
    return Card(
      color: Colors.teal.shade50,
      margin: const EdgeInsets.all(20.0),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 30,
          right: 30,
          top: 10,
          bottom: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date != '' ? date.substring(0, 10) : '--/--',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  date != '' ? date.substring(10, 16) : '--/--',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$temperatureº',
                  style: const TextStyle(fontSize: 80),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Column(
                  children: [
                    Text('C', style: TextStyle(fontSize: 30)),
                  ],
                ),
              ],
            ),
            Text(text,
                style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
