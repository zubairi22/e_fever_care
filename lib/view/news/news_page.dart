import 'package:e_fever_care/view/widgets/rounded_image_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/news_page_controller.dart';
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
    );
  }
}
