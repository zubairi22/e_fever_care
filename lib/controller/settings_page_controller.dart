import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../service/utils_service.dart';

class SettingsPageController extends GetxController {
  final UtilService utilService = UtilService();
  final TextEditingController nameController = TextEditingController();
  final isConnect = false.obs;

  final age = 18.obs;
  final height = 170.obs;
  final weight = 60.obs;
  final gender = 'Laki-Laki'.obs;
  final ageList = [].obs;
  final heightList = [].obs;
  final weightList = [].obs;
  final genderList = [
    'Laki-Laki' , 'Perempuan'
  ].obs;

  @override
  void onInit() {
    populateData();
    super.onInit();
  }

  @override
  void onReady() {
    checkConnect();
    super.onReady();
  }

  void populateData (){
    nameController.text = "Guest";

    if(ageList.isEmpty){
      for (int i = 1; i < 100; i++) {
        ageList.add(i);
      }

      for (int i = 100; i < 300; i++) {
        heightList.add(i);
      }

      for (int i = 0; i < 100; i++) {
        weightList.add(i);
      }
    }
}

  Future<void> checkConnect() async {
    final connected = await FlutterBluePlus.connectedSystemDevices;
    isConnect.value = connected.isNotEmpty;
  }
}
