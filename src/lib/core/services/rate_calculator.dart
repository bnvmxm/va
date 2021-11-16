import 'package:vocabulary_advancer/core/model.dart';

int _rateLowTheshold() => 10;
int _rateNegative(int x) => (x <= 14
        ? 10
        : x < 30
            ? x * 0.75
            : x * 0.5)
    .ceil();
int _rateUncertain(int x) => (x < 65 ? x * 1.2 : x * 1.05).ceil();
int _ratePositive(int x) => (x > 75
        ? 99
        : x > 65
            ? 75
            : x > 50
                ? 65
                : x > 30
                    ? 50
                    : x > 10
                        ? 30
                        : 10)
    .ceil();
int _rateHighThershold() => 99;

int calculateNextRate(int rate, RateFeedback feedback) {
  switch (feedback) {
    case RateFeedback.lowTheshold:
      return _rateLowTheshold();
    case RateFeedback.negative:
      return _rateNegative(rate);
    case RateFeedback.uncertain:
      return _rateUncertain(rate);
    case RateFeedback.positive:
      return _ratePositive(rate);
    case RateFeedback.highThershold:
      return _rateHighThershold();
    default:
      return rate;
  }
}

int _cooldownMinutesLowTheshold() => 1;
int _cooldownMinutesNegative() => 3;
int _cooldownMinutesUncertain(int x) => (x * 1.2).ceil();
int _cooldownMinutesPositive(int x) => x < 30 ? x * 5 : x * 50;
int _cooldownMinutesHighThershold() => 60 * 24 * 10;

Duration calculateCooldown(int rate, RateFeedback feedback) {
  switch (feedback) {
    case RateFeedback.lowTheshold:
      return Duration(minutes: _cooldownMinutesLowTheshold());
    case RateFeedback.negative:
      return Duration(minutes: _cooldownMinutesNegative());
    case RateFeedback.uncertain:
      return Duration(minutes: _cooldownMinutesUncertain(rate));
    case RateFeedback.positive:
      return Duration(minutes: _cooldownMinutesPositive(rate));
    case RateFeedback.highThershold:
      return Duration(minutes: _cooldownMinutesHighThershold());
    default:
      return Duration(minutes: _cooldownMinutesLowTheshold());
  }
}
