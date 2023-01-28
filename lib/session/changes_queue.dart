
import 'dart:async';

import 'package:dw_bike_trips_client/session/changes/add_trip.dart';
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/session/trip.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class Change {

  List<OperationError> lastErrors;

  Widget buildIcon(BuildContext context);
  Widget buildWidget(BuildContext context);

  ValuedOperation<dynamic> createOperation(GraphQLClient client);
}

class ChangesQueue {
  DateTime _lastSubmission;
  DateTime get lastSubmision => _lastSubmission;

  final _changes = <Change>[];
  List<Change> get changes => _changes;

  final Session _session;

  final StreamController<List<Change>> _changesStreamController =
      StreamController<List<Change>>.broadcast();
  Stream<List<Change>> get changesStream => _changesStreamController.stream;

  ChangesQueue(this._session) {
    _changed();
    _lastSubmission = DateTime.now();
    _lastSubmission = DateTime(_lastSubmission.year, _lastSubmission.month,
        _lastSubmission.day, 0, 0, 0, 0, 0);
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
    enqueue(AddTripChange(trip, _session.tripsHistory, _session.dashboardController));
    _lastSubmission = trip.timestamp;
  }

  performChanges(String pageName, GraphQLClient client) async {
    var success = true;

    var index = 0;
    while (index < changes.length) {
      var operation = changes[index].createOperation(client);
      var result = await _session.operationContext.perform(pageName, operation);

      if (result.success) {
        changes.removeAt(index);
      } else {
        changes[index].lastErrors = result.errors;
        success = false;
        index++;
      }
    }

    return success;
  }
}