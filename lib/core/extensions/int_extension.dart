import 'dart:async';

extension TimerExtension on int {
  Stream<String> startTimer() async* {
    int elapsedSeconds = this;

    StreamController<String> controller = StreamController<String>();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      int hours = elapsedSeconds ~/ 3600;
      int minutes = (elapsedSeconds % 3600) ~/ 60;
      int seconds = elapsedSeconds % 60;

      String formattedHours = hours.toString().padLeft(2, '0');
      String formattedMinutes = minutes.toString().padLeft(2, '0');
      String formattedSeconds = seconds.toString().padLeft(2, '0');

      controller.add("$formattedHours:$formattedMinutes:$formattedSeconds");

      elapsedSeconds++;
    });

    yield* controller.stream;
  }
}

extension IntPercentageExtension on int {
  double calculatePercentage(int total) {
    if (total == 0) {
      return 0.0;
    }

    double percentage = (this / total);

    return percentage > 1 ? 1 : percentage;
  }
}
