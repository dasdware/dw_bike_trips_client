import 'dart:async';

import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/count_trips_operation.dart';
import 'package:dw_bike_trips_client/session/operations/timestamp.dart';
import 'package:dw_bike_trips_client/session/operations/trips_operation.dart';
import 'package:dw_bike_trips_client/session/trip.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AccumulatedTrip {
  final List<Trip> parts;
  final Timestamp timestamp;

  bool expanded = false;

  AccumulatedTrip(Trip trip)
      : timestamp = trip.timestamp.clone(),
        parts = List<Trip>.of([trip]);

  int get count => parts.length;
  double get distance =>
      parts.fold<double>(0.0, (prev, trip) => prev + trip.distance);
}

class TripsGroup {
  final int key;
  final List<AccumulatedTrip> trips;

  TripsGroup(this.key, AccumulatedTrip trip)
      : trips = List<AccumulatedTrip>.of([trip]);

  int get month => key % 100;
  int get year => key ~/ 100;

  int get count => trips.fold<int>(0, (prev, trip) => prev + trip.count);
  double get distance =>
      trips.fold<double>(0.0, (prev, trip) => prev + trip.distance);
}

int calculateAccumulationKey(Trip trip) {
  var t = trip.timestamp;
  return t.year * 100 * 100 + t.month * 100 + t.day;
}

int calculateGroupKey(AccumulatedTrip trip) {
  var t = trip.timestamp /*.toLocal()*/;
  return t.year * 100 + t.month;
}

class TripsHistory {
  final OperationContext context;
  final GraphQLClient client;

  List<AccumulatedTrip> _trips;
  final StreamController<List<AccumulatedTrip>> _streamController =
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

  final Map<int, TripsGroup> _groups = {};

  TripsHistory(this.context, this.client);

  void dispose() {
    _streamController.close();
  }

  TripsGroup groupByKey(int groupKey) {
    return _groups[groupKey];
  }

  _accumulate(List<Trip> trips) {
    List<AccumulatedTrip> accumulatedTrips = [];
    Map<int, AccumulatedTrip> accumulatedTripsByTimestamp = {};
    _groups.clear();

    for (var trip in trips) {
      var key = calculateAccumulationKey(trip);
      var accumulatedTrip = accumulatedTripsByTimestamp[key];

      if (accumulatedTrip == null) {
        accumulatedTrip = AccumulatedTrip(trip);
        accumulatedTripsByTimestamp[key] = accumulatedTrip;
        accumulatedTrips.add(accumulatedTrip);

        var groupKey = calculateGroupKey(accumulatedTrip);
        var group = _groups[groupKey];

        if (group == null) {
          group = TripsGroup(groupKey, accumulatedTrip);
          _groups[groupKey] = group;
        } else {
          group.trips.add(accumulatedTrip);
        }
      } else {
        accumulatedTrip.parts.add(trip);
      }
    }

    return accumulatedTrips;
  }

  _update() async {
    if (_count == null) {
      var countResult =
          await context.perform('history', CountTripsOperation(client));
      if (countResult.success) {
        _count = countResult.value.count;
      } else {
        _count = -1;
      }
    }

    var result = await context.perform(
      'history',
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
