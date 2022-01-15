import 'package:dw_bike_trips_client/pages/add_trip_page.dart';
import 'package:dw_bike_trips_client/pages/dashboard/current_user_button.dart';
import 'package:dw_bike_trips_client/pages/dashboard/current_user_drawer.dart';
import 'package:dw_bike_trips_client/pages/dashboard/distances_section.dart';
import 'package:dw_bike_trips_client/pages/dashboard/history_section.dart';
import 'package:dw_bike_trips_client/pages/dashboard/upload_trips_button.dart';
import 'package:dw_bike_trips_client/pages/history_page.dart';
import 'package:dw_bike_trips_client/session/dashboard.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/widgets/logo.dart';
import 'package:dw_bike_trips_client/widgets/themed/heading.dart';
import 'package:dw_bike_trips_client/widgets/themed/icon_button.dart';
import 'package:dw_bike_trips_client/widgets/themed/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      extendBodyBehindAppBar: false,
      endDrawer: CurrentUserDrawer(),
      appBar: themedAppBar(
        title: ThemedHeading(
          caption: 'Dashboard',
          style: ThemedHeadingStyle.Big,
        ),
        actions: [
          ThemedIconButton(
            icon: Icons.history,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HistoryPage()));
            },
          ),
          UploadTripsButton(),
          CurrentUserButton()
        ],
      ),
      body: StreamBuilder<Dashboard>(
        stream: context.watch<Session>().dashboardController.stream,
        initialData: context.watch<Session>().dashboardController.dashboard,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var history = snapshot.data.history;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DistancesSection(distances: snapshot.data.distances),
                    SizedBox(
                      height: 16.0,
                    ),
                    DashboardHistorySection(history: history),
                    SizedBox(
                      height: 64.0,
                    ),
                  ],
                ),
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
