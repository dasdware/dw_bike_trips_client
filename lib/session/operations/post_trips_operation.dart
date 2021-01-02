import 'package:dw_bike_trips_client/queries.dart' as GraphQLQueries;
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/client.dart';
import 'package:dw_bike_trips_client/session/trips_queue.dart';
import 'package:dw_bike_trips_client/session/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PostTripsOperation extends ValuedOperation<bool> {
  final GraphQLClient client;
  final List<Trip> trips;

  PostTripsOperation(this.client, this.trips)
      : super('postTrips', 'Posting enqeued trips to server.');

  @override
  Future<ValuedOperationResult<bool>> perform(OperationContext context) async {
    return doGraphQL<bool>(
      client,
      GraphQLQueries.postTrips(trips),
      (result) => result['postTrips'] == trips.length,
      mutation: true,
    );
  }
}
