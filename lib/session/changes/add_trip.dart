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

  final Trip _trip;
  final TripsHistory _tripsController;
  final DashboardController _dashboardController;

  AddTripChange(this._trip, this._tripsController, this._dashboardController);
  
  @override
  Widget buildIcon(BuildContext context) {
    return const ThemedIcon(
      icon: Icons.add_circle_outline,
    );
  }

  @override
  Widget buildWidget(BuildContext context) {
    Session session = context.watch<Session>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ThemedHeading(
          caption: session.formatDistance(_trip.distance),
        ),
        ThemedText(
          text: session.formatTimestamp(_trip.timestamp),
          textSize: ThemedTextSize.small,
        ),
      ],
    );
  }

  @override
  ValuedOperation<bool> createOperation(GraphQLClient client) {
    return PostTripsOperation(client, _tripsController, [_trip], _dashboardController);
  }
}