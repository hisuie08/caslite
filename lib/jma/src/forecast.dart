import 'dart:convert';
import 'dart:core';
import 'package:collection/collection.dart';
import '../src/api.dart';
import '../src/utils.dart';
import '../src/weather.dart';

class IDayForecast {
  final DateTime dateTime;
  String tempH;
  String tempL;
  final Weather weather;
  IDayForecast(this.dateTime, this.tempH, this.tempL, this.weather);
}

class WeekForecast implements IDayForecast {
  @override
  final DateTime dateTime;
  @override
  final Weather weather;
  String pop;
  @override
  String tempH;
  @override
  String tempL;
  final String reliability;
  WeekForecast(this.dateTime, this.weather, this.pop, this.tempH, this.tempL,
      this.reliability);
}

class DayForecast implements IDayForecast {
  @override
  final DateTime dateTime;
  @override
  final Weather weather;
  String pop;
  @override
  String tempH;
  @override
  String tempL;
  final String wind;
  final String? wave;
  final bool needCompletion;
  DayForecast(this.dateTime, this.weather, this.pop, this.tempH, this.tempL,
      this.wind, this.wave,
      {required this.needCompletion});
}

class Forecast {
  final String publishingOffice;
  final DateTime reportDatetime;
  final String amedasCode;
  final List<IDayForecast> weekForecasts;
  Forecast(
      {required this.publishingOffice,
      required this.reportDatetime,
      required this.weekForecasts,
      required this.amedasCode});

  factory Forecast.fromRawJson(String str, CityForAPI city) {
    final List<dynamic> decodedJson = json.decode(str);

    final Map<String, dynamic> json4days = decodedJson[0];
    final Map<String, dynamic> json4week = decodedJson[1];

    final publishingOffice = json4week["publishingOffice"];
    final reportDatetime = parseTime(json4week["reportDatetime"]);

    final List<DayForecast> dayForecasts = getDays(json4days, city);
    final List<IDayForecast> weekForecasts = getWeek(json4week, city);
    final String _amedasCode = findAmedas(json4week["timeSeries"][1], city);

    final List<IDayForecast> result = List.of(weekForecasts);
    for (var day in dayForecasts) {
      final WeekForecast? sameDay = weekForecasts
          .cast()
          .singleWhereOrNull((w) => w.dateTime.day == day.dateTime.day);
      if (sameDay == null) {
        result.add(day);
      } else {
        if (day.needCompletion) {
          day.pop = sameDay.pop;
          day.tempH = sameDay.tempH;
          day.tempL = sameDay.tempL;
        }
        final index = weekForecasts.indexOf(sameDay);
        result.removeAt(index);
        result.insert(index, day);
      }
    }
    result.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return Forecast(
        publishingOffice: publishingOffice,
        reportDatetime: reportDatetime,
        weekForecasts: result,
        amedasCode: _amedasCode);
  }
}

List<DayForecast> getDays(Map<String, dynamic> json, CityForAPI city) {
  final List<DayForecast> result = [];
  final weathers = json["timeSeries"][0];
  final pops = json["timeSeries"][1];
  final temps = json["timeSeries"][2];
  final areaWeather = findArea(weathers, city);
  final areaPops = findArea(pops, city);
  final areaTemps = findWeekTemp(temps, city);

  for (var t in weathers["timeDefines"]) {
    final timeDef = parseTime(t);
    final int cur = weathers["timeDefines"].indexOf(t);
    final weather = Weather.fromId(areaWeather["weatherCodes"][cur]);
    final wind = areaWeather["winds"][cur];
    final wave = areaWeather["waves"]?[cur];
    final List<String> pop4day = ["--", "--", "--", "--"];
    final temps4day = ["--", "--"];
    bool needCompletion = true;
    for (var pt in pops["timeDefines"]) {
      final pd = parseTime(pt);
      if (pd.day == timeDef.day) {
        needCompletion = false;
        final pop = areaPops["pops"][pops["timeDefines"].indexOf(pt)];
        switch (pd.hour) {
          case 0:
            pop4day[0] = pop;
            break;
          case 6:
            pop4day[1] = pop;
            break;
          case 12:
            pop4day[2] = pop;
            break;
          case 18:
            pop4day[3] = pop;
            break;
          default:
        }
      }
    }
    for (var tt in temps["timeDefines"]) {
      final td = parseTime(tt);
      if (td.day == timeDef.day) {
        final temp = areaTemps["temps"][temps["timeDefines"].indexOf(tt)];
        switch (td.hour) {
          case 0:
            temps4day[0] = temp;
            break;
          case 9:
            temps4day[1] = temp;
        }
      }
    }
    final tempMin = temps4day[0];
    final tempMax = temps4day[1];
    String pop = pop4day.join("/");
    final forecast = DayForecast(
        timeDef, weather, pop, tempMax, tempMin, wind, wave,
        needCompletion: needCompletion);
    result.add(forecast);
  }
  return result;
}

List<WeekForecast> getWeek(Map<String, dynamic> json, CityForAPI city) {
  ///週間天気予報パース

  List<WeekForecast> result = [];
  final weathers = json["timeSeries"][0];
  final temps = json["timeSeries"][1];
  final weekWeather = findWeekWeather(weathers, city);
  final weekTemp = findWeekTemp(temps, city);

  for (var t in weathers["timeDefines"]) {
    if (temps["timeDefines"][weathers["timeDefines"].indexOf(t)] != t) {
      throw Error();
    }
    final timeDef = parseTime(t);
    final int cur = weathers["timeDefines"].indexOf(t);
    final Weather weather = Weather.fromId(weekWeather["weatherCodes"][cur]);
    final String pop = valueString(weekWeather["pops"][cur]);
    final String reliability = valueString(weekWeather["reliabilities"][cur]);

    final String tempMin = valueString(weekTemp["tempsMin"][cur]);
    final String tempMax = valueString(weekTemp["tempsMax"][cur]);
    final forecast =
        WeekForecast(timeDef, weather, pop, tempMax, tempMin, reliability);
    result.add(forecast);
  }
  return result;
}

dynamic findArea(dynamic obj, CityForAPI city) {
  for (var area in obj["areas"]) {
    if (area["area"]["code"] == city.srf) {
      return area;
    }
  }
  throw Error();
}

dynamic findWeekWeather(dynamic obj, CityForAPI city) {
  for (var week in city.weeks) {
    for (var area in obj["areas"]) {
      if (area["area"]["code"] == week.week) {
        return area;
      }
    }
  }
  throw Error();
}

dynamic findWeekTemp(dynamic obj, CityForAPI city) {
  for (var week in city.weeks) {
    for (var area in obj["areas"]) {
      if (area["area"]["code"] == week.amedas) {
        return area;
      }
    }
  }
  throw Error();
}

String findAmedas(dynamic obj, CityForAPI city) {
  for (var week in city.weeks) {
    for (var area in obj["areas"]) {
      if (area["area"]["code"] == week.amedas) {
        return area["area"]["code"];
      }
    }
  }
  throw Error();
}
