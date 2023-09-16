import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SettingsPageController extends GetxController {

  final isConnect = false.obs;

  @override
  void onReady() {
    checkConnect();
    super.onInit();
  }

  Future<void> checkConnect() async {
    final connected = await FlutterBluePlus.connectedSystemDevices;
    isConnect.value = connected.isNotEmpty;
  }

}