import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../service/utils_service.dart';

class ConnectPageController extends GetxController {
  final UtilService utilService = UtilService();
  late StreamSubscription heartRateStream;
  late StreamSubscription customStream;
  late StreamSubscription customSecondStream;

  late BluetoothCharacteristic writeCharacteristic;

  DateTime dateToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  var perHeartRateCount = 0;

  void setupHeartRateNotifications(List<BluetoothService> services) async {
    bool isScanning = false;

    var service = services.firstWhere((s) => s.uuid == Guid('0000180d-0000-1000-8000-00805f9b34fb'));
    var characteristic = service.characteristics.firstWhere((c) => c.uuid == Guid('00002a37-0000-1000-8000-00805f9b34fb'));

    characteristic.setNotifyValue(true).then((_) {
      heartRateStream = characteristic.onValueReceived.listen((data) async {
        if (data.isNotEmpty) {
          int currentValue = data[1];

          if (currentValue == 0) {
            if (isScanning) {
              await writeToSync();
              isScanning = false;
            }
          } else {
            isScanning = true;
          }
        }
      });
    });
  }


  void setupCustomNotifications(List<BluetoothService> services) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    var service = services.firstWhere((s) => s.uuid == Guid('be940000-7333-be46-b7ae-689e71722bd5'));
    writeCharacteristic = service.characteristics.firstWhere((c) => c.uuid == Guid('be940001-7333-be46-b7ae-689e71722bd5'));

    writeCharacteristic.setNotifyValue(true).then((_) {
      customStream = writeCharacteristic.lastValueStream.listen((data) {
        if (data.isNotEmpty) {
          if(data == [5, 6, 7, 0, 1, 115, 128]) {
            perHeartRateCount = 0;
          }
          print('Received data: $data');
        }
      });
    });

    await Future.delayed(const Duration(milliseconds: 500));

    await writeCharacteristic.write(utilService.syncTime(DateTime.now()));
    await writeCharacteristic.write(utilService.makeSend([1,12,1,30]));

    await Future.delayed(const Duration(milliseconds: 500));

    var secondCharacteristic = service.characteristics.firstWhere((c) => c.uuid == Guid('be940003-7333-be46-b7ae-689e71722bd5'));

    secondCharacteristic.setNotifyValue(true).then((_) {
      customSecondStream = secondCharacteristic.onValueReceived.listen((data) {
        if (data.isNotEmpty) {
          print('Received Second data: $data');
          customProcessData(data);
          perHeartRateCount++;
        }
      });
    });
  }

  void customProcessData(List<int> data) {
    if (data[0] == 5 && data[1] == 21 && data.length > 4) {
      perHeart(data);
    } else if (data[0] == 5 && data[1] == 24 && data.length >= 18) {
      perSpo2(prepareSpo2Data(data));
    }
  }

  Future<void> perHeart(List<int> data) async {
    List<int> bArr = data.sublist(4);
    int length = bArr.length;

    for (int i = 0; i < length; i += 6) {
      if (i + 6 <= length) {
        List<int> subArr = bArr.sublist(i, i + 6);
        int time = utilService.bytesToDec([subArr[3], subArr[2], subArr[1], subArr[0]]);
        int heartRate = subArr[5];
        String date = DateTime.fromMillisecondsSinceEpoch(time, isUtc: true).toString();

        await saveHeartRateDataToHive(heartRate, date);
        print("Diambil dengan waktu $date");
        print("Heart Rate Adalah $heartRate");
      }
    }
  }

  Future<void> perSpo2(List<List<int>> data) async {
    for (List<int> subArr in data) {
      if (subArr.length >= 12 && subArr[1] != 0) {
        int time = utilService.bytesToDec([subArr[11], subArr[10], subArr[9], subArr[8]]);
        int tempInteger = subArr[1];
        int tempDouble = subArr[2] & -1;
        String date = DateTime.fromMillisecondsSinceEpoch(time, isUtc: true).toString();

        await saveHeartRateDataToHive((tempInteger + tempDouble), date);
        print("Diambil dengan waktu $date}");
        print("Temperature Adalah $tempInteger.$tempDouble");
      }
    }
  }

  List<List<int>> prepareSpo2Data(List<int> data) {
    List<int> bArr = data.sublist(4);
    List<List<int>> list = [];
    for (int j = 0; j < bArr.length; j += 20) {
      list.add(bArr.sublist(j, j + 20 > bArr.length ? bArr.length : j + 20));
    }
    return list;
  }

  Future<void> writeToSync() async {
    try {
      await writeCharacteristic.write(utilService.makeSend([5,6,1]));
      await writeCharacteristic.write(utilService.makeSend([5,9,1]));
    } catch (e) {
      print('error $e');
    }
  }

  Future<void> saveHeartRateDataToHive(int heartRate, String date) async {
    if (Hive.isBoxOpen('heartRateData')) {
      var box = await Hive.openBox('heartRateData');
      List<dynamic> existingData = box.get('HRList', defaultValue: []);
      existingData.add({
        'date': date,
        'heartRate': heartRate,
      });
      await box.put('HRList', existingData);
    }
  }

  Future<void> saveTemperatureDataToHive(double temperature, String date) async {
    if (Hive.isBoxOpen('temperatureData')) {
      var box = await Hive.openBox('temperatureData');
      List<dynamic> existingData = box.get('TempList', defaultValue: []);
      existingData.add({
        'date': date,
        'temperature': temperature,
      });
      await box.put('TempList', existingData);
    }
  }

  Future<void> saveDeviceToHive(String data) async {
    if (Hive.isBoxOpen('deviceData')) {
      var box = await Hive.openBox('deviceData');
      await box.put('deviceId', data);
    }
  }

  Future<String?> getDeviceFromHive() async {
    var box = await Hive.openBox('deviceData');
    return box.get('deviceId');
  }

  Future<void> postHeartRate(int data) async {
    final connect = GetConnect();
    if (Hive.isBoxOpen('token')) {
      var box = await Hive.openBox('token');
      await connect.post(
        '${utilService.url}/api/vital',
        {'heart_rate': data},
        headers: {'Authorization': 'Bearer ${box.getAt(0)}'},
      );
    }
  }

  Future<void> saveHeartRateHistoryToHive(int heartRate) async {
    if (Hive.isBoxOpen('heartRateHistory')) {
      var box = await Hive.openBox('heartRateHistory');
      List<double> hourHeartRateAverage = List.filled(24, 0.0);
      int hour = DateTime.now().hour;
      if (box.isNotEmpty) {
        if (box.get(dateToday.toString()) != null) {
          hourHeartRateAverage = box.get(dateToday.toString());
        }
        if (hourHeartRateAverage[hour] == 0.0) {
          hourHeartRateAverage[hour] = heartRate.toDouble();
        } else {
          hourHeartRateAverage[hour] = (heartRate.toDouble() + hourHeartRateAverage[hour]) / 2;
        }
      } else {
        hourHeartRateAverage[hour] = heartRate.toDouble();
      }

      await box.put(dateToday.toString(), hourHeartRateAverage);
    }
  }
}
