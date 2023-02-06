import 'package:dw_bike_trips_client/queries.dart' as queries;
import 'package:dw_bike_trips_client/session/dashboard.dart';
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/client.dart';
import 'package:dw_bike_trips_client/session/trips_history.dart';
import 'package:dw_bike_trips_client/session/trip.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EditTripsOperation extends ValuedOperation<bool> {
  final GraphQLClient client;
  final TripsHistory tripsController;
  final List<Trip> trips;
  final DashboardController dashboardController;

  EditTripsOperation(
      this.client, this.tripsController, this.trips, this.dashboardController)
      : super('editTrips', 'Updating enqeued trips on the server.');

  @override
  Future<ValuedOperationResult<bool>> perform(
      String pageName, OperationContext context) async {
    return doGraphQL<bool>(
      client,
      queries.editTrips(trips),
      (result) {
        var success = (result['editTrips'] == trips.length);
        if (success) {
          client.cache.store.reset();
          tripsController.invalidate();
          dashboardController.refresh();
        }
        return success;
      },
      mutation: true,
    );
  }
}
