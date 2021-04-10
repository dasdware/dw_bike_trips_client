import 'package:dw_bike_trips_client/pages/add_host_page.dart';
import 'package:dw_bike_trips_client/widgets/themed/button.dart';
import 'package:dw_bike_trips_client/widgets/themed/panel.dart';
import 'package:dw_bike_trips_client/widgets/themed/spacing.dart';
import 'package:dw_bike_trips_client/widgets/themed/text.dart';
import 'package:flutter/material.dart';

class NoHostsInfo extends StatelessWidget {
  _registerHostPressed(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddHostPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 8.0),
      child: ThemedPanel(
        padding: EdgeInsets.all(16.0),
        child: Column(children: [
          ThemedText(
            text:
                'You have not yet registered any hosts. Go to the hosts management page or use the button below to register one.',
          ),
          ThemedSpacing(),
          ThemedButton(
            icon: Icons.cloud,
            caption: 'Register Host',
            onPressed: () => _registerHostPressed(context),
          ),
        ]),
      ),
    );
  }
}
