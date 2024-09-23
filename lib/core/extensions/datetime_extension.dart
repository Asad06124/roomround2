import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get timeAgo {
    final difference = DateTime.now().difference(this);
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inSeconds > 0) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'just now';
    }
  }

  String format({String format = 'MM/dd/yyyy'}) {
    return DateFormat(format).format(this);
  }

  String get dateOnly {
    return toString().substring(0, 10);
  }
}

extension GreetingExtension on DateTime {
  String get getGreeting {
    if (hour >= 5 && hour < 12) {
      return 'Good Morning!';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }
}

extension StringDateFormatExtension on String {
  String toDateAndMonth() {
    final DateTime? dateTime = DateTime.tryParse(this);

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return dateTime != null
        ? '${dateTime.day} ${months[dateTime.month - 1]}'
        : '';
  }
}
