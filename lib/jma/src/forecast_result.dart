import 'package:caslite/jma/jma_lib.dart';

class ForecastResult {
  final City city;
  final OverView overView;
  final AmedasInfo amedasInfo;
  final DateTime reportDateTime;
  final String publishingOffice;
  final List<DayForecast> dayForecasts;
  ForecastResult(
      {required this.city,
      required this.overView,
      required this.amedasInfo,
      required this.reportDateTime,
      required this.publishingOffice,
      required this.dayForecasts});
  static ForecastResult build(
      City city, Forecast forecast, OverView overView, AmedasInfo amedasInfo) {
    final String publishingOffice = overView.publishingOffice;
    final DateTime reportDateTime = overView.reportDatetime;
    final List<DayForecast> dayForecasts = ForecastResult._parse(forecast);
    dayForecasts.first
      ..tempMax = amedasInfo.maxTemperature
      ..tempMin = amedasInfo.minTemperature;
    return ForecastResult(
        city: city,
        overView: overView,
        amedasInfo: amedasInfo,
        reportDateTime: reportDateTime,
        publishingOffice: publishingOffice,
        dayForecasts: dayForecasts);
  }

  static List<DayForecast> _parse(Forecast _forecast) {
    List<DayForecast> result = [];
    for (DayForecast week in _forecast.weekForecast) {
      DayForecast cur = week;
      for (var srf in _forecast.srfForecast) {
        if (week.dateTime.day == srf.dateTime.day &&
            week.dateTime.month == srf.dateTime.month) {
          cur = srf
            ..tempMax = week.tempMax
            ..tempMin = week.tempMin;
          break;
        }
      }
      result.add(cur);
    }
    return result
      ..sort((a, b) => a.dateTime.millisecondsSinceEpoch
          .compareTo(b.dateTime.millisecondsSinceEpoch));
  }
}
