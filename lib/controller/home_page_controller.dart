import 'dart:async';

import 'package:cardia_watch/service/utils_service.dart';
import 'package:cardia_watch/view/connect/connect_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class HomePageController extends GetxController {
  final UtilService utilService = UtilService();
  final date = ''.obs;
  final heartRate = 0.obs;
  final heartRateSpots = <FlSpot>[].obs;
  final isConnected = false.obs;
  late StreamSubscription scanStream;

  @override
  void onInit() async {
    heartRateSpots.value = utilService.chartData(List.filled(24, 0.0));
    getHeartRate();
    await connectDevice();
    super.onInit();
  }

  Future<void> connectDevice() async {
    if (Hive.isBoxOpen('deviceData')) {
      var box = await Hive.openBox('deviceData');
      if (box.isNotEmpty) {
        Get.to(() => const ConnectPage());
      }
    }
  }

  Future<void> checkDevice() async {
    int valueOld = 1;
    if (Hive.isBoxOpen('deviceData')) {
      var box = await Hive.openBox('deviceData');
      var isOn = await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
      if (box.isNotEmpty && isOn) {
        await FlutterBluePlus.startScan(
            timeout: const Duration(seconds: 30),
            androidUsesFineLocation: false,
            withServices: [Guid('0000180d-0000-1000-8000-00805f9b34fb')]);

        FlutterBluePlus.scanResults.listen((sr) async {
          for (ScanResult r in sr) {
            if (r.device.remoteId.toString() == box.get('deviceId')) {
              r.device
                  .connect(timeout: const Duration(seconds: 10))
                  .then((v) async {
                r.device.discoverServices().then((services) {
                  var service = services.firstWhere((s) =>
                      s.uuid == Guid('0000180d-0000-1000-8000-00805f9b34fb'));

                  var characteristic = service.characteristics.firstWhere((c) =>
                      c.uuid == Guid('00002a37-0000-1000-8000-00805f9b34fb'));

                  characteristic.setNotifyValue(true).then((_) {
                    characteristic.lastValueStream.listen((data) async {
                      if (data.isNotEmpty) {
                        if (data[1] == 0) {
                          if (valueOld != 1) {
                            await box.add({
                              'date': DateTime.now().toString(),
                              'heartRate': valueOld,
                            });
                            valueOld = 1;
                          }
                        } else {
                          valueOld = data[1];
                        }
                      }
                    });
                  });

                  if (service.uuid == Guid('6e400001-b5a3-f393-e0a9-e50e24dcca9e')) {
                    var characteristic = service.characteristics.firstWhere(
                            (c) => c.uuid == Guid('6e400002-b5a3-f393-e0a9-e50e24dcca9e'));
                    characteristic.write([1,12,1,10]);
                  }
                });
              });
            }
          }
        });
        update();
      }
    }
  }

  Future<void> getHeartRate() async {
    if (Hive.isBoxOpen('heartRateData')) {
      var box = await Hive.openBox('heartRateData');
      if (Hive.isBoxOpen('heartRateHistory')) {
        var boxHistory = await Hive.openBox('heartRateHistory');
        populateData(box, boxHistory);
        update();

        box.watch().listen((e) {
          populateData(box, boxHistory);
          update();
        });
      }
    }
  }

  void populateData(Box box, Box boxHistory) {
    if (box.isNotEmpty) {
      final value = box.getAt(box.length - 1);
      date.value = value['date'];
      heartRate.value = value['heartRate'];
    }

    if (boxHistory.isNotEmpty) {
      DateTime dateToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      if(boxHistory.get(dateToday.toString()) != null) {
        final value = boxHistory.get(dateToday.toString());
        heartRateSpots.value = utilService.chartData(value);
      }
    }
  }
}

