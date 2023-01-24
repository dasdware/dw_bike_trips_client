import 'package:dw_bike_trips_client/json/storage.dart' as storage;
import 'package:dw_bike_trips_client/pages/dashboard_page.dart';
import 'package:dw_bike_trips_client/pages/login_page.dart';
import 'package:dw_bike_trips_client/session/login.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(Session(await storage.loadHosts())));
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Login>(
      stream: Provider.of<Session>(context).currentLoginStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return const DashboardPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  final Session _session;

  const MyApp(Session session, {Key key}) : _session = session, super(key: key);

  @override
  Widget build(BuildContext context) {
    return createSessionProvider(
      _session,
      MaterialApp(
        title: 'dasd.ware BikeTrips',
        theme: AppThemeData.themeData,
        home: const MainScreen(),
      ),
    );
  }
}
