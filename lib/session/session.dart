import 'dart:async';
import 'package:dw_bike_trips_client/session/hosts.dart';
import 'package:dw_bike_trips_client/session/login.dart';
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/login_operation.dart';
import 'package:dw_bike_trips_client/session/operations/server_info_operation.dart';
import 'package:dw_bike_trips_client/session/trips_queue.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Session {
  final OperationContext operationContext = OperationContext();

  Login _currentLogin;
  Login get currentLogin => _currentLogin;
  StreamController<Login> _currentLoginStreamController =
      StreamController<Login>.broadcast();
  Stream<Login> get currentLoginStream => _currentLoginStreamController.stream;

  final Hosts hosts;
  final TripsQueue tripsQueue = TripsQueue();

  final DateFormat timestampFormat = DateFormat.yMd().add_jm();
  final DateFormat dateFormat = DateFormat.yMd();
  final DateFormat timeFormat = DateFormat.jm();

  Session(this.hosts);

  dispose() {
    _currentLoginStreamController.close();
    hosts.dispose();
    tripsQueue.dispose();
    operationContext.close();
  }

  Future<Host> serverInfo(String url) async {
    var result = await this.operationContext.perform(ServerInfoOperation(url));
    return result.value;
  }

  Future<bool> login(String email, String password) async {
    var loginResult = await operationContext.perform(
      LoginOperation(hosts.activeHost, email, password),
    );
    if (!loginResult.success) {
      return false;
    }

    _setCurrentLogin(loginResult.value);
    return true;
  }

  Future<bool> logout() async {
    _setCurrentLogin(null);
    return true;
  }

  _setCurrentLogin(Login login) {
    _currentLogin = login;
    _currentLoginStreamController.sink.add(_currentLogin);
  }

  formatTimestamp(DateTime timestamp) {
    return timestampFormat.format(timestamp);
  }

  formatDistance(double distance) {
    return distance.toString() + 'km';
  }
}

Provider<Session> createSessionProvider(Session session, Widget child) {
  return Provider<Session>(
    create: (_) => session,
    dispose: (_, session) => session.dispose(),
    child: child,
  );
}
