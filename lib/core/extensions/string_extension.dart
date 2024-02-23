import 'package:intl/intl.dart';
import 'package:roomrounds/core/constants/imports.dart';

extension StringExtension on String {
  /// funds raising donation id
  String get referenceId => substring(0, length ~/ 3).toUpperCase();

  String get completeUrl => isNotEmpty ? "${Urls.baseUrl}$this" : '';
}

extension Pluralize on String {
  String pluralize(int length) =>
      length <= 1 ? '$length $this' : '$length ${this}s';
}

extension StringToDateTime on String {
  DateTime toDateTime() {
    try {
      return DateFormat('yyyy-MM-dd').parseStrict(this);
    } catch (e) {
      //throw FormatException("Error parsing date: $this. $e");
      return DateTime.now();
    }
  }
}

extension SearchWorkOuts on String {
  bool search(String name) {
    if (isEmpty) return true;

    if (name.trim().toLowerCase().contains(trim().toLowerCase())) return true;

    return false;
  }
}

extension TimeStringExtension on String {
  int toSeconds() {
    List<String> timeComponents = split(':');

    if (timeComponents.length != 3) {
      // Invalid time format
      throw FormatException("Invalid time format: $this");
    }

    int hours = int.parse(timeComponents[0]);
    int minutes = int.parse(timeComponents[1]);
    int seconds = int.parse(timeComponents[2]);

    return hours * 3600 + minutes * 60 + seconds;
  }
}
