import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:dw_bike_trips_client/widgets/themed/button.dart';
import 'package:dw_bike_trips_client/widgets/themed/heading.dart';
import 'package:dw_bike_trips_client/widgets/themed/text.dart';
import 'package:flutter/material.dart';

void confirm(BuildContext context, {
    String title = 'Confirmation', 
    String message, 
    IconData okIcon,
    String okText = "OK", 
    String cancelText = "Cancel",
    Function onConfirmed,
  }
) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ThemedHeading(
          caption: title,
        ),
        backgroundColor: AppThemeData.mainDarkerColor,
        content: ThemedText(
          textAlign: TextAlign.start,
          text: message,
        ),
        actions: [
          ThemedButton(
            caption: okText,
            icon: okIcon,
            onPressed: () {
              onConfirmed();
              Navigator.of(context).pop();
            },
          ),
          ThemedButton(
            caption: cancelText,
            flat: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
}