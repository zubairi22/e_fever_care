import 'package:e_fever_care/view/widgets/temperature_card.dart';
import 'package:e_fever_care/view/widgets/line_chart_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controller/home_page_controller.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard",
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        MaterialColor color = Colors.green;
        if (controller.temperature.value > 37.5) {
          color = Colors.red;
        } else if (controller.temperature.value < 36) {
          color = Colors.blue;
        }

        return Container(
          color: color,
          child: Center(
            child: OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  return Column(
                    children: [
                      Obx(
                            () => TemperatureCard(
                          date: controller.date.value,
                          temperature: controller.temperature.value,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.teal, width: 2),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Statistik Hari ini',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.teal.shade50,
                        margin: const EdgeInsets.all(20.0),
                        child: AspectRatio(
                          aspectRatio: 1.50,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 18,
                              left: 12,
                              top: 24,
                              bottom: 12,
                            ),
                            child: Obx(() => LineChart(lineData(controller.temperatureSpots))),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child: Obx(
                              () => TemperatureCard(
                            date: controller.date.value,
                            temperature: controller.temperature.value,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: Card(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.teal, width: 2),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Statistik Hari ini',
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.teal,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                color: Colors.teal.shade50,
                                margin: const EdgeInsets.all(20.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 18,
                                    left: 12,
                                    top: 24,
                                    bottom: 12,
                                  ),
                                  child: Obx(() => LineChart(lineData(controller.temperatureSpots))),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        );
      }),
      resizeToAvoidBottomInset: false,
    );
  }
}
