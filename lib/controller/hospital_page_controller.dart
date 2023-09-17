import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
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

  final markers = <Marker>[].obs;

  @override
  void onInit() {
    readJson();
    super.onInit();
  }

  @override
  void onReady() {
    getLocation();
    super.onReady();
  }

  Future<void> readJson() async {
    final List<double> distances = [];
    final String response = await rootBundle.loadString('assets/hospital.json');
    final jsonMap = json.decode(response);

    listData.value = jsonMap['data'];
    for (var e in listData) {
      double hLatitude = double.tryParse(e['latitude'].trim()) ?? 0.0;
      double hLongitude = double.tryParse(e['longitude'].trim()) ?? 0.0;
      final distance = await calculateDistance(latitude.value, longitude.value, hLatitude, hLongitude);
      distances.add(distance);
    }

    for (int i = 0; i < listData.length - 1; i++) {
      for (int j = i + 1; j < listData.length; j++) {
        if (distances[i] < distances[j]) {
          final tempDistance = distances[i];
          distances[i] = distances[j];
          distances[j] = tempDistance;

          final tempHospital = listData[i];
          listData[i] = listData[j];
          listData[j] = tempHospital;
        }
      }
    }
  }

  Future<double> calculateDistance(double userLat, double userLong, double hospitalLat, double hospitalLong) async {
    final userLocation = LocationData.fromMap({'latitude': userLat, 'longitude': userLong});
    final hospitalLocation = LocationData.fromMap({'latitude': hospitalLat, 'longitude': hospitalLong});

    final distance = Geolocator.distanceBetween(
      userLocation.latitude!,
      userLocation.longitude!,
      hospitalLocation.latitude!,
      hospitalLocation.longitude!,
    );

    return distance;
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
