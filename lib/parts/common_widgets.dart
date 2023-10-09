import 'package:flutter/material.dart';

class DateTimeLabel extends StatelessWidget {
  DateTimeLabel(this.dateTime, {this.style});
  final DateTime now = DateTime.now();
  final TextStyle? style;
  final DateTime dateTime;
  static const _weekDays = ["月", "火", "水", "木", "金", "土", "日"];
  @override
  Widget build(BuildContext context) {
    final ts = style ?? DefaultTextStyle.of(context).style;
    final TextStyle textStyle = switch (dateTime.weekday - 1) {
      5 => ts.apply(color: Colors.blue),
      6 => ts.apply(color: Colors.red),
      _ => ts
    };
    return Column(children: [
      if (dateTime.day == now.day && now.hour < 17)
        Text("今日", style: textStyle),
      if (dateTime.day == now.day && now.hour >= 17)
        Text("今夜", style: textStyle),
      if (dateTime.day == now.day + 1) Text("明日", style: textStyle),
      if (dateTime.day == now.day + 2) Text("明後日", style: textStyle),
      Text(
          "${dateTime.month}/${dateTime.day}(${_weekDays[dateTime.weekday - 1]})",
          style: textStyle)
    ]);
  }
}
