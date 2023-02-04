import 'package:dw_bike_trips_client/pages/add_host_page.dart';
import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:dw_bike_trips_client/widgets/themed/button.dart';
import 'package:dw_bike_trips_client/widgets/themed/icon.dart';
import 'package:dw_bike_trips_client/widgets/themed/panel.dart';
import 'package:dw_bike_trips_client/widgets/themed/spacing.dart';
import 'package:flutter/material.dart';

class NoHostsPanel extends StatelessWidget {
  const NoHostsPanel({
    Key key,
  }) : super(key: key);

  _registerHostPressed(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AddHostPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ThemedPanel(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Opacity(
                  opacity: 0.6,
                  child: ThemedIcon(
                    icon: Icons.cloud_off,
                    size: 64,
                  ),
                ),
                const ThemedSpacing(size: ThemedSpacingSize.large),
                const Text(
                  'You have not yet registered any hosts. Use the button below to add a new one.',
                  style: TextStyle(color: AppThemeData.textColor, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const ThemedSpacing(size: ThemedSpacingSize.large),
                ThemedButton(
                  icon: Icons.cloud_outlined,
                  overlayIcon: Icons.add,
                  caption: 'Register Host',
                  onPressed: () => _registerHostPressed(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
