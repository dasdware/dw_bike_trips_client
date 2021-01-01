import 'package:dw_bike_trips_client/pages/add_host_page.dart';
import 'package:dw_bike_trips_client/session/hosts.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/theme.dart' as AppTheme;
import 'package:dw_bike_trips_client/widgets/themed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostsPage extends StatelessWidget {
  void _setActiveHost(BuildContext context, Host host) {
    context.read<Session>().hosts.setActiveHost(host);
  }

  _addHostPressed(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddHostPage()));
  }

  _removeHostPressed(BuildContext context, Host host) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: ThemedText(
            text: 'Remove host',
          ),
          backgroundColor: AppTheme.primaryColor_3,
          content: ThemedText(
            text:
                'Are you sure you want to remove the selected host? This operation cannot be undone.',
            fontSize: 16,
          ),
          actions: [
            FlatButton(
              onPressed: () {
                context.read<Session>().hosts.removeHost(host);
                Navigator.of(context).pop();
              },
              // color: AppTheme.secondaryColors[2],
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: AppTheme.secondaryColor_2,
                  ),
                  ThemedText(
                    text: 'Remove',
                    fontSize: 14,
                  )
                ],
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: ThemedText(
                text: 'Cancel',
                fontSize: 14,
              ),
            )
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      appBar: themedAppBar(
        title: Text('Manage hosts'),
      ),
      body: StreamBuilder<List<Host>>(
        stream: context.watch<Session>().hosts.entriesStream,
        initialData: context.watch<Session>().hosts.entries,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            return ListView(
              children: snapshot.data
                  .map(
                    (host) => Container(
                      color: host.active
                          ? AppTheme.secondaryColors[2].withAlpha(60)
                          : Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                        child: Row(
                          children: [
                            ThemedIconButton(
                              icon: host.active
                                  ? Icons.radio_button_on
                                  : Icons.radio_button_off,
                              onPressed: () => _setActiveHost(context, host),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Wrap(
                                direction: Axis.vertical,
                                children: [
                                  Row(
                                    children: [
                                      ThemedIcon(icon: Icons.cloud_outlined),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      ThemedText(
                                        text: host.name,
                                      ),
                                    ],
                                  ),
                                  ThemedText(
                                    text: host.url,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.0),
                            ThemedIconButton(
                              icon: Icons.delete,
                              onPressed: () =>
                                  _removeHostPressed(context, host),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'You have not yet registered any hosts. Use the button below to add a new one.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
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
