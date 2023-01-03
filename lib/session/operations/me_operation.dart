import 'package:dw_bike_trips_client/queries.dart' as queries;
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/client.dart';
import 'package:dw_bike_trips_client/session/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MeOperation extends ValuedOperation<User> {
  final GraphQLClient client;

  MeOperation(this.client)
      : super('me', 'Fetching information about current user.');

  @override
  Future<ValuedOperationResult<User>> perform(
      String pageName, OperationContext context) {
    return doGraphQL(
        client,
        queries.me,
        (result) => User(result['me']['email'], result['me']['firstname'],
            result['me']['lastname']));
  }
}
