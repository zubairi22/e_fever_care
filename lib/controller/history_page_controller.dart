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
  final listKeys = [].obs;
  final listLength = 0.obs;

  Set<String> uniqueDates = {};

  String dateYesterday = DateFormat('yyyy-MM-dd').format(DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1));

  @override
  Future<void> onInit() async {
    dayTemperatureSpots.value = utilService.chartData([]);
    getTemperatureHistory(dateYesterday);
    super.onInit();
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

      for (var entry in dataList) {
        DateTime date = DateTime.parse(entry['date']);
        String formattedDate = "${date.year}-${date.month}-${date.day}";

        if(date.year != DateTime.now().year && date.month != DateTime.now().month && date.day != DateTime.now().day) {
          uniqueDates.add(formattedDate);
        }
      }

      listKeys.value = uniqueDates.toList();
      listLength.value = uniqueDates.length - 1;

      List<dynamic> dayDataList = dataList.where((entry) {
        DateTime date = DateTime.parse(entry['date']);
        return date.year == dateTime.year && date.month == dateTime.month && date.day == dateTime.day;
      }).toList();

      print('INI DATA DAY LIST $dayDataList' );

      if (dayDataList.isNotEmpty) {
        double totalTemp = 0.0;

        for (var entry in dayDataList) {
          double temp = entry['temperature'];
          if (temp < min.value) min.value = temp;
          if (temp > max.value) max.value = temp;
          totalTemp += temp;
        }

        average.value = (totalTemp / dayDataList.length).toStringAsFixed(2);

        dayTemperatureSpots.value = utilService.chartData(dayDataList);
      }
    }
  }
}
