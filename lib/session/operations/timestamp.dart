import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Timestamp {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final int second;

  final NumberFormat _fourDigits = NumberFormat('0000');
  final NumberFormat _twoDigits = NumberFormat('00');

  Timestamp(
      {@required this.year,
      @required this.month,
      @required this.day,
      this.hour,
      this.minute,
      this.second});

  Timestamp.dt(DateTime dt, {bool withTime = false})
      : year = dt.year,
        month = dt.month,
        day = dt.day,
        hour = withTime ? dt.hour : null,
        minute = withTime ? dt.minute : null,
        second = withTime ? dt.second : null;

  Timestamp.invalid()
      : year = -1,
        month = -1,
        day = -1,
        hour = null,
        minute = null,
        second = null;

  static Timestamp now({bool withTime = false}) {
    return Timestamp.dt(DateTime.now(), withTime: withTime);
  }

  static Timestamp parse(String value) {
    var exp = RegExp(r'(\d{4})-(\d{2})-(\d{2})(?:T(\d{2}):(\d{2}):(\d{2}))?');
    var match = exp.firstMatch(value);

    if (match == null) {
      return Timestamp.invalid();
    }

    var year = int.parse(match[1]);
    var month = int.parse(match[2]);
    var day = int.parse(match[3]);

    var hour = (match[4] != null) ? int.parse(match[4]) : null;
    var minute = (match[5] != null) ? int.parse(match[5]) : null;
    var second = (match[6] != null) ? int.parse(match[6]) : null;

    return Timestamp(
        year: year,
        month: month,
        day: day,
        hour: hour,
        minute: minute,
        second: second);
  }

  bool get hasTime => (hour != null) && (minute != null) && (second != null);

  bool get isInvalid => (year == -1) && (month == -1) && (day == -1);

  int compareTo(Timestamp other) {
    var cmp = year - other.year;
    if (cmp != 0) {
      return cmp;
    }

    cmp = month - other.month;
    if (cmp != 0) {
      return cmp;
    }

    cmp = day - other.day;
    if (cmp != 0) {
      return cmp;
    }

    if (hour == null && other.hour != null) {
      return -1;
    }
    if (hour != null && other.hour == null) {
      return 1;
    }
    if (hour == null && other.hour == null) {
      return 0;
    }
    cmp = hour - other.hour;
    if (cmp != 0) {
      return cmp;
    }

    if (minute == null && other.minute != null) {
      return -1;
    }
    if (minute != null && other.minute == null) {
      return 1;
    }
    if (minute == null && other.minute == null) {
      return 0;
    }
    cmp = minute - other.minute;
    if (cmp != 0) {
      return cmp;
    }

    if (second == null && other.second != null) {
      return -1;
    }
    if (second != null && other.second == null) {
      return 1;
    }
    if (second == null && other.second == null) {
      return 0;
    }
    return second - other.second;
  }

  @override
  String toString() {
    var result =
        '${_fourDigits.format(year)}-${_twoDigits.format(month)}-${_twoDigits.format(day)}';
    if (hasTime) {
      result +=
          'T${_twoDigits.format(hour)}:${_twoDigits.format(minute)}:${_twoDigits.format(second)}';
    }
    return result;
  }

  DateTime toDateTime() {
    return DateTime(year, month, day, (hour != null) ? hour : 0,
        (minute != null) ? minute : 0, (second != null) ? second : 0);
  }

  Timestamp clone() {
    return Timestamp(
        year: year,
        month: month,
        day: day,
        hour: hour,
        minute: minute,
        second: second);
  }

  Timestamp withDate(int year, int month, int day) {
    return Timestamp(
        year: year,
        month: month,
        day: day,
        hour: hour,
        minute: minute,
        second: second);
  }

  Timestamp withDateDt(DateTime dt) {
    return withDate(dt.year, dt.month, dt.day);
  }

  Timestamp withTime(int hour, int minute, int second) {
    return Timestamp(
        year: year,
        month: month,
        day: day,
        hour: hour,
        minute: minute,
        second: second);
  }

  Timestamp withTimeDt(DateTime dt) {
    return withTime(dt.hour, dt.minute, dt.second);
  }

  Timestamp withoutTime() {
    return Timestamp(year: year, month: month, day: day);
  }
}
