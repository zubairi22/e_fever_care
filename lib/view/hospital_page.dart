import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cardia_watch/view/connect_page.dart';
import 'package:cardia_watch/view/settings_page.dart';
import 'package:cardia_watch/view/widgets/heart_rate_card.dart';
import 'package:cardia_watch/view/widgets/rounded_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:get/get.dart';
import '../controller/home_page_controller.dart';
import 'package:fl_chart/fl_chart.dart';

import '../controller/news_page_controller.dart';
import 'history_page.dart';
import 'home_page.dart';
import 'news_detail_page.dart';
import 'news_page.dart';

class HospitalPage extends GetView<NewsPageController> {
  const HospitalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Artikel", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: Obx(() => ListView.builder(
                itemCount: controller.listData.length,
                itemBuilder: (c,i) {
                  return RoundedImageCard(
                    imageUrl: controller.listData[i]['imageUrl'],
                    title: controller.listData[i]['title'],
                    onTap: () => Get.to(() => NewsDetailPage(controller.listData[i])),
                  );
                }))
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const HomePage()),
        child: const Icon(Icons.home),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: controller.iconList,
        activeIndex: 0,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: 15,
        rightCornerRadius: 15,
        onTap: (index) => index == 0 ? Get.to(() => const HistoryPage()) : Get.to(() => const NewsPage()),
      ),
    );
  }
}
