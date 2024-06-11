import 'package:e_fever_care/view/history/history_page.dart';
import 'package:e_fever_care/view/news/news_page.dart';
import 'package:e_fever_care/view/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../service/utils_service.dart';
import '../view/home_page.dart';

class NavigationController extends GetxController {
  final UtilService utilService = UtilService();
  var selectedIndex = Get.arguments ?? 0.obs;

  final iconList = <IconData>[
    Icons.home,
    Icons.bar_chart,
    Icons.newspaper,
    Icons.settings
  ];

  final List<Widget> pages = [
    const HomePage(),
    const HistoryPage(),
    const NewsPage(),
    const SettingsPage()
  ];

  final List<String> pageList = [
    'home',
    'history',
    'news',
    'setting',
  ];

  List<BluetoothDevice> connectedDevices = [];

  void changePage(int index) {
    selectedIndex.value = index;
  }

  Future<void> scanData() async {
    connectedDevices = await FlutterBluePlus.connectedSystemDevices;

    String? remoteID = await getDeviceFromHive();

    if (remoteID == null) {
      print('No device ID found in Hive.');
      return;
    }

    try {
      BluetoothDevice device = connectedDevices.firstWhere((e) => e.remoteId.toString() == remoteID);
      print('Connected device: $device');

      if (device.connectionState != BluetoothConnectionState.connected) {
        await device.connect();
        print('Device tidak terkonek');
      }

      List<BluetoothService> services = await device.discoverServices();

      var service = services.firstWhere((s) => s.uuid == Guid('be940000-7333-be46-b7ae-689e71722bd5'));
      var characteristic = service.characteristics.firstWhere((c) => c.uuid == Guid('be940001-7333-be46-b7ae-689e71722bd5'));

      //7 Waktu
      await characteristic.write(utilService.syncTime(DateTime.now()));

      // Value: 01200800011e0906
      //await characteristic.write(utilService.makeSend([1,32,1,30]));

      // HR Monitor Setting
      await characteristic.write(utilService.makeSend([1,12,1,30]));

      // //17 Sport
      // await characteristic.write(utilService.makeSend([5,2,1]));
      // //18 Sleep
      // await characteristic.write(utilService.makeSend([5,4,1]));
      // //19 HR
      await characteristic.write(utilService.makeSend([5,6,1]));
      // //20 BP
      //await characteristic.write(utilService.makeSend([5,8,1]));
      // //21 Respiratory
      //await characteristic.write(utilService.makeSend([5,9,1]));
      // //22 Sebelum Proses Panjang
      // await characteristic.write(formatHexString('05090700019d54'));


      // Teno
      //Temp
      //await characteristic.write([0x02, 0x0E, 0x08, 0x00, 0x22, 0x07, 0x58, 0xDF]);
      //Blood
      //await characteristic.write([0x05, 0x08, 0x07, 0x00, 0x01, 0x29, 0x22]);
      //Spo2
      //await characteristic.write([0x05, 0x09, 0x07, 0x00, 0x01, 0x9d, 0x54]);

    } catch (e) {
      print('Device with remote ID $remoteID not found.');
    }
  }

  Future<String?> getDeviceFromHive() async {
    var box = await Hive.openBox('deviceData');
    return box.get('deviceId');
  }

  List<int> formatHexString(String hexString) {
    List<int> byteList = [];
    for (int i = 0; i < hexString.length; i += 2) {
      String byteString = hexString.substring(i, i + 2);
      int byteValue = int.parse(byteString, radix: 16);
      byteList.add(byteValue);
    }
    return byteList;
  }
}
