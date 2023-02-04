import 'package:dw_bike_trips_client/pages/edit_trip_page.dart';
import 'package:dw_bike_trips_client/pages/dashboard/current_user_button.dart';
import 'package:dw_bike_trips_client/pages/dashboard/current_user_drawer.dart';
import 'package:dw_bike_trips_client/pages/dashboard/distances_section.dart';
import 'package:dw_bike_trips_client/pages/dashboard/history_section.dart';
import 'package:dw_bike_trips_client/pages/dashboard/upload_changes_button.dart';
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
  const DashboardPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      pageName: 'dashboard',
      extendBodyBehindAppBar: false,
      endDrawer: const CurrentUserDrawer(),
      appBar: themedAppBar(
        title: const ThemedHeading(
          caption: 'Dashboard',
          style: ThemedHeadingStyle.big,
        ),
        actions: [
          ThemedIconButton(
            icon: Icons.history,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()));
            },
          ),
          const UploadChangesButton(),
          const CurrentUserButton()
        ],
      ),
      body: StreamBuilder<Dashboard>(
        stream: context.watch<Session>().dashboardController.stream,
        initialData: context.watch<Session>().dashboardController.dashboard,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var history = snapshot.data.history;
            var isLarge = MediaQuery.of(context).size.width > 1024;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Flex(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  direction: isLarge ? Axis.horizontal : Axis.vertical,
                  children: [
                    Center(
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: isLarge ? 328 : 500),
                        child: DistancesSection(
                            distances: snapshot.data.distances),
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                      width: 32.0,
                    ),
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: DashboardHistorySection(history: history),
                      ),
                    ),
                    const SizedBox(
                      height: 64.0,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.fromLTRB(0, 200, 0, 100),
              child: Center(child: Logo()),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_circle_outline),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const EditTripPage()));
        },
      ),
    );
  }
}
