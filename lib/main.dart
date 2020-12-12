import 'package:dw_bike_trips_client/pages/login_page.dart';
import 'package:dw_bike_trips_client/pages/main_page.dart';
import 'package:dw_bike_trips_client/pages/progress_page.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/session/status.dart';
import 'package:dw_bike_trips_client/theme.dart' as AppTheme;
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(MyApp(new Session()));
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SessionStatus>(
        stream: Provider.of<Session>(context).sessionStatusStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == SessionStatus.loggedOut) {
              return LoginPage();
            } else if (snapshot.data == SessionStatus.loggingIn) {
              return ProgressPage(text: 'Logging in...');
            } else if (snapshot.data == SessionStatus.loggingOut) {
              return ProgressPage(text: 'Logging out...');
            } else /*if (snapshot.data == SessionStatus.loggedIn)*/ {
              return MainPage();
            }
            /* else {
              return Text(snapshot.data.toString());
            }*/
          }
          return LoginPage();
        });
  }
}

class MyApp extends StatelessWidget {
  final Session _session;

  MyApp(Session session) : _session = session;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return createSessionProvider(
        _session,
        MaterialApp(
          title: 'dasd.ware BikeTrips',
          theme: AppTheme.themeData,
          home: MainScreen(),
        ));
  }
}
