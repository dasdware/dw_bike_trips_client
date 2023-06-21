import 'package:dw_bike_trips_client/queries.dart' as queries;
import 'package:dw_bike_trips_client/session/dashboard.dart';
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/client.dart';
import 'package:dw_bike_trips_client/session/operations/timestamp.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DashboardOperation extends ValuedOperation<Dashboard> {
  final GraphQLClient client;

  DashboardOperation(this.client)
      : super('dashboard', 'Fetching data for dashboard.');

  @override
  Future<ValuedOperationResult<Dashboard>> perform(
      String pageName, OperationContext context) {
    var to = Timestamp.now();
    var from = Timestamp(year: to.year - 1, month: to.month, day: to.day);

    return doGraphQL(client, queries.dashboard(from, to), (result) {
      var distances = DashboardDistances(
        today: result['dashboard']['distances']['today'].toDouble(),
        yesterday: result['dashboard']['distances']['yesterday'].toDouble(),
        thisWeek: result['dashboard']['distances']['thisWeek'].toDouble(),
        lastWeek: result['dashboard']['distances']['lastWeek'].toDouble(),
        thisMonth: result['dashboard']['distances']['thisMonth'].toDouble(),
        lastMonth: result['dashboard']['distances']['lastMonth'].toDouble(),
        thisYear: result['dashboard']['distances']['thisYear'].toDouble(),
        lastYear: result['dashboard']['distances']['lastYear'].toDouble(),
        allTime: result['dashboard']['distances']['allTime'].toDouble(),
      );

      var history = <DashboardHistoryEntry>[];
      var expectedYear = to.year;
      var expectedMonth = to.month;

      var index = 0;
      var entryList = result['accumulateTrips'];
      for (var month = 0; month < 12; ++month) {
        dynamic entry;
        var entryYear = -1;
        var entryMonth = -1;

        if (entryList != null && entryList.length > index) {
          entry = entryList[index];
          var numEntryName = int.parse(entry['name']);
          entryYear = numEntryName ~/ 100;
          entryMonth = numEntryName % 100;
        }

        if (entryYear == expectedYear && entryMonth == expectedMonth) {
          history.add(DashboardHistoryEntry(
              entryYear, entryMonth, entry['count'], entry['distance'] + 0.0));
          ++index;
        } else {
          history
              .add(DashboardHistoryEntry(expectedYear, expectedMonth, 0, 0.0));
        }

        --expectedMonth;
        if (expectedMonth == 0) {
          --expectedYear;
          expectedMonth = 12;
        }
      }

      return Dashboard(distances: distances, history: history);
    });
  }
}
