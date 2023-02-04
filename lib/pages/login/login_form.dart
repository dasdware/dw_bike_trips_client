import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/widgets/page.dart';
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
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();

  void _loginPressed(BuildContext context) async {
    context.read<Session>().login(ApplicationPage.of(context).pageName,
        _emailFilter.text, _passwordFilter.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 8.0),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: ThemedPanel(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ThemedHeading(
                caption: context.watch<Session>().hosts.activeHost.name,
                style: ThemedHeadingStyle.medium,
              ),
              const ThemedSpacing(size: ThemedSpacingSize.large),
              ThemedTextField(
                controller: _emailFilter,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const ThemedSpacing(),
              ThemedTextField(
                controller: _passwordFilter,
                labelText: 'Password',
                obscureText: true,
                onEditingComplete: () => _loginPressed(context),
              ),
              const ThemedSpacing(size: ThemedSpacingSize.large),
              ThemedButton(
                icon: Icons.login,
                caption: 'Login',
                onPressed: () => _loginPressed(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
