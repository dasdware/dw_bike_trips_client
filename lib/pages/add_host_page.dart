import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/widgets/error_list.dart';
import 'package:dw_bike_trips_client/widgets/themed/button.dart';
import 'package:dw_bike_trips_client/widgets/themed/heading.dart';
import 'package:dw_bike_trips_client/widgets/themed/panel.dart';
import 'package:dw_bike_trips_client/widgets/themed/scaffold.dart';
import 'package:dw_bike_trips_client/widgets/themed/spacing.dart';
import 'package:dw_bike_trips_client/widgets/themed/text.dart';
import 'package:dw_bike_trips_client/widgets/themed/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';

class AddHostPage extends StatefulWidget {
  @override
  _AddHostPageState createState() => _AddHostPageState();
}

class _AddHostPageState extends State<AddHostPage> {
  final TextEditingController _urlController =
      TextEditingController(text: FlutterConfig.get('DEFAULT_HOST'));

  _addPressed(BuildContext context) async {
    var url = _urlController.value.text;
    var newHost = await context.read<Session>().serverInfo(url);
    if (newHost != null) {
      context.read<Session>().hosts.addHost(newHost.name, newHost.url);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      appBar: themedAppBar(
        title: ThemedHeading(
          caption: 'Add new host',
          style: ThemedHeadingStyle.Big,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Center(
          child: SingleChildScrollView(
            child: ThemedPanel(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ThemedText(
                    text:
                        'Enter the URI of the API endpoint that should be accessed by the new host. Once you are finished, use the button below to try to access the host and - if successful - add it to the hosts list.',
                  ),
                  ThemedSpacing(),
                  ErrorList(operationName: 'serverInfo'),
                  ThemedTextField(
                    controller: _urlController,
                    keyboardType: TextInputType.url,
                    labelText: 'URL',
                  ),
                  ThemedSpacing(size: ThemedSpacingSize.Large),
                  ThemedButton(
                    icon: Icons.cloud_outlined,
                    overlayIcon: Icons.add,
                    caption: 'Register',
                    onPressed: () => _addPressed(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
