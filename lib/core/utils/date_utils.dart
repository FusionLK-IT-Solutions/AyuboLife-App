class DateUtils {
  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
  
  static DateTime getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: 6));
  }
  
  static DateTime getStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }
  
  static String formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}