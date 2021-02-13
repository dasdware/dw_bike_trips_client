import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

enum ThemedPanelStyle { Normal, Emphasized }

class ThemedPanel extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final EdgeInsets padding;
  final ThemedPanelStyle style;

  const ThemedPanel(
      {Key key,
      this.width,
      this.height,
      this.padding = const EdgeInsets.all(8.0),
      this.style = ThemedPanelStyle.Normal,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        color: (style == ThemedPanelStyle.Emphasized)
            ? AppThemeData.panelEmphasizedBackground
            : AppThemeData.panelBackground,
        borderRadius: BorderRadius.circular(AppThemeData.panelBorderRadius),
      ),
      child: Padding(
        padding: this.padding,
        child: this.child,
      ),
    );
  }
}
