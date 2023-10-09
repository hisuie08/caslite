import 'dart:convert';
import 'dart:io';

import 'package:caslite/jma/jma_lib.dart';

import '../src/amedas.dart';
import 'package:http/http.dart' as http;

class ForecastResult extends Forecast {
  final City city;
  final OverView overView;
  final AmedasInfo amedasInfo;
  ForecastResult(this.city, this.overView, this.amedasInfo,
      {required super.publishingOffice,
      required super.reportDatetime,
      required super.weekForecasts,
      required super.amedasCode});
  factory ForecastResult.from(
      Forecast forecast, OverView overView, AmedasInfo amedasInfo, City city) {
    return ForecastResult(city, overView, amedasInfo,
        publishingOffice: forecast.publishingOffice,
        reportDatetime: forecast.reportDatetime,
        weekForecasts: forecast.weekForecasts,
        amedasCode: forecast.amedasCode);
  }
}

class CityForAPI extends City {
  String? altAmedas = null;
  late List<Week> weeks;
  CityForAPI(
      {required super.id,
      required super.name,
      required super.kana,
      required super.prefecture,
      required super.officeCode,
      required super.srf}) {
    weeks = Week.getWeeks(srf);
  }
  factory CityForAPI.copyWith(City city, {String? altAmedas}) => CityForAPI(
      id: city.id,
      name: city.name,
      kana: city.kana,
      prefecture: city.prefecture,
      officeCode: city.officeCode,
      srf: city.srf);
  CityForAPI setAltAmedas(String amedas) => this..altAmedas = amedas;
}

class JMA {
  static const baseUrl = "www.jma.go.jp";
  static const epOverview = "bosai/forecast/data/overview_forecast/";
  static const epWarning = "bosai/warning/data/warning/";
  static const epForecast = "bosai/forecast/data/forecast/";
  static const epAmedas = "bosai/amedas/data/point/";
  static const epAmedasLatest = "bosai/amedas/data/latest_time.txt";
  // ignore: library_private_types_in_public_api
  late CityForAPI city;
  JMA(City city, {String? altAmedas}) {
    this.city = CityForAPI.copyWith(city);
  }
  Future<OverView> getOverview() async {
    final path = "$epOverview${city.officeCode}.json";
    final response = await _request(path);
    return OverView.fromRawJson(response);
  }

  Future<Forecast> getForecast() async {
    final path = "$epForecast${city.officeCode}.json";
    final response = await _request(path);
    return Forecast.fromRawJson(response, city);
  }

  Future<AmedasInfo> getAmedasInfo(String amedasCode) async {
    final latest = await _request(epAmedasLatest);
    final time = parseTime(latest);
    final timeKey = 3 * (time.hour / 3).floor();
    final endpoint =
        "${time.year}${time.month.toString().padLeft(2, "0")}${time.day.toString().padLeft(2, "0")}_${timeKey.toString().padLeft(2, "0")}.json";
    final path = "$epAmedas$amedasCode/$endpoint";
    final response = await _request(path);
    return AmedasInfo.fromRawJson(response, time);
  }

  Future<String> _request(String path) async {
    final response = await http
        .get(Uri.https(baseUrl, path, {"Content-Type": "application/json"}));
    if (response.statusCode == 404) {
      throw const HttpException("");
    }
    return utf8.decode(response.bodyBytes);
  }

  Future<ForecastResult> get() async {
    final OverView overview = await getOverview();
    final Forecast forecast = await getForecast();
    final amedasInfo = await getAmedasInfo(forecast.amedasCode);
    return ForecastResult.from(forecast, overview, amedasInfo, city);
  }
}
