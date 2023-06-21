import 'package:dw_bike_trips_client/session/operations/timestamp.dart';
import 'package:dw_bike_trips_client/session/trip.dart';

const serverInfo = """
  query serverInfo {
    serverInfo {
      name
    }
  }
""";

const login = """
  query (\$email: String!, \$password: String!) {
    login(email: \$email, password: \$password) {
      token
    }
  }
""";

const me = """
  query {
    me {
      email
      firstname
      lastname
    }
  }
""";

String postTrips(List<Trip> trips) {
  return """
    mutation {
      postTrips(
        trips: [
          ${trips.map((trip) => "{timestamp: \"${trip.timestamp.toString()}\", distance: ${trip.distance}}").join("\n")}
        ]
      )
    }
  """;
}

String editTrips(List<Trip> trips) {
  return """
    mutation {
      editTrips(
        trips: [
          ${trips.map((trip) => "{id: ${trip.id}, timestamp: \"${trip.timestamp.toString()}\", distance: ${trip.distance}}").join("\n")}
        ]
      )
    }
  """;
}

const countTrips = """
  query countTrips {
    countTrips {
      count
      begin
      end
    }
  }
""";

const trips = """
  query (\$limit: Int!, \$offset: Int!) {
    trips(
        limit: { count: \$limit, offset: \$offset }
    ) {
      id
      timestamp
      distance
    }
  }
""";

String dashboard(Timestamp from, Timestamp to) {
  return """
    query completeDashboard {
      dashboard {
        distances {today yesterday thisWeek lastWeek thisMonth lastMonth thisYear lastYear allTime }
      }
      accumulateTrips(
        range: {from: "${from.toString()}", to: "${to.toString()}"},
        grouping: month
      ) {
        name
        begin
        end
        count
        distance
      }
    }
  """;
}
