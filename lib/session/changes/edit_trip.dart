import 'package:dw_bike_trips_client/pages/edit_trip_page.dart';
import 'package:dw_bike_trips_client/session/changes_queue.dart';
import 'package:dw_bike_trips_client/session/dashboard.dart';
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/edit_trips_operation.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/session/trip.dart';
import 'package:dw_bike_trips_client/session/trips_history.dart';
import 'package:dw_bike_trips_client/widgets/themed/heading.dart';
import 'package:dw_bike_trips_client/widgets/themed/icon.dart';
import 'package:dw_bike_trips_client/widgets/themed/text.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class EditTripChange extends Change {
  final Trip _originalTrip;
  final ChangeableTrip _trip;
  final TripsHistory _tripsController;
  final DashboardController _dashboardController;

  EditTripChange(Trip trip, this._tripsController, this._dashboardController)
      : _originalTrip = trip,
        _trip = ChangeableTrip(trip);

  ChangeableTrip get trip => _trip;

  _diff(String from, String to) {
    if (from == to) {
      return from;
    }
    return '$from ➞ $to';
  }

  @override
  Widget buildIcon(BuildContext context) {
    return const ThemedIcon(
      icon: Icons.change_circle_outlined,
    );
  }

  @override
  Widget buildWidget(BuildContext context) {
    Session session = context.watch<Session>();
    return StreamBuilder<Trip>(
        initialData: _trip.trip,
        stream: _trip.stream,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ThemedHeading(
                caption: _diff(
                  session.formatDistance(_originalTrip.distance),
                  session.formatDistance(snapshot.data.distance),
                ),
              ),
              ThemedText(
                text: _diff(
                  session.formatTimestamp(_originalTrip.timestamp),
                  session.formatTimestamp(snapshot.data.timestamp),
                ),
                textSize: ThemedTextSize.small,
                textAlign: TextAlign.start,
              ),
            ],
          );
        });
  }

  @override
  ValuedOperation<bool> createOperation(GraphQLClient client) {
    return EditTripsOperation(
        client, _tripsController, [_trip.trip], _dashboardController);
  }

  @override
  bool canEdit() {
    return true;
  }

  @override
  void edit(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => EditTripPage(trip: _trip)));
  }
}
