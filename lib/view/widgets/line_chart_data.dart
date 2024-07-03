import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

LineChartData lineData(List<FlSpot> heartRateSpots) {
  return LineChartData(
    minX: 0,
    maxX: 143,
    minY: 32.2,
    maxY: 45.0,
    baselineY: 32.2,
    baselineX: 0,
    titlesData: const FlTitlesData(
      show: true,
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: 1,
          getTitlesWidget: bottomTitleWidgets,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: leftTitleWidgets,
          reservedSize: 42,
        ),
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border.all(color: Colors.blueGrey),
    ),
    lineTouchData: const LineTouchData(
        touchTooltipData: LineTouchTooltipData(tooltipBgColor: Colors.white)),
    lineBarsData: [
      LineChartBarData(
        spots: heartRateSpots,
        isCurved: true,
        gradient: const LinearGradient(
          colors: [Colors.teal, Colors.blue],
        ),
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: const FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              Colors.teal.withOpacity(0.4),
              Colors.blue.withOpacity(0.4)
            ],
          ),
        ),
      ),
    ],
  );
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('0', style: style);
      break;
    case 143:
      text = const Text('24', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
  String text;
  switch (value.toInt()) {
    case 32:
      text = '32°c';
      break;
    case 45:
      text = '45°c';
      break;
    default:
      return Container();
  }

  return Text(text, style: style, textAlign: TextAlign.left);
}
