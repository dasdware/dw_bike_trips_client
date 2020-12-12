import 'dart:async';
import 'package:dw_bike_trips_client/queries.dart' as GraphQLQueries;
import 'package:dw_bike_trips_client/widgets/error_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_builder/graphql_builder.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

enum SessionStatus { loggedOut, loggingIn, loggedIn, postingTrips, loggingOut }

class User {
  final String email;
  final String firstname;
  final String lastname;

  User(this.email, this.firstname, this.lastname);
}

class Trip {
  final int id;
  final DateTime timestamp;
  final double distance;

  Trip({this.id = -1, this.timestamp, this.distance});
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

  DateTime _loggedInUntil;
  DateTime get loggedInUntil => _loggedInUntil;

  Duration _timeout = Duration(seconds: 5);
  GraphQLClient _client;

  String _host = FlutterConfig.get('DEFAULT_HOST');
  String _email = '';
  String _password = '';
  String get host => _host;
  String get email => _email;
  String get password => _password;

  User _currentUser;
  User get currentUser => _currentUser;

  GraphQLClient get client => _client;

  DateTime get lastTripSubmisionTimestamp => _lastTripSubmisionTimestamp;
  List<Trip> get tripsToSubmit => _tripsToSubmit;
  Stream<List<Trip>> get tripsToSubmitStream =>
      _tripsToSubmitStreamController.stream;

  DateTime _lastTripSubmisionTimestamp;
  List<Trip> _tripsToSubmit = [];

  final DateFormat timestampFormat = DateFormat.yMd().add_jm();
  final DateFormat dateFormat = DateFormat.yMd();
  final DateFormat timeFormat = DateFormat.jm();

  StreamController<OperationResult> _operationResultStreamController =
      StreamController<OperationResult>.broadcast();
  StreamController<List<Trip>> _tripsToSubmitStreamController =
      StreamController<List<Trip>>.broadcast();

  Session() {
    _setStatus(SessionStatus.loggedOut);
    _tripsToSubmitStreamController.sink.add(_tripsToSubmit);
    _lastTripSubmisionTimestamp = DateTime.now();
    _lastTripSubmisionTimestamp = DateTime(
        _lastTripSubmisionTimestamp.year,
        _lastTripSubmisionTimestamp.month,
        _lastTripSubmisionTimestamp.day,
        0,
        0,
        0,
        0,
        0);
  }

  dispose() {
    _sessionStatusStreamController.close();
    _operationResultStreamController.close();
    _tripsToSubmitStreamController.close();
  }

  _setStatus(SessionStatus status) {
    _status = status;
    _sessionStatusStreamController.sink.add(status);
  }

  _doGraphQL(
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

  login(String host, String email, String password) async {
    _host = host;
    _email = email;
    _password = password;
    _setStatus(SessionStatus.loggingIn);

    HttpLink httpLink = HttpLink(uri: host);
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
    Trip trip = Trip(timestamp: timestamp, distance: distance);
    _tripsToSubmit.add(trip);
    _lastTripSubmisionTimestamp = timestamp;
    _tripsToSubmitStreamController.sink.add(_tripsToSubmit);
  }

  postEnqueuedTrips() async {
    if (tripsToSubmit.isEmpty) {
      return true;
    }

    _setStatus(SessionStatus.postingTrips);

    var result = await _doGraphQL(
      request: GraphQLQueries.postTrips(tripsToSubmit),
      mutation: true,
    );

    bool success = (result['postTrips'] == tripsToSubmit.length);
    if (success) {
      _tripsToSubmit.clear();
      _tripsToSubmitStreamController.sink.add(_tripsToSubmit);
    }

    _setStatus(SessionStatus.loggedIn);

    return success;
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
