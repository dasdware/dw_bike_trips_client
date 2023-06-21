import 'dart:async';

import 'package:dw_bike_trips_client/session/changes/add_trip.dart';
import 'package:dw_bike_trips_client/session/changes/edit_trip.dart';
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/timestamp.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/session/trip.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class Change {
  List<OperationError> lastErrors;

  Widget buildIcon(BuildContext context);
  Widget buildWidget(BuildContext context);

  ValuedOperation<dynamic> createOperation(GraphQLClient client);

  bool canEdit() {
    return false;
  }

  void edit(BuildContext context) {
    throw UnsupportedError('This change does not support editing.');
  }
}

class ChangesQueue {
  Timestamp _lastSubmission;
  Timestamp get lastSubmision => _lastSubmission;

  final _changes = <Change>[];
  List<Change> get changes => _changes;

  final Session _session;

  final StreamController<List<Change>> _changesStreamController =
      StreamController<List<Change>>.broadcast();
  Stream<List<Change>> get changesStream => _changesStreamController.stream;

  final StreamController<Change> _successStreamController =
      StreamController<Change>.broadcast();
  Stream<Change> get _successStream => _successStreamController.stream;

  ChangesQueue(this._session) {
    _changed();
    _lastSubmission = Timestamp.now();
  }

  dispose() {
    _changesStreamController.close();
  }

  _changed() {
    _changesStreamController.sink.add(_changes);
  }

  undo(Change change) {
    _changes.remove(change);
    _changed();
  }

  enqueue(Change change) {
    _changes.add(change);
    _changed();
  }

  enqueueAddTrip(Trip trip) {
    enqueue(AddTripChange(
        trip, _session.tripsHistory, _session.dashboardController));
    _lastSubmission = trip.timestamp;
  }

  final _updateTrips = <int, EditTripChange>{};

  EditTripChange updateTrip(Trip trip) {
    if (_updateTrips.containsKey(trip.id)) {
      return _updateTrips[trip.id];
    }

    var result = EditTripChange(
        trip, _session.tripsHistory, _session.dashboardController);
    _updateTrips[trip.id] = result;

    StreamSubscription<Trip> subscription;
    subscription = result.trip.stream.listen(
      (event) {
        enqueue(result);
        subscription.cancel();
      },
    );

    StreamSubscription<Change> successSubscription;
    successSubscription = _successStream.listen(
      (event) {
        if (event == result) {
          _updateTrips.remove(result.trip.id);
          successSubscription.cancel();
        }
      },
    );

    return result;
  }

  performChanges(String pageName, GraphQLClient client) async {
    var success = true;

    var index = 0;
    while (index < changes.length) {
      var operation = changes[index].createOperation(client);
      var result = await _session.operationContext.perform(pageName, operation);

      if (result.success) {
        var successChange = changes.removeAt(index);
        _successStreamController.sink.add(successChange);
      } else {
        changes[index].lastErrors = result.errors;
        success = false;
        index++;
      }
    }

    _changed();
    return success;
  }
}
