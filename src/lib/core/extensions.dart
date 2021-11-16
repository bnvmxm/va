import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/core/services/rate_calculator.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

const ext = 0;

extension ListIntExt on List<int> {
  int max() => fold(0, (prev, curr) => prev > curr ? prev : curr);
}

extension DurationExt on Duration {
  bool isTargetClose() => isNegative || inMinutes < svc.values.targetMinutesLowThreshold;
  bool isTargetFar() => !isNegative && inHours > svc.values.targetHoursHighThreshold;

  String toStringAsTarget() {
    if (isNegative || inSeconds < 60) return "now";

    final sb = StringBuffer();

    if (inDays >= 1) {
      sb.write('${inDays}d');
    } else if (inHours >= 1) {
      sb.write('${inHours}h');
    } else if (inMinutes >= 1) {
      sb.write('${inMinutes}m');
    } else {
      sb.write("now");
    }

    return sb.toString();
  }
}

extension DateTimeExt on DateTime {
  Duration differenceNowUtc() => difference(DateTime.now().toUtc());
}

extension IntExt on int {
  bool isRateLow() => this <= svc.values.rateLowThreshold;
  bool isRateHigh() => this > svc.values.rateHighThreshold;

  int asRate(RateFeedback feedback) => calculateNextRate(this, feedback);
  Duration asCooldown(RateFeedback feedback) => calculateCooldown(this, feedback);
}
