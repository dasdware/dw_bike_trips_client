import 'package:dw_bike_trips_client/pages/upload_changes.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/session/trips_queue.dart';
import 'package:dw_bike_trips_client/widgets/themed/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadTripsButton extends StatelessWidget {
  const UploadTripsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Trip>>(
      initialData: context.watch<Session>().tripsQueue.trips,
      stream: context.watch<Session>().tripsQueue.tripsStream,
      builder: (context, snapshot) {
        var overlayText = (snapshot.hasData && snapshot.data.isNotEmpty)
            ? snapshot.data.length.toString()
            : null;

        return ThemedIconButton(
          icon: Icons.cloud_upload_outlined,
          overlayText: overlayText,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UploadChangesPage()));
          },
        );
      },
    );
  }
}
