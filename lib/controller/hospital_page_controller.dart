import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import '../service/utils_service.dart';

class HospitalPageController extends GetxController {
  final UtilService utilService = UtilService();
  final Location location = Location();
  final MapController mapController = MapController();

  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  final listData = [].obs;
  final token = ''.obs;

  final markers = <Marker>[].obs;

  @override
  void onInit() async {
    await getLocation();
    super.onInit();
  }

  hospitalPost() async {
    if (Hive.isBoxOpen('token')) {
      var box = await Hive.openBox('token');
      token.value = box.getAt(0);
    }
    final connect = GetConnect();
    await connect.post(
        'http://192.168.93.138:8000/api/hospital',
        {
          'latitude' : latitude.toString(),
          'longitude' : longitude.toString(),
        },
        headers: {
          'Authorization': 'Bearer $token'
        }
    ).then((response) async {
      if(response.statusCode == 200) {
        listData.value = response.body['hospital'];
      }
    });
  }

  Future<void> getLocation() async {
    LocationData? userLocation = await location.getLocation();
    latitude.value = userLocation.latitude!;
    longitude.value = userLocation.longitude!;

    markers.add(
      Marker(
        width: 20.0,
        height: 40.0,
        point: LatLng(latitude.value, longitude.value),
        builder: (c) => const Icon(
          Icons.location_on_rounded,
          color: Colors.blue,
          size: 30.0,
        ),
      ),
    );

    hospitalPost();

    mapController.move(LatLng(latitude.value, longitude.value), 15.0);
  }

  void moveLocation (String lat, String long) {
    double hLatitude = double.tryParse(lat.trim()) ?? 0.0;
    double hLongitude = double.tryParse(long.trim()) ?? 0.0;

    if(markers.length == 2){
      markers.removeLast();
    }

    markers.add(
      Marker(
        width: 20.0,
        height: 40.0,
        point: LatLng(hLatitude, hLongitude),
        builder: (c) => const Icon(
          Icons.add_location_rounded,
          color: Colors.red,
          size: 30.0,
        ),
      ),
    );

    mapController.move(LatLng((hLatitude +  latitude.value) / 2, (hLongitude + longitude.value) / 2), 12);
  }


}
