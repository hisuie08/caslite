import 'dart:convert';

import 'package:caslite/jma/jma_lib.dart';

class Forecast {
  final JMA _jma;
  final Map<String, dynamic> _srf;
  final Map<String, dynamic> _week;
  Forecast(this._srf, this._week, this._jma);
  factory Forecast.fromJson(String str, JMA jma) {
    final dec = json.decode(str);
    final _srf = dec[0];
    final _week = dec[1];
    return Forecast(_srf, _week, jma);
  }

  DateTime get reportDateTime => parseTime(_srf["reportDatetime"]);
  String get publishingOffice => _srf["publishingOffice"];
  List<DayForecast> get weekForecast => _parseWeek(_week);
  List<DayForecast> get srfForecast => _parseSrf(_srf);

  List<DayForecast> _parseSrf(Map<String, dynamic> _srf) {
    final json = _srf["timeSeries"]; //直近予報
    final List<DayForecast> result = [];
    final weathers = json[0]["areas"][_fetchSrfWeather(json[0])];
    for (var timeDefine in json[0]["timeDefines"]) {
      final index = json[0]["timeDefines"].indexOf(timeDefine);
      final dateTime = parseTime(timeDefine);
      final pops = _fetchPops(json[1], dateTime);
      final dayForecast = DayForecast()
        ..dateTime = dateTime
        ..weather = Weather.fromId(weathers["weatherCodes"][index])
        ..wind = weathers["winds"][index]
        ..wave = weathers["waves"]?[index] ?? null
        ..pops = pops
        ..tempMax = 0 //srfのtempは事実上使わない
        ..tempMin = 0;
      result.add(dayForecast);
    }
    return result;
  }

  List<DayForecast> _parseWeek(Map<String, dynamic> _j) {
    final json = _j["timeSeries"]; // 週間予報部分
    final List<DayForecast> result = [];
    final weathers =
        json[0]["areas"][_fetchWeekWeather(json[0]["areas"])]; // 天気
    final amedas = json[1]["areas"][_fetchWeekAmedas(json[1]["areas"])]; //降水確率

    for (var timeDefine in json[0]["timeDefines"]) {
      final index = json[0]["timeDefines"].indexOf(timeDefine);
      final dayForecast = DayForecast()
        ..dateTime = parseTime(timeDefine)
        ..weather = Weather.fromId(weathers["weatherCodes"][index])
        ..pops = List<int>.filled(4, int.tryParse(weathers["pops"][index]) ?? 0)
        ..tempMin = double.tryParse(amedas["tempsMin"][index]) ?? 0
        ..tempMax = double.tryParse(amedas["tempsMax"][index]) ?? 0;
      result.add(dayForecast);
    }
    return result;
  }

  int _fetchAreaIndex(List areas, String key) =>
      areas.indexWhere((area) => area["area"]["code"] == key);

  int _fetchWeekWeather(List areas) {
    for (var w in _jma.city.weekList) {
      final fetch = _fetchAreaIndex(areas, w.week);
      if (fetch >= 0) {
        return fetch;
      } else {
        continue;
      }
    }
    return 0;
  }

  int _fetchWeekAmedas(List areas) {
    for (var w in _jma.city.weekList) {
      final fetch = _fetchAreaIndex(areas, w.amedas);
      if (fetch >= 0) {
        return fetch;
      } else {
        continue;
      }
    }
    return 0;
  }

  int _fetchSrfWeather(Map<String, dynamic> json) =>
      _fetchAreaIndex(json["areas"], _jma.city.srf);
  int _fetchSrfPop(Map<String, dynamic> json) =>
      _fetchAreaIndex(json["areas"], _jma.city.srf);

  List<int> _fetchPops(Map<String, dynamic> json, DateTime date) {
    final area = json["areas"][_fetchSrfPop(json)];
    final result = List<int>.filled(4, 0, growable: false);
    for (var timeDefine in json["timeDefines"]) {
      final index = json["timeDefines"].indexOf(timeDefine);
      final dateTime = parseTime(timeDefine);
      if (dateTime.day == date.day && dateTime.month == date.month) {
        switch (dateTime.hour) {
          case 0:
            result[0] = int.parse(area["pops"][index]);
            break;
          case 6:
            result[0] = int.parse(area["pops"][index]);
            break;
          case 12:
            result[0] = int.parse(area["pops"][index]);
            break;
          case 18:
            result[0] = int.parse(area["pops"][index]);
            break;
        }
      }
    }
    return result;
  }
}

class DayForecast {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(0);
  Weather weather = Weather.fromId("100");
  List<int>? pops = [];
  String? wind = null;
  String? wave = null;
  double tempMin = 0;
  double tempMax = 0;
  DayForecast();
}
