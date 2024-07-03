import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../service/utils_service.dart';
import '../view/login_page.dart';

class SettingsPageController extends GetxController {
  final UtilService utilService = UtilService();
  final isConnect = false.obs;
  final name = 'Guest'.obs;
  final gender = '-'.obs;
  final dateOfBirth = '-'.obs;

  @override
  void onInit() {
    populateData();
    super.onInit();
  }

  @override
  void onReady() {
    checkConnect();
    super.onInit();
  }

  Future<void> checkConnect() async {
    final connected = await FlutterBluePlus.connectedSystemDevices;
    isConnect.value = connected.isNotEmpty;
  }

  Future<void> populateData () async {
    if (Hive.isBoxOpen('user')) {
      var box = await Hive.openBox('user');
      var value = box.getAt(0);
      name.value = value['name'];
      gender.value = value['gender'];
      dateOfBirth.value = value['date_of_birth'];
    }
  }
  
  Future<void> logout () async {
    if (Hive.isBoxOpen('token')) {
      var box = await Hive.openBox('token');
      box.clear();
    }
    if (Hive.isBoxOpen('user')) {
      var box = await Hive.openBox('user');
      box.clear();
    }
    if (Hive.isBoxOpen('deviceData')) {
      var box = await Hive.openBox('deviceData');
      box.clear();
    }
    if (Hive.isBoxOpen('heartRateData')) {
      var box = await Hive.openBox('heartRateData');
      await box.clear();
    }
    if (Hive.isBoxOpen('heartRateHistory')) {
      var box = await Hive.openBox('heartRateHistory');
      await box.clear();
    }
    Get.to(() => const LoginPage());
  }
}
