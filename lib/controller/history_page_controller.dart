import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../service/utils_service.dart';

class HistoryPageController extends GetxController {
  final UtilService utilService = UtilService();
  final dayTemperatureSpots = <FlSpot>[].obs;
  final max = 0.0.obs;
  final min = 0.0.obs;
  final average = '0'.obs;
  final token = ''.obs;
  final listDates = [].obs;
  final dateKeys = 0.obs;

  Set<String> uniqueDates = {};

  String dateYesterday = DateFormat('yyyy-MM-dd').format(DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1));

  @override
  Future<void> onInit() async {
    dayTemperatureSpots.value = utilService.chartData([]);
    setupPage();
    getTemperatureHistory(dateYesterday);
    super.onInit();
  }

  Future<void> setupPage() async {
    if (Hive.isBoxOpen('temperatureData')) {
      var box = await Hive.openBox('temperatureData');
      List<dynamic> dataList = box.get('TempList', defaultValue: []);
      for (var entry in dataList) {
        DateTime date = DateTime.parse(entry['date']);
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
        if (date.isBefore(DateTime.now().subtract(Duration(
          hours: DateTime.now().hour,
          minutes: DateTime.now().minute,
          seconds: DateTime.now().second,
          milliseconds: DateTime.now().millisecond,
          microseconds: DateTime.now().microsecond,
        )))) {
          uniqueDates.add(formattedDate);
        }
      }

      listDates.value = uniqueDates.toList();
      dateKeys.value = uniqueDates.length - 1;
    }

  }

  Future<void> getTemperatureHistory(String date) async {
    if (Hive.isBoxOpen('temperatureData')) {
      var box = await Hive.openBox('temperatureData');
      populateData(box, date);
      update();
    }
  }

  void populateData(Box box, String date) {
    if (box.isNotEmpty) {
      DateTime dateTime = DateTime.parse(date);
      List<dynamic> dataList = box.get('TempList', defaultValue: []);

      List<dynamic> dayDataList = dataList.where((entry) {
        DateTime date = DateTime.parse(entry['date']);
        return date.year == dateTime.year && date.month == dateTime.month && date.day == dateTime.day;
      }).toList();

      if (dayDataList.isNotEmpty) {
        double totalTemp = 0.0;

        for (var entry in dayDataList) {
          double temp = entry['temperature'];
          if(min.value == 0.0) min.value = temp;
          if (temp < min.value) min.value = temp;
          if (temp > max.value) max.value = temp;
          totalTemp += temp;
        }

        average.value = (totalTemp / dayDataList.length).toStringAsFixed(2);

        dayTemperatureSpots.value = utilService.chartData(dayDataList, dateDiff: dateTime);
      }
    }
  }
}
