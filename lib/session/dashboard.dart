import 'dart:async';

import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/dashboard_operation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DashboardDistances {
  final double today;
  final double thisWeek;
  final double thisMonth;
  final double thisYear;
  final double allTime;

  DashboardDistances(
      {this.today, this.thisWeek, this.thisMonth, this.thisYear, this.allTime});

  DashboardDistances.zero()
      : today = 0,
        thisWeek = 0,
        thisMonth = 0,
        thisYear = 0,
        allTime = 0;
}

class DashboardHistoryEntry {
  final int year;
  final int month;
  final int count;
  final double distance;

  DashboardHistoryEntry(this.year, this.month, this.count, this.distance);
}

class Dashboard {
  final DashboardDistances distances;
  final List<DashboardHistoryEntry> history;

  Dashboard({this.distances, this.history});

  Dashboard.zero()
      : distances = DashboardDistances.zero(),
        history = Iterable<int>.generate(12).map(
          (i) {
            var now = DateTime.now();
            return DashboardHistoryEntry(
                now.year, (now.month - i) % 12, 0, 0.0);
          },
        ).toList();
}

class DashboardController {
  final OperationContext context;
  final GraphQLClient client;

  Dashboard _dashboard;
  StreamController<Dashboard> _streamController =
      StreamController<Dashboard>.broadcast();

  get dashboard {
    if (_dashboard == null) {
      _dashboard = Dashboard.zero();
      _update();
    }
    return _dashboard;
  }

  get stream => _streamController.stream;

  DashboardController(this.context, this.client);

  void dispose() {
    _streamController.close();
  }

  _update() async {
    var result = await context.perform(
      DashboardOperation(client),
    );

    if (result.success) {
      _dashboard = result.value;
      _streamController.sink.add(_dashboard);
    }
  }

  invalidate() {
    _dashboard = null;
  }

  refresh() {
    invalidate();
    _update();
  }
}
