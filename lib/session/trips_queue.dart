import 'dart:async';
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/post_trips_operation.dart';
import 'package:dw_bike_trips_client/session/trips_history.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Trip {
  final int id;
  final DateTime timestamp;
  final double distance;

  Trip({this.id = -1, this.timestamp, this.distance});
}

class TripsQueue {
  DateTime _lastSubmission;
  List<Trip> _trips = [];
  StreamController<List<Trip>> _tripsStreamController =
      StreamController<List<Trip>>.broadcast();

  DateTime get lastSubmision => _lastSubmission;
  List<Trip> get trips => _trips;
  Stream<List<Trip>> get tripsStream => _tripsStreamController.stream;

  TripsQueue() {
    _changed();
    _lastSubmission = DateTime.now();
    _lastSubmission = DateTime(_lastSubmission.year, _lastSubmission.month,
        _lastSubmission.day, 0, 0, 0, 0, 0);
  }

  dispose() {
    _tripsStreamController.close();
  }

  _changed() {
    _tripsStreamController.sink.add(_trips);
  }

  _clear() {
    _trips.clear();
    _changed();
  }

  enqueue(Trip trip) {
    _trips.add(trip);
    _lastSubmission = trip.timestamp;
    _changed();
  }

  Future<bool> post(OperationContext context, GraphQLClient client,
      TripsHistory tripsController) async {
    if (_trips.isEmpty) {
      return true;
    }

    var postTripsResult = await context
        .perform(PostTripsOperation(client, tripsController, trips));
    if (postTripsResult.success && postTripsResult.value) {
      _clear();
      return true;
    }

    return false;
  }
}
