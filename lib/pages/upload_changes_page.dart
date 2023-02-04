import 'package:dw_bike_trips_client/session/changes_queue.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/widgets/page.dart';
import 'package:dw_bike_trips_client/widgets/themed/alert.dart';
import 'package:dw_bike_trips_client/widgets/themed/heading.dart';
import 'package:dw_bike_trips_client/widgets/themed/icon_button.dart';
import 'package:dw_bike_trips_client/widgets/themed/panel.dart';
import 'package:dw_bike_trips_client/widgets/themed/scaffold.dart';
import 'package:dw_bike_trips_client/widgets/themed/spacing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadChangesPage extends StatelessWidget {
  const UploadChangesPage({Key key}) : super(key: key);

  _postPressed(BuildContext context) async {
    Session session = context.read<Session>();
    if (await session.changesQueue.performChanges(
      ApplicationPage.of(context).pageName,
      session.currentLogin.client,
    )) {
      Navigator.of(context).pop();
    }
  }

  _undoPressed(BuildContext context, Change change) {
    confirm(
      context,
      title: 'Revert change',
      message:
          'Are you sure you want to revert the selected change? This operation cannot be undone.',
      okIcon: Icons.undo,
      okText: 'Revert',
      onConfirmed: () {
        Session session = context.read<Session>();
        session.changesQueue.undo(change);
      },
    );
  }

  _editPressed(BuildContext context, Change change) {
    change.edit(context);
  }

  @override
  Widget build(BuildContext context) {
    Session session = context.watch<Session>();
    return ThemedScaffold(
      pageName: 'uploadChanges',
      appBar: themedAppBar(
        title: const ThemedHeading(
          caption: "Upload changes",
          style: ThemedHeadingStyle.big,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<Change>>(
            initialData: session.changesQueue.changes,
            stream: session.changesQueue.changesStream,
            builder: (context, snapshot) {
              return Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: ListView(
                    children: snapshot.data
                        .map(
                          (change) => ThemedPanel(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            child: Row(
                              children: [
                                change.buildIcon(context),
                                const ThemedSpacing(),
                                Expanded(
                                  child: change.buildWidget(context),
                                ),
                                if (change.canEdit())
                                  ThemedIconButton(
                                    icon: Icons.edit,
                                    tooltip: "Edit change",
                                    onPressed: () =>
                                        _editPressed(context, change),
                                  ),
                                ThemedIconButton(
                                  icon: Icons.undo,
                                  tooltip: "Revert change",
                                  onPressed: () =>
                                      _undoPressed(context, change),
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          child: const Icon(Icons.cloud_upload_outlined),
          onPressed: () async {
            _postPressed(context);
          },
        ),
      ),
    );
  }
}
