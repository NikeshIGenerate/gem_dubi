import 'package:intl/intl.dart';

class TimeAgoFormat {
  static String timeAgo(DateTime date) {
    final currentDate = DateTime.now();

    final different = currentDate.difference(date);

    if (different.inDays > 1 && different.inDays < 8) {
      return getWeekDay(date.weekday);
    }
    if (different.inDays == 1) {
      return 'Yesterday';
    }
    if (different.inDays == 0) {
      return 'Today';
    }
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String getWeekDay(int day) {
    if(day == 1) {
      return 'Monday';
    }
    else if(day == 2) {
      return 'Tuesday';
    }
    else if(day == 3) {
      return 'Wednesday';
    }
    else if(day == 4) {
      return 'Thursday';
    }
    else if(day == 5) {
      return 'Friday';
    }
    else if(day == 6) {
      return 'Saturday';
    }
    else {
      return 'Sunday';
    }
  }
}