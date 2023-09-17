import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../service/utils_service.dart';

class HistoryPageController extends GetxController {
  final UtilService utilService = UtilService();
  final dayHeartRateSpots = <FlSpot>[].obs;
  final maxToday = 0.obs;
  final minToday = 0.obs;
  final averageToday = 0.obs;
  final daysInMonth = <DateTime>[].obs;
  final daysLength = 0.obs;

  final iconList = <IconData>[
    Icons.bar_chart,
    Icons.newspaper,
    Icons.local_hospital_rounded,
    Icons.settings
  ];

  DateTime dateYesterday = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);

  DateTime dateFirst = DateTime(DateTime.now().year, DateTime.now().month, 1);

  @override
  void onInit() {
    getDaysInBetween(dateFirst, dateYesterday);
    super.onInit();
  }

  @override
  void onReady() {
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
        final List<double> value = box.get(historyDate.toString()) ?? [];
        if (value.isNotEmpty) {
          var nonZero = value.where((value) => value != 0).toList();

          maxToday.value = value
              .reduce((value, element) => value > element ? value : element)
              .toInt();
          minToday.value = nonZero
              .reduce((value, element) => value < element ? value : element)
              .toInt();
          double sum =
              nonZero.fold(0, (previous, current) => previous + current);
          averageToday.value = sum ~/ nonZero.length;
          dayHeartRateSpots.value = utilService.chartData(value);
        } else {
          maxToday.value = 0;
          minToday.value = 0;
          averageToday.value = 0;
          dayHeartRateSpots.value = utilService.chartData([]);
        }
      }
      update();
    }
  }
}
