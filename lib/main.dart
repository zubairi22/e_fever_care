import 'dart:io';

import 'package:cardia_watch/binding/main_bindings.dart';
import 'package:cardia_watch/view/history/history_page.dart';
import 'package:cardia_watch/view/home_page.dart';
import 'package:cardia_watch/view/hospital/hospital_page.dart';
import 'package:cardia_watch/view/news/news_page.dart';
import 'package:cardia_watch/view/settings_page.dart';
import 'package:cardia_watch/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('heartRateData');
  await Hive.openBox('heartRateHistory');
  await Hive.openBox('deviceData');

  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    [
      Permission.location,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan
    ].request().then((status) {
      runApp(const MyApp());
    });
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cardia Watch',
      theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Noto Sans'),
      initialRoute: '/',
      initialBinding: MainBindings(),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page: () => const Splash()),
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/history', page: () => const HistoryPage()),
        GetPage(name: '/news', page: () => const NewsPage()),
        GetPage(name: '/hospital', page: () => const HospitalPage()),
        GetPage(name: '/setting', page: () => const SettingsPage()),
      ],
    );
  }
}
