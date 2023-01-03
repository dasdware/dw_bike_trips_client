import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/cupertino.dart';

enum ThemedSpacingSize { normal, large }

class ThemedSpacing extends StatelessWidget {
  final ThemedSpacingSize size;

  const ThemedSpacing({Key key, this.size = ThemedSpacingSize.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pixelSize = 0.0;
    switch (size) {
      case ThemedSpacingSize.large:
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
