import 'package:cardia_watch/controller/home_page_controller.dart';
import 'package:get/get.dart';

import '../controller/connect_page_controller.dart';
import '../controller/history_page_controller.dart';
import '../controller/news_page_controller.dart';
import '../controller/settings_page_controller.dart';

class MainBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageController());
    Get.lazyPut(() => ConnectPageController());
    Get.lazyPut(() => HistoryPageController());
    Get.lazyPut(() => NewsPageController());
    Get.lazyPut(() => SettingsPageController());
  }
}