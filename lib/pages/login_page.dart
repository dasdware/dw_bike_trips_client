import 'package:dw_bike_trips_client/pages/hosts/no_hosts_panel.dart';
import 'package:dw_bike_trips_client/pages/hosts_page.dart';
import 'package:dw_bike_trips_client/pages/login/login_form.dart';
import 'package:dw_bike_trips_client/session/hosts.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/widgets/logo.dart';
import 'package:dw_bike_trips_client/widgets/themed/icon_button.dart';
import 'package:dw_bike_trips_client/widgets/themed/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Session session = Provider.of<Session>(context);

    manageHostsPressed(BuildContext context) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HostsPage()));
    }

    return StreamBuilder<List<Host>>(
      stream: session.hosts.entriesStream,
      initialData: session.hosts.entries,
      builder: (context, snapshot) {
        final haveHosts = snapshot.hasData && snapshot.data.isNotEmpty;
        return ThemedScaffold(
          pageName: 'login',
          appBar: themedAppBar(
            actions: [
              if (haveHosts)
                ThemedIconButton(
                  icon: Icons.cloud_outlined,
                  tooltip: 'Manage Hosts',
                  onPressed: () => manageHostsPressed(context),
                ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Logo(),
                    if (!haveHosts) const NoHostsPanel() else const LoginForm()
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
