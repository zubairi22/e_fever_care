import 'package:cardia_watch/view/history_page.dart';
import 'package:cardia_watch/view/news_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UtilController extends GetxController {

  final iconList = <IconData>[
    Icons.bar_chart,
    Icons.newspaper,
  ];

  final pages = [
    const HistoryPage(),
    const NewsPage(),
  ];

  @override
  void onReady() {
    super.onInit();
  }

  dynamic navigateTo(int index) async {
    Get.to(() => pages[index]);
  }

}
