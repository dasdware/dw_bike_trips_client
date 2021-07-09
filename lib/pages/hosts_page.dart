import 'package:dw_bike_trips_client/pages/add_host_page.dart';
import 'package:dw_bike_trips_client/pages/hosts/host_list_tile.dart';
import 'package:dw_bike_trips_client/session/hosts.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/widgets/themed.dart';
import 'package:dw_bike_trips_client/widgets/themed/heading.dart';
import 'package:dw_bike_trips_client/widgets/themed/icon.dart' as NewThemedIcon;
import 'package:dw_bike_trips_client/widgets/themed/panel.dart';
import 'package:dw_bike_trips_client/widgets/themed/spacing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostsPage extends StatelessWidget {
  _addHostPressed(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddHostPage()));
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      appBar: themedAppBar(
        title: ThemedHeading(
          caption: 'Manage hosts',
          style: ThemedHeadingStyle.Big,
        ),
      ),
      body: StreamBuilder<List<Host>>(
        stream: context.watch<Session>().hosts.entriesStream,
        initialData: context.watch<Session>().hosts.entries,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            return ListView(
              children: snapshot.data
                  .map((host) => HostListTile(host: host))
                  .toList(),
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ThemedPanel(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Opacity(
                        opacity: 0.6,
                        child: NewThemedIcon.ThemedIcon(
                          icon: Icons.cloud_off,
                          size: 64,
                        ),
                      ),
                      ThemedSpacing(),
                      Text(
                        'You have not yet registered any hosts. Use the button below to add a new one.',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addHostPressed(context),
      ),
    );
  }
}
