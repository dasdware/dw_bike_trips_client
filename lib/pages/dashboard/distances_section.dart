import 'package:dw_bike_trips_client/session/dashboard.dart';
import 'package:dw_bike_trips_client/session/session.dart';
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

class DashboardDistancePanel extends StatelessWidget {
  const DashboardDistancePanel({
    Key key,
    @required this.icon,
    @required this.caption,
    @required this.distance,
  }) : super(key: key);

  final Widget icon;
  final String caption;
  final double distance;

  @override
  Widget build(BuildContext context) {
    return ThemedPanel(
      width: 160,
      height: 72,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 12.0,
          ),
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
