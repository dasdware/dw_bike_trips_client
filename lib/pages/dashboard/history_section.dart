import 'package:dw_bike_trips_client/session/dashboard.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:dw_bike_trips_client/widgets/themed/heading.dart';
import 'package:dw_bike_trips_client/widgets/themed/panel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardHistoryEntryBarChartGroupData extends BarChartGroupData {
  final DashboardHistoryEntry entry;
  DashboardHistoryEntryBarChartGroupData(
      int x, double maxDistance, this.entry, bool isTouched)
      : super(
          x: x,
          barRods: [
            BarChartRodData(
              toY: entry.distance,
              color: isTouched
                  ? AppThemeData.activeColor
                  : AppThemeData.headingColor,
              width: 16,
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: maxDistance,
                color: AppThemeData.panelBackgroundColor.withOpacity(
                    AppThemeData.panelBackgroundMostEmphasizedOpacity),
              ),
            ),
          ],
        );
}

class DashboardHistorySection extends StatefulWidget {
  final List<DashboardHistoryEntry> history;

  const DashboardHistorySection({Key key, @required this.history})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => DashboardHistorySectionState();
}

class DashboardHistorySectionState extends State<DashboardHistorySection> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ThemedHeading(
          caption: 'history',
        ),
        const SizedBox(
          height: 8.0,
        ),
        AspectRatio(
          aspectRatio: 1,
          child: ThemedPanel(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BarChart(
                buildChartData(context, widget.history),
                swapAnimationDuration: animDuration,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<DashboardHistoryEntryBarChartGroupData> buildChartBars(
      List<DashboardHistoryEntry> history) {
    var maxDistance = 0.0;
    for (var entry in history) {
      if (maxDistance < entry.distance) {
        maxDistance = entry.distance;
      }
    }

    var result = <DashboardHistoryEntryBarChartGroupData>[];
    for (int i = 0; i < history.length; ++i) {
      result.add(DashboardHistoryEntryBarChartGroupData(
          i, maxDistance, history[history.length - i - 1], i == touchedIndex));
    }
    return result;
  }

  BarChartData buildChartData(
      BuildContext context, List<DashboardHistoryEntry> history) {
    var barGroups = buildChartBars(history);
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: AppThemeData.tooltipBackground,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              var entry = barGroups[group.x].entry;
              var session = context.read<Session>();

              return BarTooltipItem(
                "${entry.month}/${entry.year}\n${session.formatDistance(entry.distance)}",
                const TextStyle(
                  color: AppThemeData.highlightColor,
                  fontWeight: FontWeight.w500,
                ),
              );
            }),
        touchCallback: (event, barTouchResponse) {
          setState(() {
            if (barTouchResponse?.spot != null) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => SideTitleWidget(
              axisSide: AxisSide.bottom,
              child: Text(
                barGroups[value.toInt()].entry.month.toString(),
                style: const TextStyle(
                    color: AppThemeData.headingColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            ),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: barGroups,
      gridData: FlGridData(show: false,),
    );
  }
}
