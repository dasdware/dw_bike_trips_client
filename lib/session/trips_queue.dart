import 'dart:async';

import 'package:dw_bike_trips_client/session/part.dart';
import 'package:dw_bike_trips_client/session/status.dart';
import 'package:dw_bike_trips_client/queries.dart' as GraphQLQueries;

class Trip {
  final int id;
  final DateTime timestamp;
  final double distance;

  Trip({this.id = -1, this.timestamp, this.distance});
}

class TripsQueue extends SessionPart {
  DateTime _lastSubmission;
  List<Trip> _trips = [];
  StreamController<List<Trip>> _tripsStreamController =
      StreamController<List<Trip>>.broadcast();

  DateTime get lastSubmision => _lastSubmission;
  List<Trip> get trips => _trips;
  Stream<List<Trip>> get tripsStream => _tripsStreamController.stream;

  TripsQueue(SetStatusFn setStatus, DoGraphQLFn doGraphQL)
      : super(setStatus, doGraphQL) {
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

  post() async {
    if (_trips.isEmpty) {
      return true;
    }

    setStatus(SessionStatus.postingTrips);

    var result = await doGraphQL(
      request: GraphQLQueries.postTrips(_trips),
      mutation: true,
    );

    bool success = (result['postTrips'] == _trips.length);
    if (success) {
      _clear();
    }

    setStatus(SessionStatus.loggedIn);

    return success;
  }
}
