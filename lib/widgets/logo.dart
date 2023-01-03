import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:dw_bike_trips_client/widgets/themed/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Logo extends StatelessWidget {
  const Logo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SvgPicture.asset('assets/logo.svg',
              color: AppThemeData.highlightColor,
              semanticsLabel: 'dasd.ware BikeTrips Logo'),
          const SizedBox(
            height: 8.0,
          ),
          const ThemedText(
            text: 'dasd.ware BikeTrips',
            textColor: ThemedTextColor.highlight,
          ),
        ],
      ),
    );
  }
}
