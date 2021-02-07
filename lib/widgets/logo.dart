import 'package:dw_bike_trips_client/theme.dart' as AppTheme;
import 'package:dw_bike_trips_client/widgets/themed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SvgPicture.asset('assets/logo.svg',
              color: AppTheme.secondaryColors[2],
              semanticsLabel: 'dasd.ware BikeTrips Logo'),
          SizedBox(
            height: 8.0,
          ),
          ThemedText(text: 'dasd.ware BikeTrips'),
        ],
      ),
    );
  }
}
