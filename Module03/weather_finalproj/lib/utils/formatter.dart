import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<String> formatTime(List<String> times) {
  final DateTime now = DateTime.now();
  final List<String> result = [];
  final DateTime startOfDay =
      DateTime(now.year, now.month, now.day).subtract(Duration(minutes: 1));
  final DateTime endOfDay = startOfDay.add(Duration(days: 1));

  for (var i = 0; i < times.length; i++) {
    final dateTime = DateTime.parse(times[i]);
    if (dateTime.isAfter(startOfDay) && dateTime.isBefore(endOfDay)) {
      result.add(times[i].substring(times[i].indexOf('T') + 1));
    }
  }
  return result;
}

List<String> formatDate(List<String> dates) {
  debugPrint('diqwjhoijdqw');
  final List<String> result = [];
  for (var i = 0; i < dates.length; i++) {
    DateTime parsed = DateTime.parse(dates[i]);
    result.add(DateFormat('dd/MM').format(parsed));
  }
  debugPrint('---$result!');
  return result;
}
