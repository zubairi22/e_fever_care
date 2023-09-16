import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cardia_watch/view/connect_page.dart';
import 'package:cardia_watch/view/widgets/heart_rate_card.dart';
import 'package:cardia_watch/view/widgets/rounded_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import '../controller/home_page_controller.dart';
import 'package:fl_chart/fl_chart.dart';

import '../controller/news_page_controller.dart';
import '../controller/settings_page_controller.dart';
import 'history_page.dart';
import 'home_page.dart';
import 'news_detail_page.dart';

class SettingsPage extends GetView<SettingsPageController> {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings",
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.teal,
          onPressed: () => Get.to(() => const HomePage()),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.person),
                title: const Text('Pengguna'),
                trailing: const Row(
                  children: [Text('Username'), Icon(Icons.navigate_next)],
                ),
                onPressed: (c) {
                  Get.to(() => const ConnectPage());
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.watch),
                title: const Text('Status Koneksi'),
                trailing: Obx(() => Row(
                      children: [
                        Text(controller.isConnect.value
                            ? 'Terhubung'
                            : 'Terputus'),
                        const Icon(Icons.navigate_next)
                      ],
                    )),
                onPressed: (c) {
                  Get.to(() => const ConnectPage());
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onPressed: (c) {
                  Get.to(() => const ConnectPage());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
