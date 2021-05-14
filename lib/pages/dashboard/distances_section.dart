import 'package:dw_bike_trips_client/session/dashboard.dart';
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
        ThemedHeading(
          caption: 'Distances (km)',
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DashboardDistancePanel(
              icon: DayCalendarIcon(
                day: DateTime.now().day,
                style: calendarIconStyle,
              ),
              caption: 'today',
              distance: distances.today,
              referenceCaption: 'yesterday',
              referenceDistance: distances.yesterday,
            ),
            SizedBox(
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
        SizedBox(
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
            SizedBox(
              width: 8.0,
            ),
            DashboardDistancePanel(
              icon: YearCalendarIcon(
                year: DateTime.now().year,
                style: calendarIconStyle,
              ),
              caption: 'this year',
              distance: distances.thisYear,
              referenceCaption: 'last year',
              referenceDistance: distances.lastYear,
            ),
          ],
        ),
        SizedBox(
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
            ),
          ],
        ),
      ],
    );
  }
}

class DistanceProgressBar extends StatelessWidget {
  final double distance;
  final double referenceDistance;

  const DistanceProgressBar({Key key, this.distance, this.referenceDistance})
      : super(key: key);

  double get factor {
    if (referenceDistance == 0) {
      return 1;
    } else {
      return distance / referenceDistance;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.0,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: AppThemeData.panelMostEmphasizedBackground,
      ),
      child: FractionallySizedBox(
        widthFactor: factor,
        child: Container(
          height: 8.0,
          width: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: AppThemeData.headingColor,
          ),
        ),
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
      this.referenceCaption,
      this.referenceDistance})
      : super(key: key);

  final Widget icon;
  final String caption;
  final double distance;
  final String referenceCaption;
  final double referenceDistance;

  @override
  Widget build(BuildContext context) {
    return ThemedPanel(
      width: 160,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon,
                SizedBox(
                  width: 8.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ThemedHeading(
                      caption: caption,
                      style: ThemedHeadingStyle.Small,
                    ),
                    SizedBox(
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
            if (this.referenceDistance != null)
              SizedBox(
                height: 8.0,
              ),
            if (this.referenceDistance != null && this.referenceCaption != null)
              ThemedHeading(
                caption:
                    '${this.referenceCaption}: ${context.watch<Session>().formatDistance(referenceDistance, withUnit: false)}',
                style: ThemedHeadingStyle.Tiny,
              ),
            if (this.referenceDistance != null && this.referenceCaption != null)
              SizedBox(
                height: 4.0,
              ),
            if (this.referenceDistance != null)
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
