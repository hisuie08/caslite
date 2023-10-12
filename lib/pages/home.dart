import 'package:caslite/pages/base.dart';
import 'package:caslite/pages/locale.dart';
import 'package:caslite/pages/weather.dart';
import 'package:caslite/providers/bookmarks_provider.dart';
import 'package:caslite/parts/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caslite/jma/jma_lib.dart';

class Home extends BaseConsumerPage {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(bookMarksProvider);
    if (setup.length == 0) {
      return SafeArea(
          child: Scaffold(
        drawer: casliteDrawer,
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Text("地域が登録されていません"),
              TextButton.icon(
                  onPressed: () {
                    PageLocale().router(context);
                  },
                  icon: Icon(Icons.add),
                  label: Text("地域を追加"))
            ])),
      ));
    } else {
      return HomeWeather(City.getById(setup.first.code));
    }
  }
}

class HomeWeather extends ConsumerWidget {
  final City city;
  const HomeWeather(this.city, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBar = AppBar(title: Text(city.name), actions: [
      PopupMenuButton(itemBuilder: (_c) {
        return [
          (ref.watch(bookMarksProvider).where((e) => e.code == city.id).isEmpty)
              ? PopupMenuItem(
                  child: Row(
                      children: [Icon(Icons.bookmark_add), Text("マイ地域に追加")]),
                  onTap: () {
                    ref.watch(bookMarksProvider.notifier).add(city.id);
                  })
              : PopupMenuItem(
                  child: Row(children: [
                    Icon(Icons.bookmark_remove),
                    Text("マイ地域から削除")
                  ]),
                  onTap: () {
                    ref.watch(bookMarksProvider.notifier).removeId(city.id);
                  })
        ];
      })
    ]);
    return Scaffold(
        drawer: casliteDrawer, appBar: appBar, body: WeatherWidget(city));
  }
}
