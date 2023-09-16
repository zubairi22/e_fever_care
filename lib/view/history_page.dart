import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cardia_watch/view/connect_page.dart';
import 'package:cardia_watch/view/settings_page.dart';
import 'package:cardia_watch/view/widgets/heart_rate_card.dart';
import 'package:cardia_watch/view/widgets/line_chart_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:get/get.dart';
import '../controller/history_page_controller.dart';
import '../controller/home_page_controller.dart';
import 'package:fl_chart/fl_chart.dart';

import '../controller/news_page_controller.dart';
import 'home_page.dart';
import 'news_page.dart';

class HistoryPage extends GetView<HistoryPageController> {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat",
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 60,
              child: Card(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Colors.teal.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Obx(() =>
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.navigate_before),
                            color: Colors.teal,
                            onPressed: () {
                              if (controller.daysLength.value > 0) {
                                controller.daysLength.value--;
                                controller.getHeartRateHistory(controller.daysInMonth[controller.daysLength.value]);
                              }
                            },
                          ),
                          Text(
                              controller.daysInMonth.isNotEmpty
                                  ? controller
                                  .daysInMonth[controller.daysLength.value]
                                  .toString()
                                  .substring(0, 10)
                                  : controller.dateYesterday
                                  .toString()
                                  .substring(0, 10),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700)),
                          IconButton(
                            icon: const Icon(Icons.navigate_next),
                            color: Colors.teal,
                            onPressed: () {
                              if (controller.daysLength.value < controller.daysInMonth.length - 1) {
                                controller.daysLength.value++;
                                controller.getHeartRateHistory(controller.daysInMonth[controller.daysLength.value]);
                              }
                            },
                          ),
                        ],
                      ))),
            ),
            Obx(() =>
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  color: Colors.teal.shade50,
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 0.8,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 22,
                            left: 16,
                            top: 24,
                            bottom: 12,
                          ),
                          child: LineChart(
                              lineData(controller.dayHeartRateSpots.value)),
                        ),
                      ),
                    ],
                  ),
                )),
            Obx(() =>
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  color: Colors.teal.shade50,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.favorite,
                                color: Colors.red, size: 35),
                            const SizedBox(width: 5),
                            Column(
                              children: [
                                Text(controller.maxToday.toString(),
                                    style: const TextStyle(fontSize: 18)),
                                const Text('Tertinggi',
                                    style: TextStyle(fontSize: 12)),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.favorite,
                                color: Colors.green, size: 35),
                            const SizedBox(width: 5),
                            Column(
                              children: [
                                Text(controller.minToday.toString(),
                                    style: const TextStyle(fontSize: 18)),
                                const Text('Rata-Rata',
                                    style: TextStyle(fontSize: 12)),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.favorite,
                                color: Colors.blue, size: 35),
                            const SizedBox(width: 5),
                            Column(
                              children: [
                                Text(controller.minToday.toString(),
                                    style: const TextStyle(fontSize: 18)),
                                const Text('Terendah',
                                    style: TextStyle(fontSize: 12)),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const HomePage()),
        child: const Icon(Icons.home),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: controller.iconList,
        activeIndex: 1,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: 15,
        rightCornerRadius: 15,
        onTap: (index) =>
        index == 0
            ? Get.to(() => const HistoryPage())
            : Get.to(() => const NewsPage()),
      ),
    );
  }
}
