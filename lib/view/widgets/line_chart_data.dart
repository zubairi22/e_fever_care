import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

LineChartData lineData(List<FlSpot> heartRateSpots) {
  return LineChartData(
    minX: 0,
    maxX: 24,
    minY: 0,
    maxY: 150,
    baselineY: 0,
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
      text = const Text('00', style: style);
      break;
    case 12:
      text = const Text('12', style: style);
      break;
    case 24:
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
    case 1:
      text = '0';
      break;
    case 40:
      text = '40';
      break;
    case 60:
      text = '60';
      break;
    case 80:
      text = '80';
      break;
    case 100:
      text = '100';
      break;
    case 120:
      text = '120';
      break;
    case 150:
      text = '150';
      break;
    default:
      return Container();
  }

  return Text(text, style: style, textAlign: TextAlign.left);
}
