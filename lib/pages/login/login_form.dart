import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/widgets/themed/button.dart';
import 'package:dw_bike_trips_client/widgets/themed/heading.dart';
import 'package:dw_bike_trips_client/widgets/themed/panel.dart';
import 'package:dw_bike_trips_client/widgets/themed/spacing.dart';
import 'package:dw_bike_trips_client/widgets/themed/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();

  void _loginPressed(BuildContext context) async {
    context.read<Session>().login(_emailFilter.text, _passwordFilter.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 8.0),
      child: ThemedPanel(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ThemedHeading(
              caption: context.watch<Session>().hosts.activeHost.name,
              style: ThemedHeadingStyle.Medium,
            ),
            ThemedSpacing(size: ThemedSpacingSize.Large),
            ThemedTextField(
              controller: _emailFilter,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            ThemedSpacing(),
            ThemedTextField(
              controller: _passwordFilter,
              labelText: 'Password',
              obscureText: true,
              onEditingComplete: () => _loginPressed(context),
            ),
            ThemedSpacing(size: ThemedSpacingSize.Large),
            ThemedButton(
              icon: Icons.login,
              caption: 'Login',
              onPressed: () => _loginPressed(context),
            ),
          ],
        ),
      ),
    );
  }
}
