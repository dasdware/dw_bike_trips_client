import 'dart:ui';
import 'dart:math';

import 'package:dw_bike_trips_client/session/dashboard.dart';
import 'package:dw_bike_trips_client/session/operations/timestamp.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:dw_bike_trips_client/widgets/calendar_icon.dart';
import 'package:dw_bike_trips_client/widgets/themed/heading.dart';
import 'package:dw_bike_trips_client/widgets/themed/panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DistancesSection extends StatelessWidget {
  const DistancesSection({
    Key key,
    @required this.distances,
  }) : super(key: key);

  final DashboardDistances distances;

  @override
  Widget build(BuildContext context) {
    var calendarIconStyle = CalendarIconStyle(
      width: 34,
      height: 34,
      color: Colors.white.withOpacity(0.6),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ThemedHeading(
          caption: 'Distances (km)',
        ),
        const SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DashboardDistancePanel(
              icon: DayCalendarIcon(
                day: Timestamp.now().day,
                style: calendarIconStyle,
              ),
              caption: 'today',
              distance: distances.today,
              referenceCaption: 'yesterday',
              referenceDistance: distances.yesterday,
            ),
            const SizedBox(
              width: 8.0,
            ),
            DashboardDistancePanel(
              icon: WeekCalendarIcon(
                style: calendarIconStyle,
              ),
              caption: 'this week',
              distance: distances.thisWeek,
              referenceCaption: 'last week',
              referenceDistance: distances.lastWeek,
            ),
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DashboardDistancePanel(
              icon: MonthCalendarIcon(
                style: calendarIconStyle,
              ),
              caption: 'this month',
              distance: distances.thisMonth,
              referenceCaption: 'last month',
              referenceDistance: distances.lastMonth,
            ),
            const SizedBox(
              width: 8.0,
            ),
            DashboardDistancePanel(
              icon: YearCalendarIcon(
                year: Timestamp.now().year,
                style: calendarIconStyle,
              ),
              caption: 'this year',
              distance: distances.thisYear,
              referenceCaption: 'last year',
              referenceDistance: distances.lastYear,
            ),
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DashboardDistancePanel(
              icon: AllTimeCalendarIcon(
                style: calendarIconStyle,
              ),
              caption: 'all time',
              distance: distances.allTime,
              width: 170,
            ),
          ],
        ),
      ],
    );
  }
}

class _DistanceProgressBarElement extends StatelessWidget {
  final double value;
  final Duration duration;
  final Color color;
  final bool displayTrack;
  final double trackSize;
  final bool displayThumb;
  final double thumbSize;
  final double thumbBorderRadius;

  const _DistanceProgressBarElement({
    Key key,
    @required this.value,
    @required this.duration,
    @required this.color,
    @required this.displayTrack,
    @required this.trackSize,
    @required this.displayThumb,
    @required this.thumbSize,
    @required this.thumbBorderRadius,
  }) : super(key: key);

  double get _thumbHalfSize => thumbSize / 2;

  double _lerpThumbTransformOffset(double t) {
    return lerpDouble(-_thumbHalfSize, _thumbHalfSize, t);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: value),
        duration: duration,
        curve: Curves.easeOut,
        builder: (BuildContext context, double size, Widget child) {
          return SizedBox(
            height: thumbSize,
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(-1, 0),
                  child: FractionallySizedBox(
                    widthFactor: (displayTrack) ? size : 0,
                    child: Container(
                      height: trackSize,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: color,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(-1 + size * 2, 0),
                  child: Transform.translate(
                    offset: Offset(_lerpThumbTransformOffset(size), 0),
                    child: AnimatedContainer(
                      duration: duration,
                      width: (displayThumb) ? thumbSize : 0,
                      height: (displayThumb) ? thumbSize : 0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(thumbBorderRadius)),
                        color: color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class DistanceProgressBar extends StatelessWidget {
  final double distance;
  final double referenceDistance;

  final Duration duration;
  final double trackSize;
  final double thumbSize;
  final double thumbBorderRadius;

  const DistanceProgressBar(
      {Key key,
      this.distance,
      this.referenceDistance,
      this.duration = const Duration(milliseconds: 300),
      this.trackSize = 8.0,
      this.thumbSize = 16.0,
      this.thumbBorderRadius = 2.0})
      : super(key: key);

  double get valuePosition {
    if (distance <= 0) {
      return 0;
    } else if (referenceDistance < distance) {
      return 1;
    } else {
      return distance / referenceDistance;
    }
  }

  double get referenceValuePosition {
    if (referenceDistance <= 0) {
      return 0;
    } else if (referenceDistance < distance) {
      return referenceDistance / distance;
    } else {
      return 1;
    }
  }

  bool get displayThumbs => distance > 0 || referenceDistance > 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: max(trackSize, thumbSize),
      child: Stack(
        children: [
          Center(
            child: Container(
                height: trackSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(trackSize)),
                  color: AppThemeData.referenceValue,
                )),
          ),

          // reference value
          _DistanceProgressBarElement(
            value: referenceValuePosition,
            duration: duration,
            color: AppThemeData.referenceValue,
            displayTrack: false,
            trackSize: trackSize,
            displayThumb: displayThumbs,
            thumbSize: thumbSize,
            thumbBorderRadius: thumbBorderRadius,
          ),

          // current value
          _DistanceProgressBarElement(
            value: valuePosition,
            duration: duration,
            color: AppThemeData.currentValue,
            displayTrack: true,
            trackSize: trackSize,
            displayThumb: displayThumbs,
            thumbSize: thumbSize,
            thumbBorderRadius: thumbBorderRadius,
          ),
        ],
      ),
    );
  }
}

class DashboardDistancePanel extends StatelessWidget {
  const DashboardDistancePanel(
      {Key key,
      @required this.icon,
      @required this.caption,
      @required this.distance,
      this.width = 160,
      this.referenceCaption,
      this.referenceDistance})
      : super(key: key);

  final Widget icon;
  final String caption;
  final double distance;
  final double width;
  final String referenceCaption;
  final double referenceDistance;

  @override
  Widget build(BuildContext context) {
    return ThemedPanel(
      width: width,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13.0, 12.0, 13.0, 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon,
                const SizedBox(
                  width: 8.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ThemedHeading(
                      caption: caption,
                      style: ThemedHeadingStyle.small,
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      context
                          .watch<Session>()
                          .formatDistance(distance, withUnit: false),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 23.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (referenceDistance != null)
              const SizedBox(
                height: 8.0,
              ),
            if (referenceDistance != null && referenceCaption != null)
              ThemedHeading(
                caption:
                    '$referenceCaption: ${context.watch<Session>().formatDistance(referenceDistance, withUnit: false)}',
                style: ThemedHeadingStyle.tiny,
              ),
            if (referenceDistance != null && referenceCaption != null)
              const SizedBox(
                height: 4.0,
              ),
            if (referenceDistance != null)
              DistanceProgressBar(
                distance: distance,
                referenceDistance: referenceDistance,
              ),
          ],
        ),
      ),
    );
  }
}
