import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/widgets/page.dart';
import 'package:dw_bike_trips_client/widgets/themed/heading.dart';
import 'package:dw_bike_trips_client/widgets/themed/icon.dart';
import 'package:dw_bike_trips_client/widgets/themed/panel.dart';
import 'package:dw_bike_trips_client/widgets/themed/scaffold.dart';
import 'package:dw_bike_trips_client/widgets/themed/spacing.dart';
import 'package:dw_bike_trips_client/widgets/themed/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadChangesPage extends StatelessWidget {
  _postPressed(BuildContext context) async {
    Session session = context.read<Session>();
    if (await session.tripsQueue.post(
        ApplicationPage.of(context).pageName,
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
      pageName: 'uploadChanges',
      appBar: themedAppBar(
        title: ThemedHeading(
          caption: "Upload changes",
          style: ThemedHeadingStyle.Big,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: session.tripsQueue.trips
              .map(
                (trip) => ThemedPanel(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      ThemedIcon(
                        icon: Icons.add_circle_outline,
                      ),
                      ThemedSpacing(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ThemedHeading(
                            caption: session.formatDistance(trip.distance),
                          ),
                          ThemedText(
                            text: session.formatTimestamp(trip.timestamp),
                            textSize: ThemedTextSize.Small,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          child: Icon(Icons.cloud_upload_outlined),
          onPressed: () async {
            _postPressed(context);
          },
        ),
      ),
    );
  }
}
