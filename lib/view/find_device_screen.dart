import 'dart:async';

import 'package:cardia_watch/view/settings_page.dart';
import 'package:cardia_watch/view/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../controller/connect_page_controller.dart';
import 'connect_page.dart';

class FindDevicesScreen extends GetView<ConnectPageController> {
  const FindDevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koneksikan Perangkat',style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        foregroundColor: Colors.teal,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          controller.update();
          if (FlutterBluePlus.isScanningNow == false) {
            FlutterBluePlus.startScan(
                timeout: const Duration(seconds: 15),
                androidUsesFineLocation: false);
          }
          return Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.fromFuture(FlutterBluePlus.connectedSystemDevices),
                initialData: const [],
                builder: (c, snapshot) => Column(
                  children: (snapshot.data ?? [])
                      .map((d) => ListTile(
                    title: Text(d.localName),
                    subtitle: Text(d.remoteId.toString()),
                    trailing: StreamBuilder<BluetoothConnectionState>(
                      stream: d.connectionState,
                      initialData: BluetoothConnectionState.disconnected,
                      builder: (c, snapshot) {
                        if (snapshot.data == BluetoothConnectionState.connected) {
                          return ElevatedButton(
                            child: const Text('DISCONNECT'),
                            onPressed: () async {
                              isConnectingOrDisconnecting[d.remoteId] ??= ValueNotifier(true);
                              isConnectingOrDisconnecting[d.remoteId]!.value = true;
                              try {
                                d.disconnect().then((v) {
                                  Get.snackbar(
                                    "Success",
                                    "Disconnect berhasil",
                                    colorText: Colors.white,
                                    backgroundColor: Colors.green,
                                    margin: const EdgeInsets.all(8),
                                    icon: const Icon(Icons.verified_rounded),
                                  );
                                  controller.serviceStream.cancel();
                                });
                              } catch (e) {
                                Get.snackbar(
                                  "Error",
                                  "Disconnect error $e",
                                  colorText: Colors.white,
                                  backgroundColor: Colors.red,
                                  margin: const EdgeInsets.all(8),
                                  icon: const Icon(Icons.error),
                                );
                              }
                              isConnectingOrDisconnecting[d.remoteId] ??= ValueNotifier(false);
                              isConnectingOrDisconnecting[d.remoteId]!.value = false;
                            },
                          );
                        }
                        if (snapshot.data == BluetoothConnectionState.disconnected) {
                          return ElevatedButton(
                            child: const Text('CONNECT'),
                            onPressed: () {
                              isConnectingOrDisconnecting[d.remoteId] ??= ValueNotifier(true);
                              isConnectingOrDisconnecting[d.remoteId]!.value = true;

                              d.connect(timeout: Duration(seconds: 35)).catchError((e) {
                                Get.snackbar(
                                  "Error",
                                  "Connect error $e",
                                  colorText: Colors.white,
                                  backgroundColor: Colors.red,
                                  margin: const EdgeInsets.all(8),
                                  icon: const Icon(Icons.error),
                                );
                              }).then((v) async {
                                try {
                                  d.discoverServices().then((services) {
                                    controller.setupHeartRateNotifications(services);
                                    controller.saveDeviceToHive(d.remoteId.toString());
                                    Get.snackbar(
                                      "Success",
                                      "Koneksi berhasil",
                                      colorText: Colors.white,
                                      backgroundColor: Colors.green,
                                      margin: const EdgeInsets.all(8),
                                      icon: const Icon(Icons.verified_rounded),
                                    );
                                  });
                                } catch (e) {
                                  Get.snackbar(
                                    "Error",
                                    "Koneksi error $e",
                                    colorText: Colors.white,
                                    backgroundColor: Colors.red,
                                    margin: const EdgeInsets.all(8),
                                    icon: const Icon(Icons.error),
                                  );
                                }
                              });
                              isConnectingOrDisconnecting[d.remoteId]!.value = false;
                              Get.to(() => const SettingsPage()) ;
                            },
                          );
                        }
                        return Text(snapshot.data.toString().toUpperCase().split('.')[1]);
                      },
                    ),
                  ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBluePlus.scanResults,
                initialData: const [],
                builder: (c, snapshot) => Column(
                  children: (snapshot.data ?? [])
                      .map(
                        (r) => ScanResultTile(
                      result: r,
                      onTap: () {
                        r.device.connect(timeout: Duration(seconds: 35)).catchError((e) {
                          Get.snackbar(
                            "Error",
                            "Connect error $e",
                            colorText: Colors.white,
                            backgroundColor: Colors.red,
                            margin: const EdgeInsets.all(8),
                            icon: const Icon(Icons.error),
                          );
                        }).then((v) async {
                          isConnectingOrDisconnecting[r.device.remoteId] ??= ValueNotifier(false);
                          isConnectingOrDisconnecting[r.device.remoteId]!.value = false;
                          try {
                            r.device.discoverServices().then((services) {
                              controller.setupHeartRateNotifications(services);
                              controller.saveDeviceToHive(r.device.remoteId.toString());
                              Get.snackbar(
                                "Success",
                                "Koneksi berhasil",
                                colorText: Colors.white,
                                backgroundColor: Colors.green,
                                margin: const EdgeInsets.all(8),
                                icon: const Icon(Icons.verified_rounded),
                              );
                            });
                          } catch (e) {
                            Get.snackbar(
                              "Error",
                              "Discover Services error $e",
                              colorText: Colors.white,
                              backgroundColor: Colors.red,
                              margin: const EdgeInsets.all(8),
                              icon: const Icon(Icons.error),
                            );
                          }
                        }).then((v) {
                          isConnectingOrDisconnecting[r.device.remoteId]!.value = false;
                          Get.to(() => const SettingsPage()) ;
                        });
                      },
                    ),
                  )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBluePlus.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data ?? false) {
            return FloatingActionButton(
              onPressed: () async {
                try {
                  await FlutterBluePlus.stopScan();
                } catch (e) {
                  Get.snackbar(
                    "Error",
                    "Stop Scan Error $e",
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                    margin: const EdgeInsets.all(8),
                    icon: const Icon(Icons.error),
                  );
                }
              },
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
                child: const Text("SCAN"),
                onPressed: () async {
                  try {
                    await FlutterBluePlus.startScan(
                        timeout: const Duration(seconds: 15),
                        androidUsesFineLocation: false,
                        withServices: [Guid('0000180d-0000-1000-8000-00805f9b34fb')]);
                  } catch (e) {
                    Get.snackbar(
                      "Error",
                      "Start Scan Error $e",
                      colorText: Colors.white,
                      backgroundColor: Colors.red,
                      margin: const EdgeInsets.all(8),
                      icon: const Icon(Icons.error),
                    );
                  }
                  controller.update(); // force refresh of connectedSystemDevices
                });
          }
        },
      ),
    );
  }
}