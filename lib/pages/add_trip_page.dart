import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/session/trips_queue.dart';
import 'package:dw_bike_trips_client/theme.dart' as AppTheme;
import 'package:dw_bike_trips_client/widgets/themed.dart';
import 'package:dw_bike_trips_client/widgets/themed/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTripPage extends StatefulWidget {
  @override
  _AddTripPageState createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  final TextEditingController _distanceController = TextEditingController();

  DateTime _selectedTimestamp;
  bool _keepOpen = false;

  initState() {
    _selectedTimestamp = context.read<Session>().tripsQueue.lastSubmision;
    super.initState();
  }

  _addPressed(BuildContext context) {
    var distance = double.tryParse(_distanceController.value.text);
    if (distance != null) {
      context.read<Session>().tripsQueue.enqueue(
            Trip(
              timestamp: _selectedTimestamp,
              distance: distance,
            ),
          );
      if (_keepOpen) {
        _distanceController.value = TextEditingValue.empty;
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.primaryColor_4,
            content: ThemedText(
              text:
                  'Added trip, ${context.read<Session>().tripsQueue.trips.length} trips in queue.',
            ),
          ),
        );
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  _setSelectedTimestamp(DateTime timestamp) {
    setState(() {
      _selectedTimestamp = timestamp;
    });
  }

  _setKeepOpen(bool value) {
    setState(() {
      _keepOpen = value;
    });
  }

  _selectDate(BuildContext context) async {
    DateTime selection = await showDatePicker(
      context: context,
      initialDate: _selectedTimestamp,
      firstDate: DateTime(1970),
      lastDate: DateTime(2170),
      builder: themedDatePickerBuilder,
    );

    if (selection != null) {
      _setSelectedTimestamp(
        DateTime(
          selection.year,
          selection.month,
          selection.day,
          _selectedTimestamp.hour,
          _selectedTimestamp.minute,
          _selectedTimestamp.second,
          0,
          0,
        ),
      );
    }
  }

  _selectTime(BuildContext context) async {
    TimeOfDay selection = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTimestamp),
      builder: themedTimePickerBuilder,
    );

    if (selection != null) {
      _setSelectedTimestamp(
        DateTime(
          _selectedTimestamp.year,
          _selectedTimestamp.month,
          _selectedTimestamp.day,
          selection.hour,
          selection.minute,
          _selectedTimestamp.second,
          0,
          0,
        ),
      );
    }
  }

  _buildTextFields(BuildContext context) {
    var session = context.watch<Session>();
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Row(
              children: [
                Expanded(
                  child: FieldButton(
                    icon: Icons.date_range,
                    text: session.dateFormat.format(_selectedTimestamp),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: FieldButton(
                    icon: Icons.watch_later_outlined,
                    text: session.timeFormat.format(_selectedTimestamp),
                    onPressed: () => _selectTime(context),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          ThemedTextField(
            controller: _distanceController,
            labelText: 'Distance',
            keyboardType: TextInputType.number,
          ),
          Row(
            children: [
              Switch(
                activeTrackColor: AppTheme.secondaryColor_3,
                activeColor: AppTheme.secondaryColor_2,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey,
                value: _keepOpen,
                onChanged: _setKeepOpen,
              ),
              if (_keepOpen)
                ThemedText(
                  text: "Keep open",
                )
              else
                ThemedText(
                  text: "Keep open",
                  color: Colors.white,
                )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Builder(
      builder: (context) => new Column(
        children: <Widget>[
          new RaisedButton(
            color: AppTheme.secondaryColors[2],
            child: new Text('Add'),
            onPressed: () => _addPressed(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      appBar: themedAppBar(
        title: Text('Add new trip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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

class FieldButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onPressed;

  const FieldButton({Key key, this.icon, this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: OutlinedButton.icon(
        icon: Icon(icon),
        style: ButtonStyle(
          foregroundColor:
              MaterialStateProperty.all<Color>(AppTheme.secondaryColor_2),
          side: MaterialStateProperty.all<BorderSide>(
            BorderSide(color: AppTheme.secondaryColor_2),
          ),
        ),
        label: ThemedText(
          text: text,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
