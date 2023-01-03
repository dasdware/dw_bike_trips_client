import 'package:dw_bike_trips_client/queries.dart' as queries;
import 'package:dw_bike_trips_client/session/hosts.dart';
import 'package:dw_bike_trips_client/session/login.dart';
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/client.dart';
import 'package:dw_bike_trips_client/session/operations/me_operation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginOperation extends ValuedOperation<Login> {
  final Host host;
  final String email;
  final String password;

  LoginOperation(this.host, this.email, this.password)
      : super('login', 'Logging in to host ${host.name}.');

  @override
  Future<ValuedOperationResult<Login>> perform(
      String pageName, OperationContext context) async {
    HttpLink httpLink = HttpLink(host.url);
    GraphQLClient client =
        GraphQLClient(cache: GraphQLCache(), link: httpLink);

    var fetchTokenResult = await doGraphQL<String>(
      client,
      queries.login,
      (result) => result['login']['token'],
      variables: {
        'email': email,
        'password': password,
      },
    );
    if (!fetchTokenResult.success) {
      return fetchTokenResult.asWithErrors<Login>();
    }

    var authenticatedClient = GraphQLClient(
      cache: GraphQLCache(),
      link: AuthLink(getToken: () async => 'Bearer ${fetchTokenResult.value}')
          .concat(httpLink),
    );

    var meResult =
        await context.perform(pageName, MeOperation(authenticatedClient));
    if (!meResult.success) {
      return meResult.asWithErrors<Login>();
    }

    return ValuedOperationResult<Login>.withSuccess(Login(
      authenticatedClient,
      meResult.value,
      JwtDecoder.getExpirationDate(fetchTokenResult.value),
    ));
  }
}
