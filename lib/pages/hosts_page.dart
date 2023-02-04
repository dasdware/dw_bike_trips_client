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
  const HostsPage({Key key}) : super(key: key);

  _addHostPressed(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AddHostPage()));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Host>>(
        stream: context.watch<Session>().hosts.entriesStream,
        initialData: context.watch<Session>().hosts.entries,
        builder: (context, snapshot) {
          final haveHosts = snapshot.hasData && snapshot.data.isNotEmpty;
          return ThemedScaffold(
            pageName: 'hosts',
            appBar: themedAppBar(
              title: const ThemedHeading(
                caption: 'Manage hosts',
                style: ThemedHeadingStyle.big,
              ),
            ),
            floatingActionButton: (haveHosts)
                ? FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _addHostPressed(context),
                  )
                : null,
            body: (haveHosts)
                ? Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: ListView(
                        children: snapshot.data
                            .map((host) => HostListTile(host: host))
                            .toList(),
                      ),
                    ),
                  )
                : const NoHostsPanel(),
          );
        });
  }
}
