import 'package:e_fever_care/view/widgets/line_chart_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controller/history_page_controller.dart';

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
                  child: Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.navigate_before),
                            color: Colors.teal,
                            onPressed: () {
                              if (controller.listLength.value > 0) {
                                controller.listLength.value--;
                                controller.getTemperatureHistory(controller
                                    .listKeys[controller.listLength.value]);
                              }
                            },
                          ),
                          Text(
                              controller.listKeys.isNotEmpty
                                  ? controller.listKeys[controller.listLength.value]
                                  : controller.dateYesterday,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700)),
                          IconButton(
                            icon: const Icon(Icons.navigate_next),
                            color: Colors.teal,
                            onPressed: () {
                              if (controller.listLength.value < controller.listKeys.length - 1) {
                                controller.listLength.value++;
                                controller.getTemperatureHistory(controller
                                    .listKeys[controller.listLength.value]);
                              }
                            },
                          ),
                        ],
                      ))),
            ),
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
                      child: Obx(() => LineChart(
                          lineData(controller.dayTemperatureSpots))),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() => Card(
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
                            Icon(Icons.thermostat,
                                color: Colors.red, size: 8.w),
                            const SizedBox(width: 5),
                            Column(
                              children: [
                                Text(controller.max.value.toString(),
                                    style: TextStyle(fontSize: 16.sp)),
                                const Text('Tertinggi',
                                    style: TextStyle(fontSize: 12)),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.thermostat,
                                color: Colors.green, size: 8.w),
                            const SizedBox(width: 5),
                            Column(
                              children: [
                                Text(controller.average.value.toString(),
                                    style: TextStyle(fontSize: 16.sp)),
                                const Text('Rata-Rata',
                                    style: TextStyle(fontSize: 12)),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.thermostat,
                                color: Colors.blue, size: 8.w),
                            const SizedBox(width: 5),
                            Column(
                              children: [
                                Text(controller.min.value.toString(),
                                    style: TextStyle(fontSize: 16.sp)),
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
      resizeToAvoidBottomInset: false,
    );
  }
}
