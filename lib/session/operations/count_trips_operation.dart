import 'package:dw_bike_trips_client/queries.dart' as GraphQLQueries;
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CountTripsResult {
  final int count;
  final DateTime begin;
  final DateTime end;

  CountTripsResult(this.count, this.begin, this.end);
}

class CountTripsOperation extends ValuedOperation<CountTripsResult> {
  final GraphQLClient client;

  CountTripsOperation(this.client)
      : super('countTrips', 'Fetching trips count from server.');

  @override
  Future<ValuedOperationResult<CountTripsResult>> perform(
      String pageName, OperationContext context) async {
    return doGraphQL<CountTripsResult>(
      client,
      GraphQLQueries.countTrips,
      (result) {
        return CountTripsResult(
            result['countTrips']['count'],
            DateTime.parse(result['countTrips']['begin']),
            DateTime.parse(result['countTrips']['end']));
      },
    );
  }
}
