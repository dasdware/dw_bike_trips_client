import 'package:dw_bike_trips_client/session/status.dart';
import 'package:graphql_builder/graphql_builder.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

typedef Future<dynamic> DoGraphQLFn(
    {Document request,
    GraphQLClient client,
    Map<String, dynamic> variables,
    Function onError,
    bool mutation});

typedef void SetStatusFn(SessionStatus status);

class SessionPart {
  DoGraphQLFn _doGraphQL;
  SetStatusFn _setStatus;

  SessionPart(SetStatusFn setStatus, DoGraphQLFn doGraphQL)
      : _setStatus = setStatus,
        _doGraphQL = doGraphQL;

  Future<dynamic> doGraphQL(
      {Document request,
      GraphQLClient client,
      Map<String, dynamic> variables,
      Function onError,
      bool mutation = false}) {
    return _doGraphQL(
        request: request,
        client: client,
        variables: variables,
        onError: onError,
        mutation: mutation);
  }

  void setStatus(SessionStatus status) {
    _setStatus(status);
  }
}
