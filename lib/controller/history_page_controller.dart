import 'package:cardia_watch/view/connect_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../view/history_page.dart';
import '../view/news_page.dart';

class HistoryPageController extends GetxController {
  final todayHeartRate = <Map<dynamic, dynamic>>[].obs;
  final dayHeartRateSpots = <FlSpot>[].obs;
  final maxToday = 0.obs;
  final minToday = 0.obs;
  final averageToday = 0.obs;
  final daysInMonth = <DateTime>[].obs;
  final daysLength = 0.obs;

  final iconList = <IconData>[
    Icons.bar_chart,
    Icons.newspaper,
  ];

  DateTime dateYesterday = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime dateFirst = DateTime(
      DateTime.now().year, DateTime.now().month, 1);

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    getDaysInBetween(dateFirst, dateYesterday);
    getHeartRateHistory(dateYesterday);
    super.onReady();
  }

  void getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    daysInMonth.value = days;
    daysLength.value = days.length - 1;
  }

  Future<void> getHeartRateHistory(DateTime? historyDate) async {
    if (Hive.isBoxOpen('heartRateHistory')) {
      var box = await Hive.openBox('heartRateHistory');
      if (box.isNotEmpty) {
        final List<double> value = box.get(historyDate.toString());
        print(value);
        var nonZero = value.where((value) => value != 0).toList();

        maxToday.value = value.reduce((value, element) => value > element ? value : element).toInt();
        minToday.value = nonZero.reduce((value, element) => value < element ? value : element).toInt();
        double sum = nonZero.fold(0, (previous, current) => previous + current);
        averageToday.value = sum ~/ nonZero.length;
        dayHeartRateSpots.value = chartData(value);
      }
      update();


    }
      if (Hive.isBoxOpen('heartRateData')) {
        var boxData = await Hive.openBox('heartRateData');

        boxData.watch().listen((e) {
          if (boxData.isNotEmpty) {
            filterDataByDate(boxData);
          }
          update();
        });
    }
  }

  List<FlSpot> chartData(List<double> data) {
    return data.asMap().entries.map((entry) {
      final x = entry.key.toDouble();
      final y = entry.value.toDouble();
      return FlSpot(x, y);
    }).toList().obs;
  }
  
  void filterDataByDate(Box box) {
    List<double> hourHeartRateAverage = List.filled(24, 0.0);
    Map<int, double> hourHeartRateSums = {};
    Map<int, int> hourHeartRateCounts = {};

    for (var key in box.keys) {
      var item = box.get(key);
      if (item != null && item is Map && item.containsKey('date')) {
        DateTime itemDate = DateTime.parse(item['date']);
        DateTime dateItem = DateTime(itemDate.year, itemDate.month, itemDate.day);

        if (dateYesterday == dateItem) {
          int hour = itemDate.hour;

          int count = hourHeartRateCounts[hour] ?? 0;
          double sum = hourHeartRateSums[hour] ?? 0.0;

          double newAverage =
              (sum + (item['heartRate'] ?? 0)) / (count + 1);

          hourHeartRateAverage[hour] = newAverage;
          hourHeartRateCounts[hour] = count + 1;
          hourHeartRateSums[hour] = sum + (item['heartRate'] ?? 0);
        }
      }
      saveDataToHive({
        'date' : dateYesterday.toString(),
        'heartRateHistory' : hourHeartRateAverage,
      });
    }
  }

  Future<void> saveDataToHive(Map<String, dynamic> data) async {
    if (Hive.isBoxOpen('heartRateHistory')) {
      var box = await Hive.openBox('heartRateHistory');
      await box.put(data['date'], data['heartRateHistory']);

      dayHeartRateSpots.value = chartData(box.get(data['date']));
    }
  }
}
