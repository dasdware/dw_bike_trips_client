import 'package:dw_bike_trips_client/session/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Login {
  final GraphQLClient client;
  final User user;
  final DateTime loggedInUntil;

  Login(this.client, this.user, this.loggedInUntil);
}
