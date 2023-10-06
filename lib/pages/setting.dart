import 'package:caslite/caslite.dart';
import 'package:caslite/pages/base.dart';
import 'package:caslite/providers/bookmarks_provider.dart';
import 'package:caslite/providers/theme_provider.dart';
import 'package:caslite/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';

class PageSetting extends BaseStaticPage {
  const PageSetting();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: const Text("設定"),
                centerTitle: false),
            drawer: casliteDrawer,
            body: const SettingContainer()));
  }
}

class SettingContainer extends ConsumerWidget {
  const SettingContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Text label(data) =>
        Text(data, style: Theme.of(context).textTheme.titleMedium);
    return SettingsList(
      sections: [
        SettingsSection(title: const Text('外観'), tiles: <SettingsTile>[
          SettingsTile.navigation(
              leading: const Icon(Icons.brightness_6),
              title: label('テーマ'),
              value: Text(ref.watch(casliteThemeProvider).label),
              onPressed: (BuildContext context) => showDialog(
                  context: context,
                  builder: (context) {
                    return const SimpleDialog(children: [
                      ThemeSelectOption(AppThemeNotifier.system),
                      ThemeSelectOption(AppThemeNotifier.light),
                      ThemeSelectOption(AppThemeNotifier.dark)
                    ]);
                  })),
          SettingsTile.switchTile(
              onToggle: (value) =>
                  ref.watch(showBookmarkProvider.notifier).change(),
              initialValue: ref.watch(showBookmarkProvider),
              leading: Icon(Icons.location_pin),
              title: label('マイ地域をメニューに表示'))
        ]),
        SettingsSection(title: const Text('詳細'), tiles: [
          SettingsTile(
              leading: Icon(Icons.info),
              title: label("バージョン"),
              description: Text("$appName $appVersion"),
              onPressed: (_) => {}),
          SettingsTile(
              leading: Icon(Icons.description),
              title: label("オープンソースライセンス"),
              onPressed: (_) async => {})
        ]),
        SettingsSection(title: Text("上級設定"), tiles: [
          SettingsTile(
              leading: Icon(Icons.delete_forever),
              title: label("マイ地域をすべて削除"),
              description: Text("登録した地域をすべて消去します"),
              onPressed: (_) => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Text("警告"),
                        content: Column(children: [
                          Text("登録したマイ地域をすべて削除します"),
                          Text("よろしいですか")
                        ]),
                        actions: [
                          TextButton(
                              onPressed: () {
                                ref
                                    .watch(bookMarksProvider.notifier)
                                    .removeAll();
                                Navigator.of(context).pop();
                              },
                              child: Text("OK")),
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("キャンセル"))
                        ]);
                  }))
        ])
      ],
    );
  }
}

class ThemeSelectOption extends ConsumerWidget {
  final AppTheme theme;
  const ThemeSelectOption(this.theme, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(theme.label),
      trailing: ref.watch(casliteThemeProvider).themeMode == theme.themeMode
          ? const Icon(Icons.check)
          : null,
      onTap: () => {
        ref.watch(casliteThemeProvider.notifier).setTheme(theme.themeValue),
        Navigator.of(context).pop()
      },
    );
  }
}
