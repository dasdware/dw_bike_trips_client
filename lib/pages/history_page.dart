import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/session/trips_history.dart';
import 'package:dw_bike_trips_client/theme.dart' as AppTheme;
import 'package:dw_bike_trips_client/widgets/calendar_icon.dart';
import 'package:dw_bike_trips_client/widgets/themed.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var session = context.watch<Session>();

    return StreamBuilder<List<AccumulatedTrip>>(
        initialData: session.tripsHistory.trips,
        stream: session.tripsHistory.stream,
        builder: (context, snapshot) {
          Widget body = (snapshot.hasData)
              ? StickyGroupedListView<AccumulatedTrip, int>(
                  stickyHeaderBackgroundColor: AppTheme.primaryColor_4,
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
                                        '${session.formatWeekday(trip.timestamp)}',
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                ThemedText(
                                  text: session.formatDistance(trip.distance),
                                  fontSize: 19.0,
                                  color: Colors.white,
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
                                              text: '${trip.count} trips',
                                              fontSize: 14,
                                            ),
                                            SizedBox(width: 4.0),
                                            Icon(
                                              (!trip.expanded)
                                                  ? Icons.add_circle
                                                  : Icons.remove_circle,
                                              color: AppTheme.secondaryColor_2,
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
                                              color:
                                                  Colors.white.withOpacity(0.8),
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
                      child: Container(
                        // color: AppTheme.secondaryColor_2,
                        decoration: new BoxDecoration(
                          color: AppTheme.secondaryColor_2,
                          borderRadius: new BorderRadius.circular(6.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_today),
                              SizedBox(
                                width: 8.0,
                              ),
                              ThemedText(
                                text: DateFormat.yMMMM()
                                    .format(DateTime(group.year, group.month)),
                                color: AppTheme.primaryColor_4,
                                fontSize: 16.0,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ThemedText(
                                      text: '${group.count} trips',
                                      color: AppTheme.primaryColor_4,
                                      fontSize: 14.0,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    ThemedText(
                                      text: session
                                          .formatDistance(group.distance),
                                      color: AppTheme.primaryColor_4,
                                      fontSize: 14.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : ThemedText(
                  text: 'no data',
                );
          return ThemedScaffold(
            extendBodyBehindAppBar: false,
            appBar: themedAppBar(
              title: Text('Timeline'),
              actions: [
                ThemedIconButton(
                  icon: Icons.refresh,
                  onPressed: () => {session.tripsHistory.refresh()},
                )
              ],
            ),
            body: body,
          );
        });
  }
}
