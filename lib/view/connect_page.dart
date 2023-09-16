import 'package:cardia_watch/controller/connect_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import 'bluetooth_off.dart';
import 'find_device_screen.dart';

final Map<DeviceIdentifier, ValueNotifier<bool>> isConnectingOrDisconnecting = {};

class ConnectPage extends GetView<ConnectPageController> {
  const ConnectPage ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothAdapterState>(
        stream: FlutterBluePlus.adapterState,
        initialData: BluetoothAdapterState.unknown,
        builder: (c, snapshot) {
          final adapterState = snapshot.data;
          if (adapterState == BluetoothAdapterState.on) {
            return const FindDevicesScreen();
          } else {
            FlutterBluePlus.stopScan();
            return BluetoothOffScreen(adapterState: adapterState);
          }
        });
  }
}