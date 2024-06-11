import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../service/utils_service.dart';
import '../view/login_page.dart';

class SettingsPageController extends GetxController {
  final UtilService utilService = UtilService();
  final isConnect = false.obs;
  final name = 'Guest'.obs;
  final age = '-'.obs;
  final height = '-'.obs;
  final weight = '-'.obs;
  final gender = '-'.obs;
  // final ageList = [].obs;
  // final heightList = [].obs;
  // final weightList = [].obs;
  // final genderList = [
  //   'Laki-Laki' , 'Perempuan'
  // ].obs;

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
    // if(ageList.isEmpty){
    //   for (int i = 1; i < 100; i++) {
    //     ageList.add(i);
    //   }
    //
    //   for (int i = 100; i < 300; i++) {
    //     heightList.add(i);
    //   }
    //
    //   for (int i = 0; i < 100; i++) {
    //     weightList.add(i);
    //   }
    // }

    if (Hive.isBoxOpen('user')) {
      var box = await Hive.openBox('user');
      var value = box.getAt(0);
      name.value = value['name'];
      age.value = value['age'];
      height.value = value['height'];
      weight.value = value['weight'];
      gender.value = value['sex'];
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
