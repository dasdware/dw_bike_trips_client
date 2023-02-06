import 'package:dw_bike_trips_client/pages/edit_trip_page.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/session/trip.dart';
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
  const HistoryPage({Key key}) : super(key: key);

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
                ? Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: StickyGroupedListView<AccumulatedTrip, int>(
                          stickyHeaderBackgroundColor:
                              AppThemeData.mainDarkestColor,
                          groupComparator: (first, second) => second - first,
                          itemComparator: (first, second) =>
                              second.timestamp.compareTo(first.timestamp),
                          elements: snapshot.data,
                          groupBy: (trip) => calculateGroupKey(trip),
                          indexedItemBuilder: (context, trip, index) => Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 8.0, 8.0, 8.0),
                                child: AccumulatedTripPanel(
                                  trip: trip,
                                ),
                              ),
                          groupSeparatorBuilder: (value) {
                            var group = session.tripsHistory
                                .groupByKey(calculateGroupKey(value));
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GroupSeparatorPanel(
                                group: group,
                              ),
                            );
                          }),
                    ),
                  )
                : const ThemedText(
                    text: 'no data',
                  );
            return ThemedScaffold(
              pageName: 'history',
              extendBodyBehindAppBar: false,
              appBar: themedAppBar(
                title: const ThemedHeading(
                  caption: 'Timeline',
                  style: ThemedHeadingStyle.big,
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

class GroupSeparatorPanel extends StatelessWidget {
  const GroupSeparatorPanel({
    Key key,
    @required this.group,
  }) : super(key: key);

  final TripsGroup group;

  @override
  Widget build(BuildContext context) {
    var session = context.watch<Session>();

    return ThemedPanel(
      style: ThemedPanelStyle.mostEmphasized,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const MonthCalendarIcon(),
          const SizedBox(width: 8.0),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ThemedHeading(
                caption: DateFormat.yMMMM()
                    .format(DateTime(group.year, group.month)),
              ),
              Row(
                children: [
                  ThemedHeading(
                    caption: '${group.count} trips',
                    style: ThemedHeadingStyle.tiny,
                  ),
                  const ThemedDot(),
                  ThemedHeading(
                    caption: session.formatDistance(group.distance),
                    style: ThemedHeadingStyle.tiny,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AccumulatedTripPanel extends StatelessWidget {
  const AccumulatedTripPanel({
    Key key,
    @required this.trip,
  }) : super(key: key);

  final AccumulatedTrip trip;

  _editPressed(BuildContext context, Trip trip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTripPage(
          trip: context.read<Session>().changesQueue.updateTrip(trip).trip,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var session = context.watch<Session>();

    return ThemedPanel(
      style: ThemedPanelStyle.normal,
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 40),
            child: Row(
              children: [
                DayCalendarIcon(
                  day: trip.timestamp.day,
                  style: CalendarIconStyle(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(width: 16.0),
                SizedBox(
                  width: 32,
                  child: ThemedText(
                    text: '${session.formatWeekday(trip.timestamp)}'
                        .toUpperCase(),
                    textSize: ThemedTextSize.small,
                    deemphasized: true,
                  ),
                ),
                const SizedBox(width: 16.0),
                ThemedText(
                  text: session.formatDistance(trip.distance),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: (trip.count > 1)
                        ? TextButton(
                            onPressed: () =>
                                session.tripsHistory.toggleTripExpansion(trip),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ThemedText(
                                  text: '${trip.count} trips'.toUpperCase(),
                                  textSize: ThemedTextSize.small,
                                  deemphasized: true,
                                ),
                                const SizedBox(width: 4.0),
                                Icon(
                                  (!trip.expanded)
                                      ? Icons.add_circle
                                      : Icons.remove_circle,
                                  color: AppThemeData.highlightColor,
                                ),
                              ],
                            ),
                          )
                        : ThemedIconButton(
                            onPressed: () =>
                                _editPressed(context, trip.parts[0]),
                            icon: Icons.edit,
                          ),
                  ),
                ),
              ],
            ),
          ),
          if (trip.count > 1 && trip.expanded)
            Column(
              children: trip.parts.reversed
                  .map((part) => Row(
                        children: [
                          const SizedBox(
                            width: 94,
                          ),
                          ThemedText(
                            text: session.formatDistance(part.distance),
                            deemphasized: true,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: ThemedIconButton(
                                onPressed: () => _editPressed(context, part),
                                icon: Icons.edit,
                              ),
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}
