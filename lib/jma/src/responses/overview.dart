import 'dart:convert';

class OverView {
  final String publishingOffice;
  final DateTime reportDatetime;
  final String targetArea;
  final String headlineText; // 警戒情報概要。通常は空文字列
  final String text;

  const OverView({
    required this.publishingOffice,
    required this.reportDatetime,
    required this.targetArea,
    required this.headlineText,
    required this.text,
  });

  factory OverView.fromJson(String str) => OverView._fromJson(json.decode(str));

  factory OverView._fromJson(Map<String, dynamic> json) => OverView(
        publishingOffice: json["publishingOffice"],
        reportDatetime: DateTime.parse(json["reportDatetime"]),
        targetArea: json["targetArea"],
        headlineText: json["headlineText"],
        text: json["text"],
      );
}
