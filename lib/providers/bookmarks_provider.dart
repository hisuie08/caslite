import 'dart:convert';

import 'package:caslite/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class BookMark {
  final int index;
  final String code;
  const BookMark({required this.index, required this.code});
  factory BookMark.fromMap(String data) {
    final parsed = json.decode(data);
    return BookMark(index: parsed["index"], code: parsed["code"]);
  }
  Map<String, Object> toMap() => {"index": index, "code": code};
}

typedef BookMarkList = List<BookMark>;
final bookMarksProvider =
    StateNotifierProvider<BookMarksNotifier, BookMarkList>(
        (ref) => BookMarksNotifier());

class BookMarksNotifier extends StateNotifier<BookMarkList> {
  static const key = "bookmarks";
  final pref = SharedPreferencesInstance().pref;
  BookMarksNotifier() : super([]) {
    state = _load() ?? [];
  }

  List<BookMark>? _load() {
    final loaded = pref.getStringList(key);
    if (loaded != null) {
      final List<BookMark> result = [
        for (var bm in loaded) BookMark.fromMap(bm)
      ];
      return result;
    } else {
      return null;
    }
  }

  Future<void> add(String code) async =>
      storeData(state..add(BookMark(index: state.length, code: code)));

  Future<void> remove(int index) async => storeData(state..removeAt(index));

  Future<void> removeId(String code) async =>
      storeData(state..removeWhere((element) => element.code == code));
  Future<void> replace(int before, int after) async {
    final list = [...state];
    list[before] = state[after];
    list[after] = state[before];
    storeData(list);
  }

  Future<void> removeAll() async => storeData(state..clear());

  Future<void> storeData(List<BookMark> _state) async {
    await pref.setStringList(
        key, [for (var bm in _state) json.encode(bm.toMap())]).then((value) {
      if (value) {
        state = [..._state];
      }
    });
  }
}

final showBookmarkProvider = StateNotifierProvider<ShowBookmarkNotifier, bool>(
    (ref) => ShowBookmarkNotifier());

class ShowBookmarkNotifier extends StateNotifier<bool> {
  static const key = "showBookmark";

  final pref = SharedPreferencesInstance().pref;
  ShowBookmarkNotifier() : super(true) {
    state = _load() ?? true;
  }

  Future<void> change() async {
    await pref.setBool(key, !state).then((v) {
      if (v) {
        state = !state;
      }
    });
  }

  bool? _load() => pref.getBool(key);
}
