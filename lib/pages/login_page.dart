import 'package:dw_bike_trips_client/pages/hosts_page.dart';
import 'package:dw_bike_trips_client/pages/login/login_form.dart';
import 'package:dw_bike_trips_client/pages/login/no_hosts_info.dart';
import 'package:dw_bike_trips_client/session/hosts.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/theme.dart' as AppTheme;
import 'package:dw_bike_trips_client/widgets/error_list.dart';
import 'package:dw_bike_trips_client/widgets/logo.dart';
import 'package:dw_bike_trips_client/widgets/themed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Session session = Provider.of<Session>(context);

    _manageHostsPressed(BuildContext context) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HostsPage()));
    }

    return ThemedScaffold(
      appBar: themedAppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.cloud_outlined,
              color: AppTheme.secondaryColors[2],
            ),
            tooltip: 'Manage Hosts',
            onPressed: () => _manageHostsPressed(context),
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
                Logo(),
                ErrorList(operationName: 'login'),
                StreamBuilder<List<Host>>(
                  stream: session.hosts.entriesStream,
                  initialData: session.hosts.entries,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data.isEmpty) {
                      return NoHostsInfo();
                    } else {
                      return LoginForm();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
