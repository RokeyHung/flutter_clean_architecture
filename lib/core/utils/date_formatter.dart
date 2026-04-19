// CORE - date_formatter.dart (intl)
import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final _dateFormat = DateFormat('dd/MM/yyyy', 'vi');
  static final _timeFormat = DateFormat('HH:mm', 'vi');
  static final _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm', 'vi');
  static final _relativeBase = DateFormat('EEEE, dd MMMM yyyy', 'vi');

  static String formatDate(DateTime date) => _dateFormat.format(date);
  static String formatTime(DateTime date) => _timeFormat.format(date);
  static String formatDateTime(DateTime date) => _dateTimeFormat.format(date);
  static String formatFull(DateTime date) => _relativeBase.format(date);

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return formatDate(date);
  }
}
