class DashboardDistances {
  final double today;
  final double thisWeek;
  final double thisMonth;
  final double thisYear;
  final double allTime;

  DashboardDistances(
      {this.today, this.thisWeek, this.thisMonth, this.thisYear, this.allTime});
}

class DashboardHistoryEntry {
  final int year;
  final int month;
  final int count;
  final double distance;

  DashboardHistoryEntry(this.year, this.month, this.count, this.distance);
}

class Dashboard {
  final DashboardDistances distances;
  final List<DashboardHistoryEntry> history;

  Dashboard({this.distances, this.history});
}
