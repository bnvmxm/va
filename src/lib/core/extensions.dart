import 'package:vocabulary_advancer/core/services/rate_calculator.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/definitions.dart';

extension DurationExt on Duration {
  bool isTargetClose() =>
      isNegative || inMinutes < def.targetMinutesLowThreshold;
  bool isTargetFar() => !isNegative && inHours > def.targetHoursHighThreshold;

  String toStringAsTarget() {
    if (isNegative) return 'Now';

    if (inSeconds < 60) {
      return 'Now';
    }

    final sb = StringBuffer();

    if (inDays > 1) {
      sb.write('${inDays}d');
    } else if (inHours > 1) {
      sb.write('${inHours}h');
    } else {
      sb.write('${inMinutes}m');
    }

    return sb.toString();
  }
}

extension DateTimeExt on DateTime {
  Duration differenceNowUtc() => difference(DateTime.now().toUtc());
}

extension IntExt on int {
  bool isRateLow() => this <= def.rateLowThreshold;
  bool isRateHigh() => this > def.rateHighThreshold;

  int asRate(RateFeedback feedback) => calculateNextRate(this, feedback);
  Duration asCooldown(RateFeedback feedback) =>
      calculateCooldown(this, feedback);

  String toStringAsRate() {
    return isRateLow() ? 'Learning' : isRateHigh() ? 'Learned' : 'Reviewing';
  }
}
