import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../controller/hospital_page_controller.dart';

class HospitalPage extends GetView<HospitalPageController> {
  const HospitalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fasilitas Kesehatan",
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Obx(() => FlutterMap(
                  mapController: controller.mapController,
                  options: MapOptions(
                    center: LatLng(controller.latitude.value,
                        controller.longitude.value),
                    zoom: 15,
                    maxZoom: 18,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayer(
                      markers: controller.markers,
                    )
                  ],
                )),
              ),
            ),
            const SizedBox(height: 7),
            Expanded(
                child: Obx(() => ListView.builder(
                  itemCount: controller.listData.length,
                  itemBuilder: (c, i) {
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(controller.listData[i]['name']),
                          Text("Tipe : ${controller.listData[i]['type']}",
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.listData[i]['location']),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              "Kontak : ${controller.listData[i]['contact']}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        controller.moveLocation(
                            controller.listData[i]['latitude'], controller.listData[i]['longitude']);
                      },
                    );
                  },
                ))),
            const SizedBox(height: 10),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
