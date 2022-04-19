import 'package:dw_bike_trips_client/queries.dart' as GraphQLQueries;
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
    HttpLink httpLink = HttpLink(uri: url);
    GraphQLClient client =
        GraphQLClient(cache: InMemoryCache(), link: httpLink);

    return doGraphQL(client, GraphQLQueries.serverInfo,
        (result) => Host(result['serverInfo']['name'], url));
  }
}
