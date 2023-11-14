import 'package:caslite/jma/jma_lib.dart';

class ForecastResult {
  final City city;
  final Forecast forecast;
  final OverView overView;
  final AmedasInfo amedasInfo;
  List<DayForecast> get dayForecasts => _parse();
  ForecastResult(
      {required this.city,
      required this.forecast,
      required this.overView,
      required this.amedasInfo});
  List<DayForecast> _parse() {
    List<DayForecast> result = [];
    for (DayForecast week in forecast.weekForecast) {
      DayForecast cur = week;
      for (var srf in forecast.srfForecast) {
        if (week.dateTime.day == srf.dateTime.day &&
            week.dateTime.month == srf.dateTime.month) {
          cur = marge(srf, week);
          break;
        }
      }
      result.add(cur);
    }
    return result;
  }

  DayForecast marge(DayForecast srf, DayForecast week) => srf
    ..tempMax = week.tempMax
    ..tempMin = week.tempMin;
}
