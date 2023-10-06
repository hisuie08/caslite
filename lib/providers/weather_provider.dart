import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jma_lib/jma_lib.dart';

import 'bookmarks_provider.dart';

final weatherProvider = FutureProvider.family<ForecastResult, String>(
    (ref, arg) async => await JMA(City.getById(arg)).get());

final homeWidgetProvider =
    AsyncNotifierProvider<HomeWeatherNotifier, ForecastResult>(
        HomeWeatherNotifier.new);

class HomeWeatherNotifier extends AsyncNotifier<ForecastResult> {
  @override
  FutureOr<ForecastResult> build() async {
    final b = ref.watch(bookMarksProvider).first;
    return JMA(City.getById(b.code)).get();
  }
}
