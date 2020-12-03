import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dw_bike_trips_client/session.dart';
import 'package:dw_bike_trips_client/theme.dart' as AppTheme;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTripPage extends StatefulWidget {
  @override
  _AddTripPageState createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  final TextEditingController _distanceController = TextEditingController();

  DateTime _selectedTimestamp;

  initState() {
    _selectedTimestamp = context.read<Session>().lastTripSubmisionTimestamp;
    super.initState();
  }

  _addPressed(BuildContext context) {
    var distance = double.tryParse(_distanceController.value.text);
    if (distance != null) {
      context.read<Session>().enqueueTrip(_selectedTimestamp, distance);
      Navigator.of(context).pop();
    }
  }

  _setSelectedTimestamp(DateTime timestamp) {
    setState(() {
      _selectedTimestamp = timestamp;
    });
  }

  _buildTextFields() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              Provider.of<Session>(context).lastError,
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          DateTimeField(
            format: context.watch<Session>().timestampFormat,
            decoration: InputDecoration(labelText: 'Point in time'),
            initialValue: _selectedTimestamp,
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                );
                _setSelectedTimestamp(DateTimeField.combine(date, time));
                return _selectedTimestamp;
              } else {
                return currentValue;
              }
            },
          ), // TextField(
          SizedBox(
            height: 8.0,
          ),
          TextField(
            controller: _distanceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Distance'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new trip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildTextFields(),
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
