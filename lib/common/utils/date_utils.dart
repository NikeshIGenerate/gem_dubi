String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');

  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;
  final seconds = duration.inSeconds % 60;

  return '${hours == 0 ? '' : '${hours}H '}${minutes == 0 ? '' : '${minutes}M '}${seconds == 0 ? '' : '${seconds}S '}';
}

extension DurationFormatter on Duration {
  String format() => formatDuration(this);
}

extension DateExtention on DateTime {
  DateTime changeDateOnly(DateTime newDate) => DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
        hour,
        minute,
        second,
      );

  DateTime changeTimeOnly(DateTime newDate) => DateTime(
        year,
        month,
        day,
        newDate.hour,
        newDate.minute,
        newDate.second,
      );
}
