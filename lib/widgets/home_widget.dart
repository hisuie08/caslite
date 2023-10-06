import 'package:caslite/pages/weather.dart';
import 'package:caslite/providers/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hw = ref.watch(homeWidgetProvider);
    return hw.when(data: (data) {
      return CurrentWeatherWidget(data);
    }, loading: () {
      return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator()),
      );
    }, error: (error, stackTrace) {
      return Column(children: [Text("Error"), Text(stackTrace.toString())]);
    });
  }
}
