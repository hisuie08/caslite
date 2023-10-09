import 'package:caslite/caslite.dart';
import 'package:caslite/pages/locale.dart';
import 'package:caslite/pages/setting.dart';
import 'package:caslite/providers/bookmarks_provider.dart';
import 'package:caslite/parts/bookmarks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const casliteDrawer = CasliteDrawer();

class CasliteDrawer extends ConsumerWidget {
  const CasliteDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookMarksProvider);
    final show = ref.watch(showBookmarkProvider);

    return Drawer(
        child: Column(children: [
      CasliteDrawerHeader(),
      Expanded(
          child: Column(children: [
        NavItemWidget(
            "地域", Icon(Icons.location_on), () => PageLocale().router(context)),
        if (show)
          for (var bm in bookmarks) BookMarkItem(bm, bookmarks.indexOf(bm) == 0)
      ])),
      NavItemWidget(
          "設定", Icon(Icons.settings), () => PageSetting().router(context))
    ]));
  }
}

class CasliteDrawerHeader extends StatelessWidget {
  const CasliteDrawerHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: const FractionalOffset(0.6, 0.5),
            end: const FractionalOffset(0.8, 0.0),
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
            stops: const [
              0,
              1,
            ],
            tileMode: TileMode.decal),
      ),
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(0),
        child: Row(
          textBaseline: TextBaseline.alphabetic,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(appName, style: TextStyle(fontSize: 28)),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(appVersion, style: TextStyle(fontSize: 28)),
            )
          ],
        ),
      ),
    );
  }
}

class NavItemWidget extends StatelessWidget {
  final String title;
  final Icon icon;
  final Function onTap;
  const NavItemWidget(this.title, this.icon, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: icon,
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
        onTap: () => onTap);
  }
}
