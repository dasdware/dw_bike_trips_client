import 'package:dw_bike_trips_client/queries.dart' as queries;
import 'package:dw_bike_trips_client/session/hosts.dart';
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ServerInfoOperation extends ValuedOperation<Host> {
  final String url;

  ServerInfoOperation(this.url)
      : super('serverInfo', 'Fetching server information for host "$url".');

  @override
  Future<ValuedOperationResult<Host>> perform(
      String pageName, OperationContext context) {
    HttpLink httpLink = HttpLink(url);
    GraphQLClient client =
        GraphQLClient(cache: GraphQLCache(), link: httpLink);

    return doGraphQL(client, queries.serverInfo,
        (result) => Host(result['serverInfo']['name'], url));
  }
}
