import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/widgets/themed/avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentUserButton extends StatelessWidget {
  const CurrentUserButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemedAvatar(
      user: context.watch<Session>().currentLogin.user,
      onPressed: () {
        if (Scaffold.of(context).isEndDrawerOpen) {
          Navigator.pop(context);
        } else {
          Scaffold.of(context).openEndDrawer();
        }
      },
    );
  }
}
