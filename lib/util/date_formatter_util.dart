import 'package:intl/intl.dart';

class DateFormatter{
  static final DateFormat _dateFormat = DateFormat('dd/MMM/y');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MMM/y - HH:mm');
  static DateTime parse(String inputString) => _dateFormat.parse(inputString);
  static DateTime parseWithTime(String inputString) => _dateTimeFormat.parse(inputString);
  static String format(DateTime date) => _dateFormat.format(date);
  static String formatWithTime(DateTime dateTime) => _dateTimeFormat.format(dateTime);
}