import 'dart:convert';

import 'package:caslite/jma/jma_lib.dart';

class Forecast {
  final JMA _jma;
  final Map<String, dynamic> _json;
  Forecast(this._json, this._jma);
  factory Forecast.fromJson(String str, JMA jma) =>
      Forecast(json.decode(str), jma);

  DateTime get reportDateTime => parseTime(_json[0]["reportDatetime"]);
  String get publishingOffice => _json[0]["publishingOffice"];
  List<DayForecast> get weekForecast {
    return marge(parseSrf(_json), parseWeek(_json));
  }

  List<DayForecast> parseSrf(Map<String, dynamic> _j) {
    final amedasCode = _jma.altAmedas ?? _jma.city.amedasList.first.id;
    final json = _j[0]["timeSeries"]; //直近予報
    final List<DayForecast> result = [];
    final weathers = json[0]["areas"][_jma.city.srf];
    final amedas = json[1]["areas"][amedasCode];
    for (var timeDefine in json[0]["timeDefines"]) {
      final index = weathers["timeDefines"].indexOf(timeDefine);
      final dayForecast = DayForecast()..dateTime = parseTime(timeDefine);
      result.add(dayForecast);
    }
    return result;
  }

  List<DayForecast> parseWeek(Map<String, dynamic> _j) {
    final json = _j[1]["timeSeries"]; // 週間予報部分
    final List<DayForecast> result = [];
    final weathers =
        json[0]["areas"][_fetchWeek(json, _jma.city.weekList)]; // 天気
    final amedas =
        json[1]["areas"][_fetchWeek(json, _jma.city.weekList, type: 1)]; //降水確率

    for (var timeDefine in json[0]["timeDefines"]) {
      final index = weathers["timeDefines"].indexOf(timeDefine);
      final dayForecast = DayForecast()
        ..dateTime = parseTime(timeDefine)
        ..weather = Weather.fromId(weathers["weatherCodes"][index])
        ..pop = int.tryParse(weathers["pops"][index]) ?? 0
        ..tempMin = double.tryParse(amedas["tempsMin"][index]) ?? 0
        ..tempMax = double.tryParse(amedas["tempsMax"][index]) ?? 0;
      result.add(dayForecast);
    }
    return result;
  }

  List<DayForecast> marge(List<DayForecast> srf, List<DayForecast> week) {
    final List<DayForecast> result = srf;
    for (var w in week) {
      for (var s in result) {
        if (w.dateTime.day == s.dateTime.day ||
            w.dateTime.month == s.dateTime.month ||
            w.dateTime.year == s.dateTime.year) {
          result.add(w);
        }
      }
    }
    return result;
  }

  int _fetchWeek(Map<String, dynamic> json, List<Week> weeks, {int type = 0}) {
    //使用する週間予報区域の特定 type:0 =>天気 1=>amedas
    if (weeks.length == 1) 0;
    for (var w in weeks) {
      final key = (type == 0) ? w.week : w.amedas;
      final List areas = json[type]["areas"];
      for (var area in areas) {
        if (area["code"] == key) {
          return areas.indexOf(area);
        }
      }
    }
    return 0;
  }
}

class DayForecast {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(0);
  Weather weather = Weather.fromId("100");
  int pop = 0;
  String? wind = null;
  String? wave = null;
  double tempMin = 0;
  double tempMax = 0;
  DayForecast();
}
