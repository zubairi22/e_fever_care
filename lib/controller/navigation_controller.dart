import 'package:e_fever_care/view/history/history_page.dart';
import 'package:e_fever_care/view/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../service/utils_service.dart';
import '../view/home_page.dart';

class NavigationController extends GetxController {
  final UtilService utilService = UtilService();
  var selectedIndex = 0.obs;

  final iconList = <IconData>[
    Icons.home,
    Icons.bar_chart,
    Icons.settings
  ];

  final List<Widget> pages = [
    const HomePage(),
    const HistoryPage(),
    const SettingsPage()
  ];

  final List<String> pageList = [
    'home',
    'history',
    'setting',
  ];

  List<BluetoothDevice> connectedDevices = [];

  void changePage(int index) {
    selectedIndex.value = index;
  }
}
