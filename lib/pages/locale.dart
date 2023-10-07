import 'package:caslite/pages/base.dart';
import 'package:caslite/pages/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caslite/jma/jma_lib.dart';

import '../widgets/drawer.dart';

class SearchNotifier extends StateNotifier<List<City>> {
  SearchNotifier() : super(City.all);
  void update(String text) {
    state = [
      ...City.all
          .where((element) =>
              element.kana.contains(text) || element.name.contains(text))
          .toList()
    ];
  }
}

final searchProvider =
    StateNotifierProvider.autoDispose<SearchNotifier, List<City>>(
        (ref) => SearchNotifier());

class PageLocaleSearch extends BaseConsumerPage {
  const PageLocaleSearch();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = ref.watch(searchProvider);
    return Scaffold(
        appBar: AppBar(title: TextField(onChanged: (value) {
          ref.read(searchProvider.notifier).update(value);
        })),
        body: ListView(children: [
          for (var city in search)
            ListTile(
                title: Text(city.name),
                trailing: const Icon(Icons.chevron_right),
                subtitle: Text(
                  city.kana,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                onTap: () => PageWeather(city).router(context))
        ]));
  }
}

class PageLocale extends BaseStaticPage {
  const PageLocale({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [];
    for (final reg in Region.all) {
      final List<Widget> item = [];
      item.add(regItem(context, reg));
      final prefByRegion = Prefecture.all.where((p) => p.region == reg.id);
      for (var pref in prefByRegion) {
        item.add(prefectureItem(context, pref));
      }
      items.addAll(item);
    }
    return Scaffold(
        drawer: casliteDrawer,
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => {Navigator.of(context).pop()},
            ),
            title: Text("地域"),
            actions: [
              IconButton(
                  onPressed: () => PageLocaleSearch().router(context),
                  icon: Icon(Icons.search))
            ]),
        body: ListView(children: items));
  }
}

class PageLocaleSub extends BaseStaticPage {
  final Prefecture prefecture;
  const PageLocaleSub(this.prefecture, {super.key});

  @override
  Widget build(BuildContext context) {
    final citiesByPrefecture =
        City.all.where((c) => c.prefecture == prefecture.id);
    return Scaffold(
        drawer: casliteDrawer,
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => {Navigator.of(context).pop()},
            ),
            title: Text(prefecture.name)),
        body: ListView(children: [
          for (final city in citiesByPrefecture) cityItem(context, city)
        ]));
  }
}

ListTile regItem(BuildContext context, Region reg) {
  return ListTile(
    title: Text(reg.name,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 12,
        )),
    tileColor: Theme.of(context).colorScheme.surfaceVariant,
  );
}

ListTile prefectureItem(BuildContext context, Prefecture pref) {
  final name = pref.name;
  return ListTile(
      title: Text(name),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => PageLocaleSub(pref).router(context));
}

ListTile cityItem(BuildContext context, City city) {
  final id = city.id;
  id;
  final name = city.name;
  final kana = city.kana;
  return ListTile(
      title: Text(name),
      trailing: const Icon(Icons.chevron_right),
      subtitle: Text(
        kana,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      onTap: () => PageWeather(city).router(context));
}
