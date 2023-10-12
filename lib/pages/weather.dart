import 'package:caslite/pages/base.dart';
import 'package:caslite/providers/bookmarks_provider.dart';
import 'package:caslite/providers/weather_provider.dart';
import 'package:caslite/parts/common_widgets.dart';
import 'package:caslite/parts/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:caslite/jma/jma_lib.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

class PageWeather extends BaseConsumerPage {
  final City city;
  const PageWeather(this.city, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBar = AppBar(
      leading: BackButton(
        onPressed: () => {Navigator.of(context).pop()},
      ),
      title: Text(city.name),
      actions: [
        PopupMenuButton(itemBuilder: (_c) {
          return [
            (ref
                    .watch(bookMarksProvider)
                    .where((e) => e.code == city.id)
                    .isEmpty)
                ? PopupMenuItem(
                    child: Row(
                        children: [Icon(Icons.bookmark_add), Text("マイ地域に追加")]),
                    onTap: () {
                      ref.watch(bookMarksProvider.notifier).add(city.id);
                    },
                  )
                : PopupMenuItem(
                    child: Row(children: [
                      Icon(Icons.bookmark_remove),
                      Text("マイ地域から削除")
                    ]),
                    onTap: () {
                      ref.watch(bookMarksProvider.notifier).removeId(city.id);
                    })
          ];
        }),
      ],
    );
    return Scaffold(
        drawer: casliteDrawer, appBar: appBar, body: WeatherWidget(city));
  }
}

class WeatherWidget extends ConsumerWidget {
  final City city;
  const WeatherWidget(this.city);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wp = ref.watch(weatherProvider(city.id));
    return wp.when(
        data: (data) => RefreshIndicator(
            onRefresh: () async => {ref.invalidate(weatherProvider(city.id))},
            child: CustomScrollView(slivers: [
              SliverFillRemaining(
                  child: SafeArea(
                      child: Column(children: [
                CurrentWeatherWidget(data),
                OverViewWidget(data),
                WeekForecastWidget(data)
              ])))
            ])),
        loading: () {
          return Scaffold(
            body: Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator()),
          );
        },
        error: (error, stackTrace) {
          return Column(children: [Text("Error"), Text(stackTrace.toString())]);
        });
  }
}

extension on Widget {
  Widget setPadding({EdgeInsetsGeometry padding = const EdgeInsets.all(8)}) =>
      Padding(
        padding: padding,
        child: this,
      );
}

const _weekDays = ["月", "火", "水", "木", "金", "土", "日"];

class CurrentWeatherWidget extends StatelessWidget {
  final ForecastResult result;
  const CurrentWeatherWidget(this.result, {super.key});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDay = result.reportDatetime.hour >= 17;
    final today = result.weekForecasts.first as DayForecast;
    final card = Card(
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                  "${today.dateTime.month}/${today.dateTime.day}(${_weekDays[today.dateTime.weekday - 1]})",
                  style: textTheme.titleLarge),
              Text(
                result.publishingOffice,
                style: textTheme.labelLarge,
              )
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  WeatherIconWidget.get(today.weather, isDay),
                  Text(today.weather.label, style: textTheme.titleLarge)
                ]),
                Column(
                  children: [
                    Column(children: [
                      Row(children: [
                        Text(result.amedasInfo.temperature,
                            style: textTheme.displayMedium),
                        Text(" ℃", style: textTheme.bodyLarge)
                      ]),
                      Row(children: [
                        const Tooltip(
                          child: Icon(Icons.water_drop_outlined),
                          message: "湿度",
                        ),
                        Text(result.amedasInfo.humidity,
                            style: textTheme.titleLarge),
                        Text(" %", style: textTheme.titleLarge)
                      ])
                    ])
                  ],
                )
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(children: [
                    Text("降水確率(%)", style: textTheme.labelLarge),
                    Text(today.pop, style: textTheme.titleLarge)
                  ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("最高気温",
                                  style: textTheme.labelLarge
                                      ?.copyWith(color: Colors.red)),
                              Text(" / ", style: textTheme.labelLarge),
                              Text("最低気温",
                                  style: textTheme.labelLarge
                                      ?.copyWith(color: Colors.blue))
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(result.amedasInfo.maxTemperature,
                                  style: textTheme.titleLarge
                                      ?.copyWith(color: Colors.red)),
                              Text(" / ", style: textTheme.titleLarge),
                              Text(result.amedasInfo.minTemperature,
                                  style: textTheme.titleLarge
                                      ?.copyWith(color: Colors.blue))
                            ])
                      ])
                ]).setPadding(padding: EdgeInsets.fromLTRB(0, 8, 0, 0))
          ],
        ).setPadding(padding: const EdgeInsets.all(16)));
    return card;
  }
}

