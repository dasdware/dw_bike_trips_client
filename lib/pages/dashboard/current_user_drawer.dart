import 'dart:ui';

import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/session/user.dart';
import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:dw_bike_trips_client/widgets/themed/avatar.dart';
import 'package:dw_bike_trips_client/widgets/themed/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentUserDrawer extends StatelessWidget {
  const CurrentUserDrawer({Key key}) : super(key: key);

  void _logoutPressed(BuildContext context) async {
    context.read<Session>().logout();
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = context.watch<Session>().currentLogin.user;
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: SizedBox(
        width: 230,
        child: Drawer(
          child: Stack(
            children: <Widget>[
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(10),
                  ),
                ),
              ),
              ListView(
                padding: EdgeInsets.zero,
                // itemExtent: 40,
                children: <Widget>[
                  SizedBox(
                    height: 150,
                    child: DrawerHeader(
                      margin: const EdgeInsets.fromLTRB(40, 0, 20, 0),
                      child: ThemedAvatar(user: currentUser),
                    ),
                  ),
                  InfoListTile(
                    icon: Icons.account_circle,
                    text: '${currentUser.firstname} ${currentUser.lastname}',
                  ),
                  InfoListTile(
                    icon: Icons.email,
                    text: currentUser.email,
                  ),
                  InfoListTile(
                    icon: Icons.timer,
                    text: context.watch<Session>().timestampFormat.format(
                        context.watch<Session>().currentLogin.loggedInUntil),
                  ),
                  // SizedBox.expand(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
                    child: ThemedButton(
                      icon: Icons.logout,
                      caption: 'Logout',
                      onPressed: () => _logoutPressed(context),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InfoListTile extends StatelessWidget {
  const InfoListTile({
    Key key,
    @required this.icon,
    @required this.text,
  }) : super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListTile(
        leading: Icon(
          icon,
          color: AppThemeData.headingColor,
        ),
        title: Text(
          text,
          style: const TextStyle(color: AppThemeData.headingBigColor),
        ),
      ),
    );
  }
}
