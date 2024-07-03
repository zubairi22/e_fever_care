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
  int customDataCount = 1;

  void setupHeartRateNotifications(List<BluetoothService> services) async {
    bool isScanning = false;

    var service = services.firstWhere((s) => s.uuid == Guid('0000180d-0000-1000-8000-00805f9b34fb'));
    var characteristic = service.characteristics.firstWhere((c) => c.uuid == Guid('00002a37-0000-1000-8000-00805f9b34fb'));

    characteristic.setNotifyValue(true).then((_) {
      heartRateStream = characteristic.lastValueStream.listen((data) async {
        if (data.isNotEmpty) {
          int currentValue = data[1];
          if (currentValue == 0) {
            if (isScanning) {
              print('PRINT IS SCANNING $data');
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
      customStream = writeCharacteristic.onValueReceived.listen((data) async {
        if (data.isNotEmpty) {
          if(data == [5, 9, 16, 0, 61, 0, 7, 0, 0, 0, 196, 4, 0, 0, 234, 17])  {
            await writeToSync();
          }
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
          print('CUSTOM DATA $data');
          customProcessData(data);
        }
      });
    });
  }

  void customProcessData(List<int> data) {
    if (data[0] == 5 && data[1] == 24 && data.length >= 18) {
      perSpo2(prepareSpo2Data(data));
      customDataCount++;
    }
  }

  Future<void> perSpo2(List<List<int>> data) async {
    for (List<int> subArr in data) {
      if (subArr.length >= 15) {
        int time = utilService.bytesToDec([subArr[3], subArr[2], subArr[1], subArr[0]]);
        int tempInteger = subArr[13];
        int tempDouble = subArr[14] & -1;
        String date = DateTime.fromMillisecondsSinceEpoch(time, isUtc: true).toString();
        if(tempInteger != 0) {
          await saveTemperatureDataToHive(double.parse('$tempInteger.$tempDouble'), date);
          // print("Diambil dengan waktu $date}");
          // print("Temperature Adalah $tempInteger.$tempDouble");
        }
      }
    }
  }

  List<List<int>> prepareSpo2Data(List<int> data) {
    List<int> bArr = data.sublist(4 * customDataCount);
    List<List<int>> list = [];
    for (int j = 0; j < bArr.length; j += 20) {
      list.add(bArr.sublist(j, j + 20 > bArr.length ? bArr.length : j + 20));
    }
    print('LIST SPO2 $list');
    return list;
  }

  Future<void> writeToSync() async {
    try {
      await writeCharacteristic.write(utilService.makeSend([5,9,1]));
    } catch (e) {
      print('error $e');
    }
  }

  Future<void> saveTemperatureDataToHive(double temperature, String date) async {
    if (Hive.isBoxOpen('temperatureData')) {
      var box = await Hive.openBox('temperatureData');
      List<dynamic> existingData = box.get('TempList', defaultValue: []);
      if(DateTime.parse(date).year == DateTime.now().year) {
        var readingTime = date.substring(0, 23);
        if(existingData.isNotEmpty) {
          var lastData = existingData.last;

          if(DateTime.parse(date).isAfter(DateTime.parse(lastData['date']))) {
            existingData.add({
              'date': readingTime,
              'temperature': temperature,
            });
            await box.put('TempList', existingData);
            await postTemperature(temperature, readingTime);
          }
        } else {
          existingData.add({
            'date': readingTime,
            'temperature': temperature,
          });
          await box.put('TempList', existingData);
          await postTemperature(temperature, readingTime);
        }
      }
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

  Future<void> postTemperature(double data, String date) async {
    final connect = GetConnect();
    if (Hive.isBoxOpen('token')) {
      var box = await Hive.openBox('token');
      await connect.post(
        '${utilService.url}/api/temperature',
        {'temperature': data, 'reading_time' : date},
        headers: {'Authorization': 'Bearer ${box.getAt(0)}'},
      );
    }
  }
}
