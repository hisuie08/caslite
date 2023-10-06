import 'package:caslite/pages/weather.dart';
import 'package:caslite/providers/bookmarks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jma_lib/jma_lib.dart';

class BookMarkItem extends ConsumerWidget {
  final BookMark bm;
  final bool isHome;
  const BookMarkItem(this.bm, this.isHome, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final city = City.getById(bm.code);
    return GestureDetector(
        onLongPressStart: (details) {
          final RenderObject? overlay =
              Overlay.of(context).context.findRenderObject();
          final position = RelativeRect.fromRect(
              Rect.fromLTWH(
                  details.globalPosition.dx, details.globalPosition.dy, 30, 30),
              Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                  overlay.paintBounds.size.height));
          showMenu(context: context, position: position, items: [
            if (!isHome)
              PopupMenuItem(
                child: Text("ホームに設定"),
                onTap: () {
                  ref
                      .watch(bookMarksProvider.notifier)
                      .replace(ref.watch(bookMarksProvider).indexOf(bm), 0);
                },
              ),
            PopupMenuItem(
              child: Text("削除"),
              onTap: () {
                ref.watch(bookMarksProvider.notifier).removeId(city.id);
              },
            )
          ]);
        },
        child: ListTile(
          leading: Icon(Icons.bookmark,
              color: (isHome) ? Theme.of(context).colorScheme.primary : null),
          title: Text(
            City.getById(bm.code).name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          onTap: () =>
              {Navigator.of(context).pop(), PageWeather(city).router(context)},
        ));
  }
}
