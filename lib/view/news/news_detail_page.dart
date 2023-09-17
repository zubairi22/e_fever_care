import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/news_page_controller.dart';

class NewsDetailPage extends GetView<NewsPageController> {
  final Map<String, dynamic> listData;
  const NewsDetailPage(this.listData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Artikel Detail",
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                    borderRadius: BorderRadius.circular(
                        12.0), // Adjust the radius as needed
                    child: Image.asset(
                      listData['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(listData['title'],
                      style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 7),
                  Text(
                    listData['description'],
                    textAlign: TextAlign.justify,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
