import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class UtilService {

  final iconList = <IconData>[
    Icons.bar_chart,
    Icons.newspaper,
    Icons.local_hospital_rounded,
    Icons.settings
  ];

  final pageList = [
    'history',
    'news',
    'hospital',
    'setting',
  ];

  final url = 'http://192.168.22.186:8000';

  List<FlSpot> chartData(List<double> data) {
    return data
        .asMap()
        .entries
        .map((entry) {
          final x = entry.key.toDouble();
          final y = entry.value.toDouble();
          return FlSpot(x, y);
        })
        .toList();
  }
}
