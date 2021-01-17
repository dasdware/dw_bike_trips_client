import 'package:dw_bike_trips_client/queries.dart' as GraphQLQueries;
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/client.dart';
import 'package:dw_bike_trips_client/session/trips_history.dart';
import 'package:dw_bike_trips_client/session/trips_queue.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PostTripsOperation extends ValuedOperation<bool> {
  final GraphQLClient client;
  final TripsHistory tripsController;
  final List<Trip> trips;

  PostTripsOperation(this.client, this.tripsController, this.trips)
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
        }
        return success;
      },
      mutation: true,
    );
  }
}
