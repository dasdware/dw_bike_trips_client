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

var countTrips = Document().add(Query().addSelection(Field('countTrips')
    .addSelection(Field('count'))
    .addSelection(Field('begin'))
    .addSelection(Field('end'))));

class LimitConst extends Const {
  final Value count;
  final Value offset;

  LimitConst(this.count, this.offset);

  @override
  String bake() {
    return "{count:${count.bake()},offset:${offset.bake()}}";
  }
}

var trips = Document().add(Query(name: 'Trips', variables: [
  VariableDefinition('limit', VariableType("Int", nullable: false)),
  VariableDefinition('offset', VariableType("Int", nullable: false)),
]).addSelection(Field("trips")
    .addArgument(
        Argument('limit', LimitConst(Variable("limit"), Variable("offset"))))
    .addSelection(Field("id"))
    .addSelection(Field("timestamp"))
    .addSelection(Field("distance"))));

class RangeConst extends Const {
  final DateTime from;
  final DateTime to;

  RangeConst(this.from, this.to);

  @override
  String bake() {
    return "{from:\"${from.toIso8601String()}\",to:\"${to.toIso8601String()}\"}";
  }
}

class NameConst extends Const {
  final String name;

  NameConst(this.name);

  @override
  String bake() {
    return name;
  }
}

Document dashboard(DateTime from, DateTime to) {
  return Document().add(Query(name: 'CompleteDashboard')
      .addSelection(Field('dashboard').addSelection(Field('distances')
          .addSelection(Field('today'))
          .addSelection(Field('thisWeek'))
          .addSelection(Field('thisMonth'))
          .addSelection(Field('thisYear'))
          .addSelection(Field('allTime'))))
      .addSelection(Field('accumulateTrips')
          .addArgument(Argument('range', RangeConst(from, to)))
          .addArgument(Argument('grouping', NameConst('month')))
          .addSelection(Field('name'))
          .addSelection(Field('count'))
          .addSelection(Field('distance'))));
}
