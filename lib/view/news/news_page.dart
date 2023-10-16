import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cardia_watch/view/widgets/rounded_image_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/news_page_controller.dart';
import '../home_page.dart';
import 'news_detail_page.dart';

class NewsPage extends GetView<NewsPageController> {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Artikel",
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
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
                itemBuilder: (c, i) {
                  return RoundedImageCard(
                    imageUrl: '${controller.utilService.url}/storage/${controller.listData[i]['image']}',
                    title: controller.listData[i]['title'],
                    onTap: () =>
                        Get.to(() => NewsDetailPage(controller.listData[i])),
                  );
                }))),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const HomePage()),
        child: const Icon(Icons.home),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: controller.utilService.iconList,
        activeColor: Colors.teal,
        activeIndex: 1,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: 15,
        rightCornerRadius: 15,
        onTap: (index) => Get.toNamed((controller.utilService.pageList[index])),
      ),
    );
  }
}
