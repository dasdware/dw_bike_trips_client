import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/cupertino.dart';

enum ThemedSpacingSize { Normal, Large }

class ThemedSpacing extends StatelessWidget {
  final ThemedSpacingSize size;

  const ThemedSpacing({Key key, this.size = ThemedSpacingSize.Normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pixelSize = 0.0;
    switch (size) {
      case ThemedSpacingSize.Large:
        pixelSize = AppThemeData.largeSpacing;
        break;
      default:
        pixelSize = AppThemeData.spacing;
        break;
    }

    return SizedBox(
      width: pixelSize,
      height: pixelSize,
    );
  }
}
