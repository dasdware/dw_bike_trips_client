import 'package:dw_bike_trips_client/queries.dart' as queries;
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/client.dart';
import 'package:dw_bike_trips_client/session/operations/timestamp.dart';
import 'package:dw_bike_trips_client/session/trip.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TripsOperation extends ValuedOperation<List<Trip>> {
  final GraphQLClient client;
  final int limit;
  final int offset;

  TripsOperation(this.client, {this.limit = 20, this.offset = 0})
      : super('trips', 'Fetching trips from server.');

  @override
  Future<ValuedOperationResult<List<Trip>>> perform(
      String pageName, OperationContext context) async {
    return doGraphQL(
      client,
      queries.trips,
      (result) {
        List<dynamic> loadedTrips = result['trips'];
        return loadedTrips
            .map((t) => Trip(
                id: int.parse(t["id"]),
                timestamp: Timestamp.parse(t["timestamp"]),
                distance: t["distance"] + 0.0))
            .toList();
      },
      variables: {"limit": limit, "offset": offset},
    );
  }
}
