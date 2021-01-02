import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/theme.dart' as AppTheme;
import 'package:dw_bike_trips_client/widgets/error_list.dart';
import 'package:dw_bike_trips_client/widgets/themed.dart';
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

  _buildTextFields(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TextField(
            controller: _urlController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(labelText: 'URL'),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return new Column(
      children: <Widget>[
        new RaisedButton(
          color: AppTheme.secondaryColors[2],
          child: new Text('Add'),
          onPressed: () => _addPressed(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      appBar: themedAppBar(
        title: Text('Add new host'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ErrorList(operationName: 'serverInfo'),
                _buildTextFields(context),
                SizedBox(
                  height: 16.0,
                ),
                _buildButtons(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
