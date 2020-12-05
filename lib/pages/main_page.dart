import 'dart:ui';

import 'package:dw_bike_trips_client/pages/add_trip_page.dart';
import 'package:dw_bike_trips_client/pages/post_trips.dart';
import 'package:dw_bike_trips_client/session.dart';
import 'package:dw_bike_trips_client/theme.dart' as AppTheme;
import 'package:dw_bike_trips_client/widgets/logo.dart';
import 'package:dw_bike_trips_client/widgets/themed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<ScaffoldState> _innerScaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      innerKey: _innerScaffoldKey,
      endDrawer: CurrentUserDrawer(),
      appBar: themedAppBar(
        actions: [
          UploadTripsButton(),
          EndDrawerThemedAvatar(
            scaffoldKey: _innerScaffoldKey,
          )
        ],
      ),
      body:
          /* Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: CurrentUserDrawer(),
        body:*/
          Padding(
        padding: const EdgeInsets.fromLTRB(0, 100, 0, 100),
        child: Center(child: Logo()),
      ),
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_circle_outline),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTripPage()));
        },
      ),
    );
  }
}

class UploadTripsButton extends StatelessWidget {
  const UploadTripsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Trip>>(
        stream: context.watch<Session>().tripsToSubmitStream,
        builder: (context, snapshot) {
          return Center(
            child: Stack(
              children: [
                if (snapshot.hasData && snapshot.data.isNotEmpty)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      child: CircleAvatar(
                        backgroundColor: AppTheme.secondaryColors[3],
                        child: Text(
                          snapshot.data.length.toString(),
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                IconButton(
                  icon: Icon(
                    Icons.cloud_upload_outlined,
                    color: AppTheme.secondaryColors[2],
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostTripsPage()));
                  },
                )
              ],
            ),
          );
        });
  }
}

class CurrentUserDrawer extends StatelessWidget {
  const CurrentUserDrawer({Key key}) : super(key: key);

  void _logoutPressed(BuildContext context) async {
    context.read<Session>().logout();
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = context.watch<Session>().currentUser;
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: Container(
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
                      margin: EdgeInsets.fromLTRB(40, 0, 20, 0),
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
                    text: context
                        .watch<Session>()
                        .timestampFormat
                        .format(context.watch<Session>().loggedInUntil),
                  ),
                  // SizedBox.expand(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
                    child: RaisedButton.icon(
                      icon: Icon(Icons.logout),
                      color: AppTheme.secondaryColors[2],
                      label: Text('Logout'),
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
          color: AppTheme.secondaryColor_2,
        ),
        title: Text(
          text,
          style: TextStyle(color: AppTheme.secondaryColor_2),
        ),
      ),
    );
  }
}

class EndDrawerThemedAvatar extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  const EndDrawerThemedAvatar(
      {Key key, @required GlobalKey<ScaffoldState> scaffoldKey})
      : _scaffoldKey = scaffoldKey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemedAvatar(
      user: context.watch<Session>().currentUser,
      onPressed: () {
        if (_scaffoldKey.currentState.isEndDrawerOpen) {
          Navigator.pop(context);
        } else {
          _scaffoldKey.currentState.openEndDrawer();
        }
      },
    );
  }
}
