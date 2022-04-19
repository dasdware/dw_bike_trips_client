import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/session/trips_history.dart';
import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:dw_bike_trips_client/widgets/calendar_icon.dart';
import 'package:dw_bike_trips_client/widgets/page.dart';
import 'package:dw_bike_trips_client/widgets/themed/dot.dart';
import 'package:dw_bike_trips_client/widgets/themed/heading.dart';
import 'package:dw_bike_trips_client/widgets/themed/icon_button.dart';
import 'package:dw_bike_trips_client/widgets/themed/panel.dart';
import 'package:dw_bike_trips_client/widgets/themed/scaffold.dart';
import 'package:dw_bike_trips_client/widgets/themed/text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var session = context.watch<Session>();

    return ApplicationPage(
      pageName: 'history',
      child: StreamBuilder<List<AccumulatedTrip>>(
          initialData: session.tripsHistory.trips,
          stream: session.tripsHistory.stream,
          builder: (context, snapshot) {
            Widget body = (snapshot.hasData)
                ? StickyGroupedListView<AccumulatedTrip, int>(
                    stickyHeaderBackgroundColor: AppThemeData.mainDarkestColor,
                    groupComparator: (first, second) => second - first,
                    itemComparator: (first, second) =>
                        second.timestamp.compareTo(first.timestamp),
                    elements: snapshot.data,
                    groupBy: (trip) => calculateGroupKey(trip),
                    indexedItemBuilder: (context, trip, index) => Padding(
                          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  DayCalendarIcon(
                                    day: trip.timestamp.day,
                                    style: CalendarIconStyle(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Container(
                                    width: 32,
                                    child: ThemedText(
                                      text:
                                          '${session.formatWeekday(trip.timestamp)}'
                                              .toUpperCase(),
                                      textSize: ThemedTextSize.Small,
                                      deemphasized: true,
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  ThemedText(
                                    text: session.formatDistance(trip.distance),
                                  ),
                                  if (trip.count > 1)
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: FlatButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () => session.tripsHistory
                                              .toggleTripExpansion(trip),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ThemedText(
                                                text: '${trip.count} trips'
                                                    .toUpperCase(),
                                                textSize: ThemedTextSize.Small,
                                                deemphasized: true,
                                              ),
                                              SizedBox(width: 4.0),
                                              Icon(
                                                (!trip.expanded)
                                                    ? Icons.add_circle
                                                    : Icons.remove_circle,
                                                color:
                                                    AppThemeData.highlightColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (trip.count > 1 && trip.expanded)
                                Column(
                                  children: trip.parts.reversed
                                      .map((part) => Row(
                                            children: [
                                              SizedBox(
                                                width: 94,
                                              ),
                                              ThemedText(
                                                text: session.formatDistance(
                                                    part.distance),
                                                deemphasized: true,
                                              ),
                                            ],
                                          ))
                                      .toList(),
                                ),
                            ],
                          ),
                        ),
                    groupSeparatorBuilder: (value) {
                      var group = session.tripsHistory
                          .groupByKey(calculateGroupKey(value));
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ThemedPanel(
                          style: ThemedPanelStyle.Emphasized,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MonthCalendarIcon(),
                              SizedBox(width: 8.0),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ThemedHeading(
                                    caption: DateFormat.yMMMM().format(
                                        DateTime(group.year, group.month)),
                                  ),
                                  Row(
                                    children: [
                                      ThemedHeading(
                                        caption: '${group.count} trips',
                                        style: ThemedHeadingStyle.Tiny,
                                      ),
                                      ThemedDot(),
                                      ThemedHeading(
                                        caption: session
                                            .formatDistance(group.distance),
                                        style: ThemedHeadingStyle.Tiny,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                : ThemedText(
                    text: 'no data',
                  );
            return ThemedScaffold(
              pageName: 'history',
              extendBodyBehindAppBar: false,
              appBar: themedAppBar(
                title: ThemedHeading(
                  caption: 'Timeline',
                  style: ThemedHeadingStyle.Big,
                ),
                actions: [
                  ThemedIconButton(
                    icon: Icons.refresh,
                    onPressed: () => {session.tripsHistory.refresh()},
                  )
                ],
              ),
              body: body,
            );
          }),
    );
  }
}