class OverViewWidget extends StatelessWidget {
  final ForecastResult result;
  const OverViewWidget(this.result, {super.key});

  @override
  Widget build(BuildContext context) {
    final today = result.weekForecasts.first;

    return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
                title: Column(children: [
                  Text(
                    result.publishingOffice,
                    textAlign: TextAlign.center,
                  )
                ]),
                scrollable: true,
                content: Container(
                  child: Column(children: [
                    if (today is DayForecast)
                      Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(Icons.wind_power), Text("風")]),
                        Text("${today.wind}").setPadding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8)),
                        if (today.wave != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(Icons.sailing), Text("波")],
                          ),
                        if (today.wave != null)
                          Text("${today.wave!}",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyLarge)
                              .setPadding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 8))
                      ]),
                    Text(result.overView.text,
                            style: Theme.of(context).textTheme.bodyLarge)
                        .setPadding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0))
                  ]),
                )),
          );
        },
        child: Card(
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            child: Column(children: [
              if (today is DayForecast)
                Text("風　${today.wind}",
                        style: Theme.of(context).textTheme.bodyLarge)
                    .setPadding(padding: const EdgeInsets.fromLTRB(8, 0, 8, 0)),
              if (today is DayForecast && today.wave != null)
                Text(("波　${today.wave}"),
                        style: Theme.of(context).textTheme.bodyLarge)
                    .setPadding(padding: const EdgeInsets.fromLTRB(8, 0, 8, 0)),
              Text(result.overView.text,
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.fade,
                      maxLines: 1)
                  .setPadding(padding: const EdgeInsets.fromLTRB(8, 8, 8, 0))
            ])).setPadding(padding: const EdgeInsets.fromLTRB(8, 0, 8, 0)));
  }
}

class WeekForecastWidget extends StatelessWidget {
  final ForecastResult result;
  const WeekForecastWidget(this.result, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    for (var forecast in result.weekForecasts) {
      children.add(weekForecastTile(context, forecast));
    }
    return SizedBox(
      height: 200,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: children,
      ).setPadding(),
    );
  }

  Widget weekForecastTile(
    BuildContext context,
    IDayForecast forecast,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final isDay = forecast.dateTime.hour != 17;
    String pop = "--";
    if (forecast is DayForecast) {
      pop = forecast.pop;
    }
    if (forecast is WeekForecast) {
      pop = forecast.pop;
    }
    return FittedBox(
        fit: BoxFit.contain,
        child: Card(
          child: Column(children: [
            DateTimeLabel(
              forecast.dateTime,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            WeatherIconWidget.get(forecast.weather, isDay),
            Text(forecast.weather.label, style: textTheme.titleLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(forecast.tempH,
                    style: textTheme.titleLarge?.copyWith(color: Colors.red)),
                Text(" / ", style: textTheme.titleLarge),
                Text(forecast.tempL,
                    style: textTheme.titleLarge?.copyWith(color: Colors.blue))
              ],
            ),
            Text("降水確率(%)", style: textTheme.labelLarge)
                .setPadding(padding: const EdgeInsets.fromLTRB(8, 8, 8, 0)),
            Text(pop, style: textTheme.titleLarge),
          ]).setPadding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 8)),
        ));
  }
}

class WeatherIconWidget extends StatelessWidget {
  factory WeatherIconWidget.get(Weather weather, bool isDay) {
    final code = isDay ? weather.dayIcon : weather.nightIcon;
    return WeatherIconWidget(code);
  }
  final String code;
  const WeatherIconWidget(this.code);
  @override
  Widget build(BuildContext context) {
    return SvgPicture(AssetBytesLoader("assets/weather_icons/$code.svg.vec"),
        width: 100);
  }
}
