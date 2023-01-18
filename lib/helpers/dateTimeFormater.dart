import 'package:intl/intl.dart';

class DateTimeFormatter {
  DateTime convertDateToLocalTime(String dateTime) {
    DateTime dt = DateTime.parse(dateTime);
    DateTime utcTime =
        DateTime.utc(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second);
    final DateTime localDate = DateFormat("yyyy-MM-dd HH:mm:ssZ")
        .parseUTC(utcTime.toString())
        .toLocal();
    return localDate;
  }

  getFormattedDate(dateTime) {
    if (dateTime != null) {
      DateTime localDate = convertDateToLocalTime(dateTime);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(localDate);
    }
    return '_/_/_';
  }

  String getFormattedTime(dateTime) {
    if (dateTime != null) {
      DateTime localDate = convertDateToLocalTime(dateTime);
      final DateFormat formatter = DateFormat('Hm');
      return formatter.format(localDate);
    }
    return '_:_';
  }

  DateTime dateHourMinutes(datetime) {
    DateTime dateTime = DateTime.parse(datetime).toUtc();
    DateTime formattedDateTime = DateTime(dateTime.year, dateTime.month,
        dateTime.day, dateTime.hour, dateTime.minute);
    return formattedDateTime;
  }

  int getTimeDifference(dateTime) {
    DateTime dateTimeData = DateTime.parse(dateTime);
    final currentTime = DateTime.now();
    final difference = dateTimeData.difference(currentTime).inMinutes;
    return difference;
  }
  String messageDateTime(dateTime,isSent) {
    if (dateTime != null) {
      DateTime localDate = convertDateToLocalTime(dateTime);
      final DateFormat formatter = isSent? DateFormat('HH:mm dd/MM/yy'): DateFormat('dd/MM/yy HH:mm ');
      return formatter.format(localDate);
    }
    return '_/_/_';
  }
}
