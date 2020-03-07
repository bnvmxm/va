import 'package:vocabulary_advancer/shared/root.dart';

extension DurationExt on Duration {
  bool isTargetClose() => isNegative || inMinutes < 60;
  bool isTargetFar() => !isNegative && inHours > 48;

  String toStringAsTarget() {
    if (isNegative) return svc.i18n.labelsStatNow;

    if (inSeconds < 60) {
      return svc.i18n.labelsStatNow;
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
  bool isRateHigh() => this > 75;
  bool isRateLow() => this <= 25;

  String toStringAsRate() {
    return isRateLow()
        ? svc.i18n.labelsStatRateLearning
        : isRateHigh() ? svc.i18n.labelsStatRateLearned : svc.i18n.labelsStatRateReviewing;
  }
}
