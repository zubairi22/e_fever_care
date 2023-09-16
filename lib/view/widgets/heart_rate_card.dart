import 'package:flutter/material.dart';

class HeartRateCard extends StatelessWidget {
  final String date;
  final int heartRate;

  const HeartRateCard({super.key,
    required this.date,
    required this.heartRate,
  });

  @override
  Widget build(BuildContext context) {
    MaterialColor color = Colors.green ;
    String text = 'NORMAL';
    if( heartRate > 100){
      text = 'CEPAT';
      color = Colors.red ;
    } else if (heartRate < 60) {
      text = 'LAMBAT';
      color = Colors.blue ;
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
                  '$heartRate',
                  style: const TextStyle(fontSize: 80),
                ),
                const SizedBox(
                  width: 5,
                ),
               Column(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: color,
                      size: 24.0,
                    ),
                    const Text('bpm', style: TextStyle(fontSize: 15)),
                  ],
                ),
              ],
            ),
            Text(text,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: color)),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              width: 300,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.green,
                    Colors.red,
                  ],
                  stops: [0.1, 0.4, 0.9],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double containerWidth = 300 * (heartRate / 120); // Adjust as needed
                  return Stack(
                    children: [
                      Positioned(
                        left: containerWidth,
                        top: 1,
                        bottom: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          width: 3,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('40', style: TextStyle(fontSize: 15)),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.blue,
                      size: 10,
                    ),
                    SizedBox(width: 3),
                    Text('Lambat', style: TextStyle(fontSize: 15)),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 10,
                    ),
                    SizedBox(width: 3),
                    Text('Normal', style: TextStyle(fontSize: 15)),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.red,
                      size: 10,
                    ),
                    SizedBox(width: 3),
                    Text('Cepat', style: TextStyle(fontSize: 15)),
                  ],
                ),
                Text('120', style: TextStyle(fontSize: 15)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
