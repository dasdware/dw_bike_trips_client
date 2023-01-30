import 'dart:async';

class Trip {
  final int id;
  final DateTime timestamp;
  final double distance;

  Trip({this.id = -1, this.timestamp, this.distance});
}

class ChangeableTrip {
  Trip _trip;

  ChangeableTrip(this._trip);

  Trip get trip => _trip;
  int get id => _trip.id;
  DateTime get timestamp => _trip.timestamp;
  double get distance => _trip.distance;

  final StreamController<Trip> _streamController =
      StreamController<Trip>.broadcast();
  Stream<Trip> get stream => _streamController.stream;

  void update(DateTime timestamp, double distance) {
    _trip = Trip(id: _trip.id, timestamp: timestamp, distance: distance);
    _streamController.sink.add(_trip);
  }
}
