import 'dart:async';

import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/count_trips_operation.dart';
import 'package:dw_bike_trips_client/session/operations/trips_operation.dart';
import 'package:dw_bike_trips_client/session/trips_queue.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AccumulatedTrip {
  final List<Trip> parts;
  final DateTime timestamp;

  bool expanded = false;

  AccumulatedTrip(Trip trip)
      : timestamp = DateTime(trip.timestamp.toLocal().year,
            trip.timestamp.toLocal().month, trip.timestamp.toLocal().day),
        parts = List<Trip>.of([trip]);

  get count => parts.length;
  get distance => parts.fold<double>(0.0, (prev, trip) => prev + trip.distance);
}

class TripsHistory {
  final OperationContext context;
  final GraphQLClient client;

  List<AccumulatedTrip> _trips;
  StreamController<List<AccumulatedTrip>> _streamController =
      StreamController<List<AccumulatedTrip>>.broadcast();

  get trips {
    if (_trips == null) {
      _trips = [];
      _update();
    }
    return _trips;
  }

  get stream => _streamController.stream;

  int _count;
  get count => _count;

  TripsHistory(this.context, this.client);

  void dispose() {
    _streamController.close();
  }

  _accumulate(List<Trip> trips) {
    List<AccumulatedTrip> accumulatedTrips = [];
    Map<int, AccumulatedTrip> accumulatedTripsByTimestamp = {};

    for (var trip in trips) {
      var timestamp = trip.timestamp.year * 100 * 100 +
          trip.timestamp.month * 100 +
          trip.timestamp.day;
      var accumulatedTrip = accumulatedTripsByTimestamp[timestamp];

      if (accumulatedTrip == null) {
        accumulatedTrip = AccumulatedTrip(trip);
        accumulatedTripsByTimestamp[timestamp] = accumulatedTrip;
        accumulatedTrips.add(accumulatedTrip);
      } else {
        accumulatedTrip.parts.add(trip);
      }
    }

    return accumulatedTrips;
  }

  _update() async {
    if (_count == null) {
      var countResult = await context.perform(CountTripsOperation(client));
      if (countResult.success) {
        _count = countResult.value;
      } else {
        _count = -1;
      }
    }

    var result = await context.perform(
      TripsOperation(
        client,
        limit: _count,
        offset: 0,
      ),
    );

    if (result.success) {
      _trips = _accumulate(result.value);
      _streamController.sink.add(_trips);
    }
  }

  invalidate() {
    _count = null;
    _trips = null;
  }

  refresh() {
    invalidate();
    _update();
  }

  toggleTripExpansion(AccumulatedTrip trip) {
    trip.expanded = !trip.expanded;
    _streamController.sink.add(_trips);
  }
}
