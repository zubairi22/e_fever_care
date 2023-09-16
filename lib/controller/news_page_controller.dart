import 'dart:convert';

import 'package:cardia_watch/controller/utils_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NewsPageController extends GetxController {

  final iconList = <IconData>[
    Icons.bar_chart,
    Icons.newspaper,
  ];

  final listData = [].obs;

  UtilController utilController = UtilController();

  @override
  void onReady() {
    readJson();
    super.onInit();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/article.json');
    List<dynamic> jsonMap = json.decode(response);
    listData.value = jsonMap[0]['berita'];
  }

}
