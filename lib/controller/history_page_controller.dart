import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../service/utils_service.dart';

class HistoryPageController extends GetxController {
  final UtilService utilService = UtilService();
  final dayHeartRateSpots = <FlSpot>[].obs;
  final maxToday = '0'.obs;
  final minToday = '0'.obs;
  final averageToday = '0'.obs;
  final token = ''.obs;
  final listKeys = [].obs;
  final listLength = 0.obs;
  var listData = {};

  final iconList = <IconData>[
    Icons.bar_chart,
    Icons.newspaper,
    Icons.local_hospital_rounded,
    Icons.settings
  ];

  String dateYesterday = DateFormat('yyyy-MM-dd').format(DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1));

  @override
  Future<void> onInit() async {
    dayHeartRateSpots.value = utilService.chartData(List.filled(24, 0.0));
    //await getData();
    getHeartRateHistory(dateYesterday);
    super.onInit();
  }

  Future<void> getData () async {
    if (Hive.isBoxOpen('token')) {
      var box = await Hive.openBox('token');
      token.value = box.getAt(0);
    }
    final connect = GetConnect();
    await connect.get(
        '${utilService.url}/api/vital-history',
        headers: {
          'Authorization': 'Bearer $token'
        }
    ).then((response) async {
      if (response.statusCode == 200) {
        listData.addAll(response.body['vitalSign']);
        listKeys.value = listData.keys.toList().reversed.toList();
        listLength.value = listData.keys.toList().length - 1;
      }
    });
  }

  Future<void> getHeartRateHistory(String historyDate) async {
    if(listData.containsKey(historyDate)) {
      var heartRate = List.filled(24, 0.0);
      for (var i = 0; i < heartRate.length; i++) {
        if(listData[historyDate]['data'].containsKey(i.toString())) {
          heartRate[i] = double.parse(listData[historyDate]['data'][i.toString()]);
        }
      }
      maxToday.value = listData[historyDate]['max'];
      minToday.value = listData[historyDate]['min'];
      averageToday.value = listData[historyDate]['average'];
      dayHeartRateSpots.value = utilService.chartData(heartRate);
    } else {
      dayHeartRateSpots.value = utilService.chartData([]);
    }
  }
}
