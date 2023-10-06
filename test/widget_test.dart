import 'dart:convert';

final class BookMark {
  final int index;
  final String code;
  const BookMark({required this.index, required this.code});
  Map<String, Object> toJson() => {"index": index, "code": code};
}

void main() {
  final b = BookMark(index: 1, code: 'a');
  final e = json.encode(b.toJson());
  final j = json.decode(e);
  print(j["code"]);
}
