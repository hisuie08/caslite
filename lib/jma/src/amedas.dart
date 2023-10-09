import 'dart:convert';

class AmedasInfo {
  final DateTime reportDateTime;
  final String temperature;
  final String humidity;
  final String maxTemperature;
  final String minTemperature;

  const AmedasInfo(
      {required this.reportDateTime,
      required this.temperature,
      required this.humidity,
      required this.maxTemperature,
      required this.minTemperature});
  factory AmedasInfo.fromRawJson(String str, DateTime dateTime) =>
      AmedasInfo.fromJson(json.decode(str), dateTime);
  factory AmedasInfo.fromJson(Map<String, dynamic> json, DateTime dateTime) {
    final time =
        "${dateTime.year}${dateTime.month.toString().padLeft(2, "0")}${dateTime.day.toString().padLeft(2, "0")}${dateTime.hour.toString().padLeft(2, "0")}${dateTime.minute.toString().padLeft(2, "0")}00";
    final target = json[time] ?? json.values.last;
    return AmedasInfo(
        reportDateTime: dateTime,
        temperature: target["temp"][0].toString(),
        humidity: target["humidity"][0].toString(),
        maxTemperature: target["maxTemp"][0].toString(),
        minTemperature: target["minTemp"][0].toString());
  }
}
