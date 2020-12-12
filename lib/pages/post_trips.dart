import 'package:dw_bike_trips_client/pages/progress_page.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/session/status.dart';
import 'package:dw_bike_trips_client/widgets/themed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostTripsPage extends StatelessWidget {
  _postPressed(BuildContext context) async {
    if (await context.read<Session>().tripsQueue.post()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Session session = context.watch<Session>();
    return StreamBuilder<SessionStatus>(
        stream: session.sessionStatusStream,
        builder: (context, snapshot) {
          if (snapshot.data == SessionStatus.postingTrips) {
            return ProgressPage(text: 'Sending trips to server');
          }

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
                          fontSize: ThemedText.FONT_SIZE_SUBTITLE,
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
        });
  }
}
