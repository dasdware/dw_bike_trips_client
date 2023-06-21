import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:dw_bike_trips_client/widgets/themed/text.dart';
import 'package:flutter/material.dart';

class ThemedFieldButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onPressed;

  const ThemedFieldButton({Key key, this.icon, this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: OutlinedButton.icon(
        icon: Icon(icon),
        style: ButtonStyle(
          foregroundColor:
              MaterialStateProperty.all<Color>(AppThemeData.highlightColor),
          side: MaterialStateProperty.all<BorderSide>(
            const BorderSide(color: AppThemeData.highlightColor),
          ),
        ),
        label: (text != null)
            ? ThemedText(
                text: text,
                textColor: ThemedTextColor.highlight,
              )
            : null,
        onPressed: onPressed,
      ),
    );
  }
}
