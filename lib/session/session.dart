import 'dart:async';
import 'package:dw_bike_trips_client/queries.dart' as GraphQLQueries;
import 'package:dw_bike_trips_client/session/hosts.dart';
import 'package:dw_bike_trips_client/session/status.dart' show SessionStatus;
import 'package:dw_bike_trips_client/session/trips_queue.dart';
import 'package:dw_bike_trips_client/widgets/error_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_builder/graphql_builder.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

class User {
  final String email;
  final String firstname;
  final String lastname;

  User(this.email, this.firstname, this.lastname);
}

class Session {
  StreamController<SessionStatus> _sessionStatusStreamController =
      StreamController<SessionStatus>.broadcast();
  SessionStatus _status = SessionStatus.loggedOut;

  SessionStatus get status => _status;
  Stream<SessionStatus> get sessionStatusStream =>
      _sessionStatusStreamController.stream;

  bool get isLoggedIn => (status == SessionStatus.loggedIn);
  bool get isProcessing =>
      (status == SessionStatus.loggingIn) ||
      (status == SessionStatus.loggingOut);

  OperationResult _lastOperationResult = OperationResult.withSuccess();
  OperationResult get lastOperationResult => _lastOperationResult;

  Hosts _hosts;
  Hosts get hosts => _hosts;

  DateTime _loggedInUntil;
  DateTime get loggedInUntil => _loggedInUntil;

  Duration _timeout = Duration(seconds: 5);
  GraphQLClient _client;

  String _email = '';
  String _password = '';
  String get email => _email;
  String get password => _password;

  User _currentUser;
  User get currentUser => _currentUser;

  GraphQLClient get client => _client;

  final DateFormat timestampFormat = DateFormat.yMd().add_jm();
  final DateFormat dateFormat = DateFormat.yMd();
  final DateFormat timeFormat = DateFormat.jm();

  StreamController<OperationResult> _operationResultStreamController =
      StreamController<OperationResult>.broadcast();

  TripsQueue _tripsQueue;
  TripsQueue get tripsQueue => _tripsQueue;

  Session() {
    _tripsQueue = TripsQueue(_setStatus, _doGraphQL);
    _hosts = Hosts();
    _setStatus(SessionStatus.loggedOut);
  }

  dispose() {
    _sessionStatusStreamController.close();
    _operationResultStreamController.close();
    _hosts.dispose();
    _tripsQueue.dispose();
  }

  _setStatus(SessionStatus status) {
    _status = status;
    _sessionStatusStreamController.sink.add(status);
  }

  Future<dynamic> _doGraphQL(
      {Document request,
      GraphQLClient client,
      Map<String, dynamic> variables,
      Function onError,
      bool mutation = false}) async {
    if (client == null) {
      client = _client;
    }

    try {
      var result = (mutation)
          ? await client
              .mutate(
                MutationOptions(
                  documentNode: gql(request.bake()),
                  variables: variables,
                ),
              )
              .timeout(_timeout)
          : await client
              .query(
                QueryOptions(
                  documentNode: gql(request.bake()),
                  variables: variables,
                ),
              )
              .timeout(_timeout);

      if (result.hasException) {
        if (onError != null) {
          onError(result.exception);
        }
      } else {
        return result.data;
      }
    } on TimeoutException catch (_) {
      onError(OperationException(graphqlErrors: [
        GraphQLError(message: 'Timeout while trying to connect to server')
      ]));
    }

    return null;
  }

  Future<Host> serverInfo(String url) async {
    HttpLink httpLink = HttpLink(uri: url);
    GraphQLClient client =
        GraphQLClient(cache: InMemoryCache(), link: httpLink);

    var result = await _doGraphQL(
        request: GraphQLQueries.serverInfo,
        client: client,
        onError: (OperationException exception) {
          _lastOperationResult = OperationResult.withErrors(
            exception.graphqlErrors
                .map((e) => OperationError(e.message))
                .toList(),
          );
        });

    if (result != null) {
      _lastOperationResult = OperationResult.withSuccess();
      return Host(result['serverInfo']['name'], url);
    }
    return null;
  }

  login(String email, String password) async {
    _email = email;
    _password = password;
    _setStatus(SessionStatus.loggingIn);

    HttpLink httpLink = HttpLink(uri: hosts.activeHost.url);
    GraphQLClient client =
        GraphQLClient(cache: InMemoryCache(), link: httpLink);

    var result = await _doGraphQL(
        request: GraphQLQueries.login,
        variables: {'email': email, 'password': password},
        client: client,
        onError: (OperationException exception) {
          _lastOperationResult = OperationResult.withErrors(
            exception.graphqlErrors
                .map((e) => OperationError(e.message))
                .toList(),
          );
          _setStatus(SessionStatus.loggedOut);
        });

    if (result != null) {
      _lastOperationResult = OperationResult.withSuccess();
      _password = '';

      String token = result['login']['token'];
      _client = GraphQLClient(
          cache: InMemoryCache(),
          link:
              AuthLink(getToken: () async => 'Bearer $token').concat(httpLink));
      _loggedInUntil = JwtDecoder.getExpirationDate(token);
      _currentUser = await me();
      _setStatus(SessionStatus.loggedIn);
    }
  }

  logout() async {
    _setStatus(SessionStatus.loggingOut);
    _lastOperationResult = OperationResult.withSuccess();
    _currentUser = null;
    _client = null;
    _loggedInUntil = null;
    _setStatus(SessionStatus.loggedOut);
  }

  Future<User> me() async {
    var result = await _doGraphQL(request: GraphQLQueries.me);
    return User(result['me']['email'], result['me']['firstname'],
        result['me']['lastname']);
  }

  enqueueTrip(DateTime timestamp, double distance) {
    _tripsQueue.enqueue(Trip(timestamp: timestamp, distance: distance));
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
