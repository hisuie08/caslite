import 'dart:convert';
import 'package:intl/intl.dart';

class AmedasInfo {
  final DateTime reportDateTime;
  final String temperature;
  final String humidity;
  final String maxTemperature;
  final String minTemperature;

  static String endPointResolver(DateTime time) {
    // 最新amedasのエンドポイントリゾルバ
    final int timeKey = 3 * (time.hour / 3).floor();
    final String epDate = [
      for (int t in [time.year, time.month, time.day])
        t.toString().padLeft(2, "0")
    ].join();
    final String epTime = timeKey.toString().padLeft(2, "0");
    return "${epDate}_${epTime}.json";
  }

  const AmedasInfo(
      {required this.reportDateTime,
      required this.temperature,
      required this.humidity,
      required this.maxTemperature,
      required this.minTemperature});
  factory AmedasInfo.fromJson(String str) =>
      AmedasInfo._fromJson(json.decode(str));
  factory AmedasInfo._fromJson(Map<String, dynamic> json) {
    final key = json.keys.last;
    final target = json[key];
    return AmedasInfo(
        reportDateTime: DateFormat("yyyyMMddhhmmss").parse(key),
        temperature: target["temp"][0].toString(),
        humidity: target["humidity"][0].toString(),
        maxTemperature: target["maxTemp"][0].toString(),
        minTemperature: target["minTemp"][0].toString());
  }
}
