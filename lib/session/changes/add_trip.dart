import 'package:dw_bike_trips_client/pages/edit_trip_page.dart';
import 'package:dw_bike_trips_client/session/changes_queue.dart';
import 'package:dw_bike_trips_client/session/dashboard.dart';
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/post_trips_operation.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/session/trip.dart';
import 'package:dw_bike_trips_client/session/trips_history.dart';
import 'package:dw_bike_trips_client/widgets/themed/heading.dart';
import 'package:dw_bike_trips_client/widgets/themed/icon.dart';
import 'package:dw_bike_trips_client/widgets/themed/text.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class AddTripChange extends Change {

  final ChangeableTrip _trip;
  final TripsHistory _tripsController;
  final DashboardController _dashboardController;

  AddTripChange(Trip trip, this._tripsController, this._dashboardController)
    : _trip = ChangeableTrip(trip);
  
  @override
  Widget buildIcon(BuildContext context) {
    return const ThemedIcon(
      icon: Icons.add_circle_outline,
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
              caption: session.formatDistance(snapshot.data.distance),
            ),
            ThemedText(
              text: session.formatTimestamp(snapshot.data.timestamp),
              textSize: ThemedTextSize.small,
            ),
          ],
        );
      }
    );
  }

  @override
  ValuedOperation<bool> createOperation(GraphQLClient client) {
    return PostTripsOperation(client, _tripsController, [_trip.trip], _dashboardController);
  }

  @override
  bool canEdit() {
    return true;
  }

  @override
  void edit(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditTripPage(trip: _trip)));
  }
}