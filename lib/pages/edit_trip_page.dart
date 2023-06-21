import 'package:dw_bike_trips_client/session/operations/timestamp.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/session/trip.dart';
import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:dw_bike_trips_client/widgets/themed/button.dart';
import 'package:dw_bike_trips_client/widgets/themed/date_picker.dart';
import 'package:dw_bike_trips_client/widgets/themed/heading.dart';
import 'package:dw_bike_trips_client/widgets/themed/icon.dart';
import 'package:dw_bike_trips_client/widgets/themed/panel.dart';
import 'package:dw_bike_trips_client/widgets/themed/scaffold.dart';
import 'package:dw_bike_trips_client/widgets/themed/spacing.dart';
import 'package:dw_bike_trips_client/widgets/themed/switch.dart';
import 'package:dw_bike_trips_client/widgets/themed/text.dart';
import 'package:dw_bike_trips_client/widgets/themed/textfield.dart';
import 'package:dw_bike_trips_client/widgets/themed/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditTripPage extends StatefulWidget {
  final ChangeableTrip trip;

  const EditTripPage({Key key, this.trip}) : super(key: key);

  @override
  State<EditTripPage> createState() => _EditTripPageState();
}

class _EditTripPageState extends State<EditTripPage> {
  TextEditingController _distanceController;

  bool _isEditing = false;
  Timestamp _selectedTimestamp;
  bool _keepOpen = false;
  String _addedTripsInformation;

  @override
  initState() {
    _isEditing = widget.trip != null;
    if (_isEditing) {
      _selectedTimestamp = widget.trip.timestamp;
      _distanceController =
          TextEditingController(text: widget.trip.distance.toString());
    } else {
      _selectedTimestamp = context.read<Session>().changesQueue.lastSubmision;
      _distanceController = TextEditingController();
    }
    super.initState();
  }

  _addPressed(BuildContext context) {
    var distance = double.tryParse(_distanceController.value.text);
    if (distance != null) {
      if (_isEditing) {
        widget.trip.update(_selectedTimestamp, distance);
        Navigator.of(context).pop();
      } else {
        context.read<Session>().changesQueue.enqueueAddTrip(
              Trip(
                timestamp: _selectedTimestamp,
                distance: distance,
              ),
            );
        if (_keepOpen) {
          _distanceController.value = TextEditingValue.empty;
          setState(() {
            _addedTripsInformation =
                'Added trip, ${context.read<Session>().changesQueue.changes.length} changes in queue.';
          });
        } else {
          Navigator.of(context).pop();
        }
      }
    }
  }

  _setSelectedTimestamp(Timestamp timestamp) {
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
    DateTime selection =
        await showThemedDatePicker(context, _selectedTimestamp.toDateTime());

    if (selection != null) {
      _setSelectedTimestamp(
        _selectedTimestamp.withDate(
            selection.year, selection.month, selection.day),
      );
    }
  }

  _selectTime(BuildContext context) async {
    DateTime selection =
        await showThemedTimePicker(context, _selectedTimestamp.toDateTime());

    if (selection != null) {
      _setSelectedTimestamp(Timestamp.dt(selection, withTime: true));
    }
  }

  _removeTime(BuildContext context) async {
    _setSelectedTimestamp(_selectedTimestamp.withoutTime());
  }

  _buildTextFields(BuildContext context) {
    var session = context.watch<Session>();
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 156,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  border: Border.all(color: AppThemeData.activeColor),
                ),
                child: InkWell(
                  splashColor: AppThemeData.mainDarkestColor,
                  //highlightColor: AppThemeData.mainDarkerColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 8.0),
                    child: Row(
                      children: [
                        const ThemedIcon(
                          icon: Icons.date_range,
                          color: AppThemeData.activeColor,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              session.formatDate(_selectedTimestamp),
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  color: AppThemeData.activeColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => _selectDate(context),
                ),
              ),
              Container(
                width: 165,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  border: Border.all(color: AppThemeData.activeColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: InkWell(
                        splashColor: AppThemeData.mainDarkestColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 8.0),
                          child: Row(
                            children: [
                              const ThemedIcon(
                                icon: Icons.watch_later_outlined,
                                color: AppThemeData.activeColor,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    session.formatTime(_selectedTimestamp),
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        color: AppThemeData.activeColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () => _selectTime(context),
                      ),
                    ),
                    if (_selectedTimestamp.hasTime)
                      Row(
                        children: [
                          Container(
                            width: 1,
                            height: 48,
                            color: AppThemeData.activeColor,
                          ),
                          SizedBox(
                            width: 48,
                            child: InkWell(
                              splashColor: AppThemeData.mainDarkestColor,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 8.0),
                                child: ThemedIcon(
                                  icon: Icons.clear,
                                  color: AppThemeData.activeColor,
                                ),
                              ),
                              onTap: () => _removeTime(context),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const ThemedSpacing(),
        ThemedTextField(
          controller: _distanceController,
          labelText: 'Distance',
          keyboardType: TextInputType.number,
        ),
        if (!_isEditing)
          ThemedSwitch(
            text: 'Keep open',
            value: _keepOpen,
            onChanged: _setKeepOpen,
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      pageName: _isEditing ? 'editTrip' : 'addTrip',
      appBar: themedAppBar(
        title: ThemedHeading(
          caption: _isEditing ? 'Edit trip' : 'Add new trip',
          style: ThemedHeadingStyle.big,
        ),
      ),
      body: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: ThemedPanel(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ThemedText(
                        text: _isEditing
                            ? 'Select date and time of your trip and enter the distance driven. After that, use the button below to change it in the upload queue.'
                            : 'Select date and time of your trip and enter the distance driven. After that, use the button below to add it to the upload queue.',
                        textAlign: TextAlign.left,
                      ),
                      const ThemedSpacing(size: ThemedSpacingSize.large),
                      _buildTextFields(context),
                      const ThemedSpacing(size: ThemedSpacingSize.large),
                      ThemedButton(
                        caption: _isEditing ? 'Apply' : 'Add',
                        icon:
                            _isEditing ? Icons.check_circle : Icons.add_circle,
                        onPressed: () => _addPressed(context),
                      ),
                      if (_addedTripsInformation != null)
                        Column(
                          children: [
                            const ThemedSpacing(size: ThemedSpacingSize.large),
                            SizedBox(
                              width: double.infinity,
                              child: ThemedText(
                                text: _addedTripsInformation,
                                textAlign: TextAlign.left,
                                deemphasized: true,
                              ),
                            ),
                          ],
                        )
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
