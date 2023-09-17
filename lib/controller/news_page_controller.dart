import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../service/utils_service.dart';

class NewsPageController extends GetxController {
  final UtilService utilService = UtilService();
  final listData = [].obs;

  @override
  void onReady() {
    readJson();
    super.onInit();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/article.json');
    final jsonMap = json.decode(response);
    listData.value = jsonMap['data'];
  }
}
