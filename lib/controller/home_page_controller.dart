import 'dart:async';

import 'package:e_fever_care/service/utils_service.dart';
import 'package:e_fever_care/view/connect/connect_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class HomePageController extends GetxController {
  final UtilService utilService = UtilService();

  final date = ''.obs;
  final temperature = 0.0.obs;
  final temperatureSpots = <FlSpot>[].obs;

  @override
  void onInit() async {
    temperatureSpots.value = utilService.chartData([]);
    await connectDevice();
    getTemperature();
    super.onInit();
  }

  Future<void> connectDevice() async {
    if (Hive.isBoxOpen('deviceData')) {
      var box = await Hive.openBox('deviceData');
      if (box.isNotEmpty) {
        Get.to(() => const ConnectPage());
      }
    }
  }

  Future<void> getTemperature() async {
    if (Hive.isBoxOpen('temperatureData')) {
      var box = await Hive.openBox('temperatureData');
      populateData(box);
      update();

      box.watch().listen((e) {
        populateData(box);
        update();
      });
    }
  }

  void populateData(Box box) {
    if (box.isNotEmpty) {
      List<dynamic> dataList = box.get('TempList', defaultValue: []);
      final value = dataList.last;
      date.value = value['date'];
      temperature.value = value['temperature'];

      DateTime today = utilService.dateToday;

      List<dynamic> todayDataList = dataList.where((entry) {
        DateTime date = DateTime.parse(entry['date']);
        return date.year == today.year && date.month == today.month && date.day == today.day;
      }).toList();

      print(todayDataList);
      temperatureSpots.value = utilService.chartData(todayDataList);
    }
  }
}

