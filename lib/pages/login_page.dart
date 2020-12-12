import 'package:dw_bike_trips_client/session.dart';
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
  final TextEditingController _hostFilter = TextEditingController();
  final TextEditingController _emailFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _loginPressed(BuildContext context) async {
    context
        .read<Session>()
        .login(_hostFilter.text, _emailFilter.text, _passwordFilter.text);
  }

  _buildTextFields() {
    return Container(
      child: Column(
        children: <Widget>[
          ErrorList(result: context.watch<Session>().lastOperationResult),
          SizedBox(
            height: 8.0,
          ),
          TextField(
            controller: _hostFilter,
            decoration: InputDecoration(labelText: 'Host'),
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
      children: <Widget>[
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
    _hostFilter.value = TextEditingValue(text: session.host);
    _emailFilter.value = TextEditingValue(text: session.email);
    _passwordFilter.value = TextEditingValue(text: session.password);

    return ThemedScaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Logo(),
                _buildTextFields(),
                SizedBox(
                  height: 16.0,
                ),
                _buildButtons(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
