DateTime parseTime(String time) {
  return DateTime.parse(time.replaceFirst(RegExp(r'\+.+'), ""));
}

String valueString(String value) {
  return value.isNotEmpty ? value : "--";
}
