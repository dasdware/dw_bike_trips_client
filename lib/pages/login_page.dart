import 'package:dw_bike_trips_client/pages/add_host_page.dart';
import 'package:dw_bike_trips_client/pages/hosts_page.dart';
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
                      return _NoHostsInfo();
                    } else {
                      return _LoginForm();
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

class _NoHostsInfo extends StatelessWidget {
  _registerHostPressed(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddHostPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 8.0),
        child: Text(
          'You have not yet registered any hosts. Go to the hosts management page or use the button below to register one.',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(
        height: 4.0,
      ),
      RaisedButton.icon(
        icon: Icon(Icons.cloud),
        color: AppTheme.secondaryColors[2],
        label: Text('Register Host'),
        onPressed: () => _registerHostPressed(context),
      ),
    ]);
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({
    Key key,
  }) : super(key: key);

  @override
  __LoginFormState createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  final TextEditingController _emailFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();

  void _loginPressed(BuildContext context) async {
    context.read<Session>().login(_emailFilter.text, _passwordFilter.text);
  }

  _buildTextFields() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 8.0,
          ),
          SizedBox(
            height: 8.0,
          ),
          TextField(
            controller: _emailFilter,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          SizedBox(
            height: 8.0,
          ),
          TextField(
            controller: _passwordFilter,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          )
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return new Column(
      children: [
        RaisedButton.icon(
          icon: Icon(Icons.login),
          color: AppTheme.secondaryColors[2],
          label: Text('Login'),
          onPressed: () => _loginPressed(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Session session = Provider.of<Session>(context);
    _emailFilter.value = TextEditingValue(text: session.email);
    _passwordFilter.value = TextEditingValue(text: session.password);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
          child: Text(
            context.watch<Session>().hosts.activeHost.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        _buildTextFields(),
        SizedBox(
          height: 16.0,
        ),
        _buildButtons(context),
      ],
    );
  }
}
