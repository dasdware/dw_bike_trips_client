import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/widgets/page.dart';
import 'package:dw_bike_trips_client/widgets/themed/button.dart';
import 'package:dw_bike_trips_client/widgets/themed/heading.dart';
import 'package:dw_bike_trips_client/widgets/themed/panel.dart';
import 'package:dw_bike_trips_client/widgets/themed/scaffold.dart';
import 'package:dw_bike_trips_client/widgets/themed/spacing.dart';
import 'package:dw_bike_trips_client/widgets/themed/text.dart';
import 'package:dw_bike_trips_client/widgets/themed/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddHostPage extends StatefulWidget {
  const AddHostPage({Key key}) : super(key: key);

  @override
  State<AddHostPage> createState() => _AddHostPageState();
}

class _AddHostPageState extends State<AddHostPage> {
  final TextEditingController _urlController =
      TextEditingController(text: '');

  _addPressed(BuildContext context) async {
    var session = context.read<Session>();
    var navigator = Navigator.of(context);
    var url = _urlController.value.text;
    var newHost = await context
        .read<Session>()
        .serverInfo(ApplicationPage.of(context).pageName, url);
    if (newHost != null) {
      session.hosts.addHost(newHost.name, newHost.url);
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      pageName: 'addHost',
      appBar: themedAppBar(
        title: const ThemedHeading(
          caption: 'Add new host',
          style: ThemedHeadingStyle.big,
        ),
      ),
      body: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: ThemedPanel(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const ThemedText(
                        text:
                            'Enter the URI of the API endpoint that should be accessed by the new host. Once you are finished, use the button below to try to access the host and - if successful - add it to the hosts list.',
                      ),
                      const ThemedSpacing(),
                      ThemedTextField(
                        controller: _urlController,
                        keyboardType: TextInputType.url,
                        labelText: 'URL',
                      ),
                      const ThemedSpacing(size: ThemedSpacingSize.large),
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
        ),
      ),
    );
  }
}
