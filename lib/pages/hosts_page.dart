import 'package:dw_bike_trips_client/pages/add_host_page.dart';
import 'package:dw_bike_trips_client/pages/hosts/host_list_tile.dart';
import 'package:dw_bike_trips_client/pages/hosts/no_hosts_panel.dart';
import 'package:dw_bike_trips_client/session/hosts.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/widgets/themed/heading.dart';
import 'package:dw_bike_trips_client/widgets/themed/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostsPage extends StatelessWidget {
  _addHostPressed(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddHostPage()));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Host>>(
        stream: context.watch<Session>().hosts.entriesStream,
        initialData: context.watch<Session>().hosts.entries,
        builder: (context, snapshot) {
          final haveHosts = snapshot.hasData && snapshot.data.isNotEmpty;
          return ThemedScaffold(
            appBar: themedAppBar(
              title: ThemedHeading(
                caption: 'Manage hosts',
                style: ThemedHeadingStyle.Big,
              ),
            ),
            floatingActionButton: (haveHosts)
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _addHostPressed(context),
                  )
                : null,
            body: (haveHosts)
                ? ListView(
                    children: snapshot.data
                        .map((host) => HostListTile(host: host))
                        .toList(),
                  )
                : NoHostsPanel(),
          );
        });
  }
}
