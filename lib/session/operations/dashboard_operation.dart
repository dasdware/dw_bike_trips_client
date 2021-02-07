import 'package:dw_bike_trips_client/queries.dart' as GraphQLQueries;
import 'package:dw_bike_trips_client/session/dashboard.dart';
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DashboardOperation extends ValuedOperation<Dashboard> {
  final GraphQLClient client;

  DashboardOperation(this.client)
      : super('dashboard', 'Fetching data for dashboard.');

  @override
  Future<ValuedOperationResult<Dashboard>> perform(OperationContext context) {
    return doGraphQL(client, GraphQLQueries.dashboard, (result) {
      return Dashboard(
        distances: DashboardDistances(
          today: result['dashboard']['distances']['today'].toDouble(),
          thisWeek: result['dashboard']['distances']['thisWeek'].toDouble(),
          thisMonth: result['dashboard']['distances']['thisMonth'].toDouble(),
          thisYear: result['dashboard']['distances']['thisYear'].toDouble(),
          allTime: result['dashboard']['distances']['allTime'].toDouble(),
        ),
      );
    });
  }
}
