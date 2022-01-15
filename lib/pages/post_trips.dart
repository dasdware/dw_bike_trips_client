import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/widgets/themed/scaffold.dart';
import 'package:dw_bike_trips_client/widgets/themed/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostTripsPage extends StatelessWidget {
  _postPressed(BuildContext context) async {
    Session session = context.read<Session>();
    if (await session.tripsQueue.post(
        session.operationContext,
        session.currentLogin.client,
        session.tripsHistory,
        session.dashboardController)) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Session session = context.watch<Session>();
    return ThemedScaffold(
      appBar: themedAppBar(
        title: Text('Trips enqueued for posting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: session.tripsQueue.trips
              .map(
                (trip) => ListTile(
                  title: ThemedText(
                    text: session.formatDistance(trip.distance),
                  ),
                  subtitle: ThemedText(
                    text: session.formatTimestamp(trip.timestamp),
                    textSize: ThemedTextSize.Small,
                  ),
                ),
              )
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cloud_upload_outlined),
        onPressed: () async {
          _postPressed(context);
        },
      ),
    );
  }
}
