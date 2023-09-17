import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ConnectPageController extends GetxController {
  late StreamSubscription serviceStream;
  DateTime dateToday =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  void setupHeartRateNotifications(List<BluetoothService> services) {
    int valueOld = 1;
    for (var service in services) {
      if (service.uuid == Guid('0000180d-0000-1000-8000-00805f9b34fb')) {
        var characteristic = service.characteristics.firstWhere(
            (c) => c.uuid == Guid('00002a37-0000-1000-8000-00805f9b34fb'));

        characteristic.setNotifyValue(true).then((_) {
          serviceStream = characteristic.lastValueStream.listen((data) {
            if (data.isNotEmpty) {
              if (data[1] == 0) {
                if (valueOld != 1) {
                  saveDataToHive({
                    'date': DateTime.now().toString(),
                    'heartRate': valueOld,
                  });
                  saveHistoryToHive(valueOld);
                  valueOld = 1;
                }
              } else {
                valueOld = data[1];
              }
            }
          });
        });
      }
    }
  }

  Future<void> saveDataToHive(Map<String, dynamic> data) async {
    if (Hive.isBoxOpen('heartRateData')) {
      var box = await Hive.openBox('heartRateData');
      if (box.isNotEmpty) {
        final value = box.getAt(box.length - 1);
        final itemDate =
            DateTime.parse(value['date'].toString().substring(0, 10));
        if (itemDate.isBefore(dateToday)) {
          await box.clear();
        }
      }
      await box.add(data);
    }
  }

  Future<void> saveHistoryToHive(int data) async {
    if (Hive.isBoxOpen('heartRateHistory')) {
      var box = await Hive.openBox('heartRateHistory');
      List<double> hourHeartRateAverage = List.filled(24, 0.0);
      int hour = DateTime.now().hour;
      if (box.isNotEmpty) {
        List<double> value = box.get(dateToday.toString());
        if (value[hour] == 0.0) {
          hourHeartRateAverage[hour] = data.toDouble();
        } else {
          hourHeartRateAverage[hour] = (data.toDouble() + value[hour]) / 2;
        }
      } else {
        hourHeartRateAverage[hour] = data.toDouble();
      }

      await box.put(dateToday.toString(), hourHeartRateAverage);
    }
  }

  Future<void> saveDeviceToHive(String data) async {
    if (Hive.isBoxOpen('deviceData')) {
      var box = await Hive.openBox('deviceData');
      await box.put('deviceId', data);
    }
  }
}
