import 'package:flutter/material.dart';

class CalendarIconStyle {
  final double width;
  final double height;
  final double headerHeight;
  final double lineWidth;
  final Color color;
  final double borderRadius;
  final double childPadding;

  const CalendarIconStyle(
      {this.width = 30.0,
      this.height = 30.0,
      this.headerHeight = 8.0,
      this.lineWidth = 2.0,
      this.color = const Color(0xCFFFFFFF),
      this.borderRadius = 4.0,
      this.childPadding = 2.0});
}

class CalendarIcon extends StatelessWidget {
  final Widget child;
  final CalendarIconStyle style;

  const CalendarIcon(
      {Key key, this.style = const CalendarIconStyle(), @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: style.width,
          height: style.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(style.borderRadius),
            border: Border.all(
              color: style.color,
              width: style.lineWidth,
            ),
          ),
        ),
        Positioned(
          left: style.lineWidth,
          right: style.lineWidth,
          top: style.headerHeight - style.lineWidth,
          height: style.lineWidth,
          child: Container(
            color: style.color,
          ),
        ),
        Positioned(
          left: style.lineWidth + style.childPadding,
          right: style.lineWidth + style.childPadding,
          top: style.headerHeight + style.childPadding,
          bottom: style.lineWidth + style.childPadding,
          child: child,
        ),
      ],
    );
  }
}

class DayCalendarIcon extends StatelessWidget {
  final int day;
  final CalendarIconStyle style;

  const DayCalendarIcon(
      {Key key, @required this.day, this.style = const CalendarIconStyle()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarIcon(
      style: style,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          day.toString(),
          style: TextStyle(
            color: style.color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}

class TodayCalendarIcon extends StatelessWidget {
  final CalendarIconStyle style;

  const TodayCalendarIcon({Key key, this.style = const CalendarIconStyle()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarIcon(
      style: style,
      child: Stack(
        children: [
          Positioned(
            width: 8,
            height: 8,
            right: 0,
            top: 1,
            child: Container(
              decoration: BoxDecoration(
                color: style.color.withOpacity(0.3),
                border: Border.all(
                  color: style.color,
                  width: 2, //this.style.lineWidth,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeekCalendarIcon extends StatelessWidget {
  final CalendarIconStyle style;

  const WeekCalendarIcon({Key key, this.style = const CalendarIconStyle()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarIcon(
      style: style,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 1,
            height: 8,
            child: Container(
              decoration: BoxDecoration(
                color: style.color.withOpacity(0.3),
                border: Border.all(
                  color: style.color,
                  width: style.lineWidth,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MonthCalendarIcon extends StatelessWidget {
  final CalendarIconStyle style;

  const MonthCalendarIcon({Key key, this.style = const CalendarIconStyle()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarIcon(
      style: style,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: style.color.withOpacity(0.3),
                border: Border.all(
                  color: style.color,
                  width: style.lineWidth,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class YearCalendarIcon extends StatelessWidget {
  final int year;
  final CalendarIconStyle style;

  const YearCalendarIcon(
      {Key key, @required this.year, this.style = const CalendarIconStyle()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarIcon(
      style: style,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          year.toString(),
          style: TextStyle(
            color: style.color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}

class AllTimeCalendarIcon extends StatelessWidget {
  final CalendarIconStyle style;

  const AllTimeCalendarIcon({Key key, this.style = const CalendarIconStyle()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarIcon(
      style: style,
      child: Padding(
        padding: const EdgeInsets.only(top: 1),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Σ',
            style: TextStyle(
              color: style.color,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
