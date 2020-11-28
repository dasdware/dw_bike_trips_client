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
    return Scaffold(
      appBar: AppBar(
        actions: [
          UploadTripsButton(),
          EndDrawerThemedAvatar(
            scaffoldKey: _innerScaffoldKey,
          )
        ],
      ),
      body: Scaffold(
        key: _innerScaffoldKey,
        endDrawer: CurrentUserDrawer(),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 100),
          child: Center(child: Logo()),
        ),
      ),
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
                        backgroundColor: AppTheme.primaryColors[3],
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
                    color: AppTheme.primaryColors[4],
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
    return Container(
      width: 200,
      child: Drawer(
        child: Container(
          color: AppTheme.primaryColors[3],
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ThemedText(
                      text: currentUser.firstname + ' ' + currentUser.lastname,
                      textAlign: TextAlign.end,
                    ),
                    ThemedText(
                      text: currentUser.email,
                      fontSize: 14,
                      textAlign: TextAlign.end,
                    ),
                    ThemedText(
                      text: context
                          .watch<Session>()
                          .timestampFormat
                          .format(context.watch<Session>().loggedInUntil),
                      fontSize: 14,
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
              Container(color: AppTheme.secondaryColors[2], height: 4),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RaisedButton(
                      color: AppTheme.secondaryColors[2],
                      child: new Text('Logout'),
                      onPressed: () => _logoutPressed(context),
                    ),
                  ],
                ),
              )
            ],
          ),
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
