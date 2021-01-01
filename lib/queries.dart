import 'package:dw_bike_trips_client/session/trips_queue.dart';
import 'package:graphql_builder/graphql_builder.dart';

var serverInfo = Document()
    .add(Query().addSelection(Field('serverInfo').addSelection(Field('name'))));

var login = Document().add(Query(name: 'Login', variables: [
  VariableDefinition('email', VariableType("String", nullable: false)),
  VariableDefinition('password', VariableType("String", nullable: false)),
]).addSelection(Field("login")
    .addArgument(Argument('email', Variable('email')))
    .addArgument(Argument('password', Variable('password')))
    .addSelection(Field("token"))));

var me = Document().add(Query().addSelection(Field('me')
    .addSelection(Field('email'))
    .addSelection(Field('firstname'))
    .addSelection(Field('lastname'))));

class TripConst extends Const {
  final Trip trip;

  TripConst(this.trip);

  @override
  String bake() {
    return "{timestamp:\"${trip.timestamp.toIso8601String()}\",distance:${trip.distance}}";
  }
}

Document postTrips(List<Trip> trips) {
  return Document().add(
    Mutation().addSelection(
      Field('postTrips').addArgument(
        Argument(
          'trips',
          ArrayConst(
            trips.map((trip) => TripConst(trip)).toList(),
          ),
        ),
      ),
    ),
  );
}
