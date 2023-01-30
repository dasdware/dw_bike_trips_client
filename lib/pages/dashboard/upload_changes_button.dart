import 'package:dw_bike_trips_client/pages/upload_changes_page.dart';
import 'package:dw_bike_trips_client/session/changes_queue.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/widgets/themed/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadChangesButton extends StatelessWidget {
  const UploadChangesButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Change>>(
      initialData: context.watch<Session>().changesQueue.changes,
      stream: context.watch<Session>().changesQueue.changesStream,
      builder: (context, snapshot) {
        var overlayText = (snapshot.hasData && snapshot.data.isNotEmpty)
            ? snapshot.data.length.toString()
            : null;

        return ThemedIconButton(
          icon: Icons.cloud_upload_outlined,
          overlayText: overlayText,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const UploadChangesPage()));
          },
        );
      },
    );
  }
}
