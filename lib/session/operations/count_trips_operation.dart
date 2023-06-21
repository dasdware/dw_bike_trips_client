import 'package:dw_bike_trips_client/queries.dart' as queries;
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/client.dart';
import 'package:dw_bike_trips_client/session/operations/timestamp.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CountTripsResult {
  final int count;
  final Timestamp begin;
  final Timestamp end;

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
      queries.countTrips,
      (result) {
        return CountTripsResult(
            result['countTrips']['count'],
            Timestamp.parse(result['countTrips']['begin']),
            Timestamp.parse(result['countTrips']['end']));
      },
    );
  }
}
