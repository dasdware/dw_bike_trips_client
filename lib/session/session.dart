import 'dart:async';

import 'package:dw_bike_trips_client/session/changes_queue.dart';
import 'package:dw_bike_trips_client/session/dashboard.dart';
import 'package:dw_bike_trips_client/session/hosts.dart';
import 'package:dw_bike_trips_client/session/login.dart';
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/login_operation.dart';
import 'package:dw_bike_trips_client/session/operations/server_info_operation.dart';
import 'package:dw_bike_trips_client/session/operations/timestamp.dart';
import 'package:dw_bike_trips_client/session/trips_history.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Session {
  final OperationContext operationContext = OperationContext();

  Login _currentLogin;
  Login get currentLogin => _currentLogin;
  final StreamController<Login> _currentLoginStreamController =
      StreamController<Login>.broadcast();
  Stream<Login> get currentLoginStream => _currentLoginStreamController.stream;

  final Hosts hosts;

  ChangesQueue _changesQueue;
  ChangesQueue get changesQueue => _changesQueue;

  TripsHistory _tripsHistory;
  TripsHistory get tripsHistory => _tripsHistory;

  DashboardController _dashboardController;
  DashboardController get dashboardController => _dashboardController;

  final DateFormat timestampFormat = DateFormat.yMd().add_jm();
  final DateFormat dateFormat = DateFormat.yMd();
  final DateFormat timeFormat = DateFormat.jm();
  final DateFormat weekdayFormat = DateFormat('E');

  final NumberFormat distanceFormat = NumberFormat("##0.00'km'");
  final NumberFormat distanceWithoutUnitFormat = NumberFormat("##0.00");

  Session(this.hosts) {
    _changesQueue = ChangesQueue(this);
  }

  dispose() {
    _currentLoginStreamController.close();
    hosts.dispose();
    _changesQueue.dispose();
    operationContext.close();
    _disposeTripsController();
    _disposeDashboardController();
  }

  _disposeTripsController() {
    if (_tripsHistory != null) {
      _tripsHistory.dispose();
      _tripsHistory = null;
    }
  }

  _disposeDashboardController() {
    if (_dashboardController != null) {
      _dashboardController.dispose();
      _dashboardController = null;
    }
  }

  Future<Host> serverInfo(String pageName, String url) async {
    var result =
        await operationContext.perform(pageName, ServerInfoOperation(url));
    return result.value;
  }

  Future<bool> login(String pageName, String email, String password) async {
    var loginResult = await operationContext.perform(
      pageName,
      LoginOperation(hosts.activeHost, email, password),
    );
    if (!loginResult.success) {
      return false;
    }

    _setCurrentLogin(loginResult.value);
    _tripsHistory = TripsHistory(operationContext, currentLogin.client);
    _dashboardController =
        DashboardController('dashboard', operationContext, currentLogin.client);
    return true;
  }

  Future<bool> logout() async {
    _setCurrentLogin(null);
    _disposeTripsController();
    _disposeDashboardController();
    return true;
  }

  _setCurrentLogin(Login login) {
    _currentLogin = login;
    _currentLoginStreamController.sink.add(_currentLogin);
  }

  formatTimestamp(Timestamp timestamp) {
    if (timestamp.hasTime) {
      return timestampFormat.format(timestamp.toDateTime());
    } else {
      return formatDate(timestamp);
    }
  }

  formatDate(Timestamp timestamp) {
    return dateFormat.format(timestamp.toDateTime());
  }

  formatTime(Timestamp timestamp) {
    if (timestamp.hasTime) {
      return timeFormat.format(timestamp.toDateTime());
    }
    return '-';
  }

  formatWeekday(Timestamp timestamp) {
    return weekdayFormat.format(timestamp.toDateTime());
  }

  formatDistance(double distance, {bool withUnit = true}) {
    if (withUnit) {
      return distanceFormat.format(distance);
    } else {
      return distanceWithoutUnitFormat.format(distance);
    }
  }
}

Provider<Session> createSessionProvider(Session session, Widget child) {
  return Provider<Session>(
    create: (_) => session,
    dispose: (_, session) => session.dispose(),
    child: child,
  );
}
