import 'package:flutter/material.dart';

class ApplicationPage extends InheritedWidget {
  final String pageName;
  const ApplicationPage({
    Key key,
    Widget child,
    @required this.pageName,
  }) : super(key: key, child: child);

  static ApplicationPage of(BuildContext context) {
    final ApplicationPage result =
        context.dependOnInheritedWidgetOfExactType<ApplicationPage>();
    assert(result != null, 'No Page found in context');
    return result;
  }

  @override
  bool updateShouldNotify(ApplicationPage oldWidget) {
    return oldWidget.pageName != pageName;
  }
}
