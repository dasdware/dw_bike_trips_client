import 'package:dw_bike_trips_client/queries.dart' as GraphQLQueries;
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CountTripsOperation extends ValuedOperation<int> {
  final GraphQLClient client;

  CountTripsOperation(this.client)
      : super('countTrips', 'Fetching trips count from server.');

  @override
  Future<ValuedOperationResult<int>> perform(OperationContext context) async {
    return doGraphQL<int>(
      client,
      GraphQLQueries.countTrips,
      (result) {
        print(result);
        return result['countTrips'];
      },
    );
  }
}
