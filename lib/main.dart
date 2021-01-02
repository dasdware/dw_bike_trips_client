import 'package:dw_bike_trips_client/pages/login_page.dart';
import 'package:dw_bike_trips_client/pages/main_page.dart';
import 'package:dw_bike_trips_client/session/login.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/theme.dart' as AppTheme;
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(MyApp(Session()));
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Login>(
      stream: Provider.of<Session>(context).currentLoginStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return MainPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  final Session _session;

  MyApp(Session session) : _session = session;

  @override
  Widget build(BuildContext context) {
    return createSessionProvider(
      _session,
      MaterialApp(
        title: 'dasd.ware BikeTrips',
        theme: AppTheme.themeData,
        home: MainScreen(),
      ),
    );
  }
}
