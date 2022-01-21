import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

enum ThemedPanelStyle { Normal, Emphasized, MostEmphasized }

class ThemedPanel extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final ThemedPanelStyle style;

  const ThemedPanel(
      {Key key,
      this.width,
      this.height,
      this.margin = EdgeInsets.zero,
      this.padding = const EdgeInsets.all(8.0),
      this.style = ThemedPanelStyle.Normal,
      this.child})
      : super(key: key);

  _calculateOpacity() {
    return (style == ThemedPanelStyle.Emphasized)
        ? AppThemeData.panelBackgroundEmphasizedOpacity
        : (style == ThemedPanelStyle.MostEmphasized)
            ? AppThemeData.panelBackgroundMostEmphasizedOpacity
            : AppThemeData.panelBackgroundOpacity;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
          begin: AppThemeData.panelBackgroundOpacity, end: _calculateOpacity()),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      builder: (BuildContext context, double opacity, Widget child) {
        return Padding(
          padding: margin,
          child: Container(
            width: this.width,
            height: this.height,
            decoration: BoxDecoration(
              color: AppThemeData.panelBackgroundColor.withOpacity(opacity),
              borderRadius:
                  BorderRadius.circular(AppThemeData.panelBorderRadius),
            ),
            child: Padding(
              padding: this.padding,
              child: this.child,
            ),
          ),
        );
      },
    );
  }
}
