import 'dart:async';

import 'package:e_fever_care/service/utils_service.dart';
import 'package:e_fever_care/view/connect/connect_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    await getTemperatureFromServer();
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

      temperatureSpots.value = utilService.chartData(todayDataList);
    }
  }

  Future<void> getTemperatureFromServer() async {
    final connect = GetConnect();
    if (Hive.isBoxOpen('token')) {
      var box = await Hive.openBox('token');
      await connect.get(
        '${utilService.url}/api/temperature/history',
        headers: {'Authorization': 'Bearer ${box.getAt(0)}'},
      ).then((response) async {
        if (response.statusCode == 200) {
          if (Hive.isBoxOpen('temperatureData')) {
            var temperatureBox = await Hive.openBox('temperatureData');
            List<dynamic> existingData = temperatureBox.get('TempList', defaultValue: []);

            List<dynamic> newData = response.body['temp'];
            for (var data in newData) {
              bool exists = existingData.any((existing) =>
                  DateTime.parse(existing['date']).isAtSameMomentAs(DateTime.parse(data['reading_time']))
              );

              if (!exists) {
                existingData.add({
                  'date': data['reading_time'],
                  'temperature': double.parse(data['temperature']),
                });
              }
            }
            await temperatureBox.put('TempList', existingData);
          }

          Get.snackbar(
            "Success",
            "Fetch Data Server Berhasil",
            margin: const EdgeInsets.all(8),
            icon: const Icon(
                Icons.verified_rounded, color: Colors.green),
          );

          getTemperature();
        } else {
          getTemperature();
        }
      });
    }
  }

}

