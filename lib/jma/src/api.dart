import 'dart:convert';
import 'dart:io';

import 'package:caslite/jma/jma_lib.dart';

import 'package:http/http.dart' as http;

class JMA {
  static const baseUrl = "www.jma.go.jp";
  static const epOverview = "bosai/forecast/data/overview_forecast/";
  static const epWarning = "bosai/warning/data/warning/";
  static const epForecast = "bosai/forecast/data/forecast/";
  static const epAmedas = "bosai/amedas/data/point/";
  static const epAmedasLatest = "bosai/amedas/data/latest_time.txt";

  final City city;
  String? altAmedas;
  final DateTime current = DateTime.now();
  JMA(this.city, {this.altAmedas}) {}
  Future<OverView> getOverview() async {
    final path = "$epOverview${city.officeCode}.json";
    final response = await _request(path);
    return OverView.fromJson(response);
  }

  Future<Forecast> getForecast() async {
    final path = "$epForecast${city.officeCode}.json";
    final response = await _request(path);
    return Forecast.fromJson(response, this);
  }

  Future<AmedasInfo> getAmedasInfo() async {
    String amedasCode = altAmedas ?? city.amedasList.first.id;
    final latest = await _request(epAmedasLatest);
    final endpoint = AmedasInfo.endPointResolver(parseTime(latest));
    final path = "$epAmedas$amedasCode/$endpoint";
    final response = await _request(path);
    return AmedasInfo.fromJson(response);
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
    final amedasInfo = await getAmedasInfo();
    return ForecastResult(
        city: city,
        forecast: forecast,
        overView: overview,
        amedasInfo: amedasInfo);
  }
}
