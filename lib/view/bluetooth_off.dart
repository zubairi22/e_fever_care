import 'dart:io';

import 'package:cardia_watch/view/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'connect_page.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.adapterState}) : super(key: key);

  final BluetoothAdapterState? adapterState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.lightBlue,
            ),
            Text(
              'Bluetooth Adapter sedang ${adapterState != null ? adapterState.toString().split(".").last : 'Tidak tersedia'}.',
              style: Theme.of(context).primaryTextTheme.titleSmall?.copyWith(color: Colors.white),
            ),
            if (Platform.isAndroid)
              ElevatedButton(
                child: const Text('Aktifkan Bluetooth'),
                onPressed: () async {
                  try {
                    if (Platform.isAndroid) {
                      await FlutterBluePlus.turnOn().then((v) {
                        Get.snackbar(
                          "Success",
                          'Berhasil menyalakan Bluetooth',
                          colorText: Colors.white,
                          backgroundColor: Colors.green,
                          margin: const EdgeInsets.all(8),
                          icon: const Icon(Icons.verified_rounded),
                        );
                      });
                    }
                  } catch (e) {
                    Get.snackbar(
                      "Error",
                      e.toString(),
                      colorText: Colors.white,
                      backgroundColor: Colors.red,
                      margin: const EdgeInsets.all(8),
                      icon: const Icon(Icons.error),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}