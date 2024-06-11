import 'package:fl_chart/fl_chart.dart';

class UtilService {

  final url = 'http://timesynccardia.cloud';

  List<FlSpot> chartData(List<double> data) {
    return data
        .asMap()
        .entries
        .map((entry) {
          final x = entry.key.toDouble();
          final y = entry.value.toDouble();
          return FlSpot(x, y);
        })
        .toList();
  }

  List<int> syncTime(DateTime now) {
    int year = now.year;
    int month = now.month;
    int day = now.day;
    int hour = now.hour;
    int minute = now.minute;
    int second = now.second;
    int dayOfWeek = now.weekday;

    List<int> data = [
      1, 0,
      year % 256, year ~/ 256,
      month,
      day,
      hour,
      minute,
      second,
      dayOfWeek - 1
    ];

    return makeSend(data);
  }

  List<int> makeSend(List<int> bArr) {
    List<int> bArr2 = List<int>.filled(bArr.length + 2, 0);
    int i = 0;

    for (int i2 = 0; i2 < bArr.length; i2++) {
      bArr2[i2 + i] = bArr[i2];
      if (i2 == 1) {
        int length = bArr.length + 4;
        bArr2[2] = length % 256;
        bArr2[3] = length ~/ 256;
        i = 2;
      }
    }

    return makeCRC16(bArr2);
  }

  List<int> makeCRC16(List<int> data) {
    List<int> crc = computeCRC16(data);
    List<int> result = List<int>.filled(data.length + 2, 0);

    for (int i = 0; i < data.length; i++) {
      result[i] = data[i];
    }

    result[data.length] = crc[0];
    result[data.length + 1] = crc[1];

    return result;

  }

  List<int> computeCRC16(List<int> data) {
    int crc = 0xFFFF;
    int polynomial = 0x1021;

    for (int b in data) {
      crc ^= (b << 8);

      for (int i = 0; i < 8; i++) {
        if ((crc & 0x8000) != 0) {
          crc = (crc << 1) ^ polynomial;
        } else {
          crc <<= 1;
        }
      }
    }

    crc &= 0xFFFF;

    return [(crc & 0xFF), (crc >> 8)];
  }

  int bytesToDec(List<int> bArr) {
    int i = 0;
    for (int i2 = 0; i2 < bArr.length; i2++) {
      i += (bArr[i2] & -1) << ((3 - i2) * 8);
    }
    return (i + 946684800) * 1000;
  }

}
