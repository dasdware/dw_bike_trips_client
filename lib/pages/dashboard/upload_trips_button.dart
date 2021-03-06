import 'package:dw_bike_trips_client/pages/post_trips.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/session/trips_queue.dart';
import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadTripsButton extends StatelessWidget {
  const UploadTripsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Trip>>(
        initialData: context.watch<Session>().tripsQueue.trips,
        stream: context.watch<Session>().tripsQueue.tripsStream,
        builder: (context, snapshot) {
          return Center(
            child: Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.cloud_upload_outlined,
                    color: AppThemeData.activeColor,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostTripsPage()));
                  },
                ),
                if (snapshot.hasData && snapshot.data.isNotEmpty)
                  Positioned(
                    right: 2,
                    bottom: 6,
                    child: Container(
                      width: 18,
                      height: 18,
                      child: CircleAvatar(
                        backgroundColor: AppThemeData.activeDarkerColor,
                        child: Text(
                          snapshot.data.length.toString(),
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppThemeData.activeLighterColor),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        });
  }
}
