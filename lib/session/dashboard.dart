class DashboardDistances {
  final double today;
  final double thisWeek;
  final double thisMonth;
  final double thisYear;
  final double allTime;

  DashboardDistances(
      {this.today, this.thisWeek, this.thisMonth, this.thisYear, this.allTime});
}

class Dashboard {
  final DashboardDistances distances;

  Dashboard({this.distances});
}
