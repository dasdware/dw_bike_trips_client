import 'dart:ui';

import 'package:dw_bike_trips_client/pages/add_trip_page.dart';
import 'package:dw_bike_trips_client/pages/post_trips.dart';
import 'package:dw_bike_trips_client/pages/history_page.dart';
import 'package:dw_bike_trips_client/session/dashboard.dart';
import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/operations/dashboard_operation.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/session/trips_queue.dart';
import 'package:dw_bike_trips_client/session/user.dart';
import 'package:dw_bike_trips_client/theme.dart' as AppTheme;
import 'package:dw_bike_trips_client/widgets/calendar_icon.dart';
import 'package:dw_bike_trips_client/widgets/logo.dart';
import 'package:dw_bike_trips_client/widgets/themed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      extendBodyBehindAppBar: false,
      endDrawer: CurrentUserDrawer(),
      appBar: themedAppBar(
        title: Text(
          'Dashboard'.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.9,
            fontSize: 20.0,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            color: AppTheme.secondaryColor_2,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HistoryPage()));
            },
          ),
          UploadTripsButton(),
          EndDrawerThemedAvatar()
        ],
      ),
      body: FutureBuilder<ValuedOperationResult<Dashboard>>(
        future: context.watch<Session>().operationContext.perform(
            DashboardOperation(context.watch<Session>().currentLogin.client)),
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var distances = snapshot.data.value.distances;
            var calendarIconStyle = CalendarIconStyle(
              width: 34,
              height: 34,
              color: Colors.white.withOpacity(0.6),
            );
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'distances (km)'.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.8,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DashboardDistancePanel(
                        icon: DayCalendarIcon(
                          day: DateTime.now().day,
                          style: calendarIconStyle,
                        ),
                        caption: 'today',
                        distance: distances.today,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      DashboardDistancePanel(
                        icon: WeekCalendarIcon(
                          style: calendarIconStyle,
                        ),
                        caption: 'this week',
                        distance: distances.thisWeek,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DashboardDistancePanel(
                        icon: MonthCalendarIcon(
                          style: calendarIconStyle,
                        ),
                        caption: 'this month',
                        distance: distances.thisMonth,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      DashboardDistancePanel(
                        icon: YearCalendarIcon(
                          year: DateTime.now().year,
                          style: calendarIconStyle,
                        ),
                        caption: 'this year',
                        distance: distances.thisYear,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DashboardDistancePanel(
                        icon: AllTimeCalendarIcon(
                          style: calendarIconStyle,
                        ),
                        caption: 'all time',
                        distance: distances.allTime,
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 200, 0, 100),
              child: Center(child: Logo()),
            );
          }
        },
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

class DashboardDistancePanel extends StatelessWidget {
  const DashboardDistancePanel({
    Key key,
    @required this.icon,
    @required this.caption,
    @required this.distance,
  }) : super(key: key);

  final Widget icon;
  final String caption;
  final double distance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Colors.white.withOpacity(0.9),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 12.0,
          ),
          icon,
          SizedBox(
            width: 8.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                caption.toUpperCase(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                  fontSize: 12.0,
                ),
              ),
              SizedBox(
                height: 2.0,
              ),
              Text(
                context
                    .watch<Session>()
                    .formatDistance(distance, withUnit: false),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 23.0,
                ),
              )
            ],
          ),
        ],
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
        stream: context.watch<Session>().tripsQueue.tripsStream,
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
    User currentUser = context.watch<Session>().currentLogin.user;
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
                    text: context.watch<Session>().timestampFormat.format(
                        context.watch<Session>().currentLogin.loggedInUntil),
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
