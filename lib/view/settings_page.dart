import 'package:e_fever_care/view/connect/connect_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';

import '../controller/settings_page_controller.dart';

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
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() => SettingsList(
        lightTheme:
        const SettingsThemeData(settingsListBackground: Colors.white),
        sections: [
          SettingsSection(
            title: const Text('Informasi Akun'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.person_pin_rounded),
                title: const Text('Username'),
                trailing: Text(controller.name.value),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.person),
                title: const Text('Umur'),
                trailing: Text(controller.age.value),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.height),
                title: const Text('Tinggi'),
                trailing: Text(controller.height.value),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.monitor_weight),
                title: const Text('Berat'),
                trailing: Text(controller.weight.value),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.male),
                title: const Text('Jenis Kelamin'),
                trailing: Text(controller.gender.value),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Device'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.watch),
                title: const Text('Status Koneksi'),
                trailing: Row(
                  children: [
                    Text(controller.isConnect.value
                        ? 'Terhubung'
                        : 'Terputus'),
                    const Icon(Icons.navigate_next)
                  ],
                ),
                onPressed: (c) {
                  Get.to(() => const ConnectPage());
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onPressed: (c) {
                  controller.logout();
                },
              ),
            ],
          ),
        ],
      )),
      resizeToAvoidBottomInset: false,
    );
  }
}
