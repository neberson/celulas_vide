class WeeksCalculator {

  // final _calc = WeesksCalculator();
  //
  // var date = DateTime(2020, 12, 29);
  //
  // int daysFromMonth = DateTime(date.year, date.month + 1, 0).day;
  //
  // print('quantas semanas tem este mês: ${_calc.getWeekFromDate(DateTime(date.year, date.month, daysFromMonth))}');
  // print('Em qual semana está esta data: ${_calc.getWeekFromDate(date)}');

  int getWeeksFromMonth(DateTime dateMonth){

    var date = DateTime(DateTime.now().year, dateMonth.month, DateTime.now().day);

    int daysFromMonth = DateTime(DateTime.now().year, date.month + 1, 0).day;

    return getWeekFromDate(DateTime(date.year, date.month, daysFromMonth));

  }

  getWeekFromDate(DateTime dateTime) {
    // Current date and time of system
    String date = dateTime.toString();

    // This will generate the time and date for first day of month
    String firstDay = date.substring(0, 7) + '01' + date.substring(10);

    // week day for the first day of the month
    int weekDay = DateTime.parse(firstDay).weekday;

    int currentWeek;

    // If your calender starts from sunday
    if (weekDay == 7) {
      // Current week
      currentWeek = (dateTime.day / 7).ceil();
    } else {
      // Current week
      currentWeek = ((dateTime.day + weekDay) / 7).ceil();
    }

    return currentWeek;
  }
}
