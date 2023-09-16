import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cardia_watch/view/connect_page.dart';
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
import 'news_page.dart';

class NewsDetailPage extends GetView<NewsPageController> {
  final Map<String, dynamic> listData;
  const NewsDetailPage(this.listData,  {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Artikel Detail", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon : const Icon(Icons.arrow_back),
          color: Colors.teal,
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0), // Adjust the radius as needed
                    child: Image.asset(
                      listData['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(listData['title'],
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600
                      )),
                  SizedBox(height: 7),
                  Text(listData['description'],textAlign: TextAlign.justify,),
                ],
              )
          ),
        ),
      ),
    );
  }
}
