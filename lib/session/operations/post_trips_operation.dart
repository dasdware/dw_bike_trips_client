import 'package:dw_bike_trips_client/queries.dart' as GraphQLQueries;
import 'package:dw_bike_trips_client/session/dashboard.dart';
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/client.dart';
import 'package:dw_bike_trips_client/session/trips_history.dart';
import 'package:dw_bike_trips_client/session/trips_queue.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PostTripsOperation extends ValuedOperation<bool> {
  final GraphQLClient client;
  final TripsHistory tripsController;
  final List<Trip> trips;
  final DashboardController dashboardController;

  PostTripsOperation(
      this.client, this.tripsController, this.trips, this.dashboardController)
      : super('postTrips', 'Posting enqeued trips to server.');

  @override
  Future<ValuedOperationResult<bool>> perform(OperationContext context) async {
    return doGraphQL<bool>(
      client,
      GraphQLQueries.postTrips(trips),
      (result) {
        var success = (result['postTrips'] == trips.length);
        // print(client.cache).data);
        if (success) {
          client.cache.reset();
          tripsController.invalidate();
          dashboardController.refresh();
        }
        return success;
      },
      mutation: true,
    );
  }
}
