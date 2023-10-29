import 'package:caslite/jma/jma_lib.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dateParser test', () {
    var answer = parseTime("2023-10-29T11:00:00+09:00");
    expect(answer, DateTime(2023, 10, 29, 11, 0));
  });
}
