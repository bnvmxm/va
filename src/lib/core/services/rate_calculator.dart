import 'dart:math';
import 'package:vocabulary_advancer/core/model.dart';

double _f2(num x) => 2 / (1 + pow(e, -(x / 100)));
double _f4(num x) => 4 / (1 + pow(e, -(x / 100)));

int _rateLowTheshold() => 1;
int _rateNegative(int x) => x < 10 ? 1 : (x / _f4(x) + 1).ceil();
int _rateUncertain(int x) => x > 90 ? 99 : (x * 1.02 + 1).ceil();
int _ratePositive(int x) =>
    x > 65 ? 99 : x <= 10 ? (x * _f4(x) + 1).ceil() : 11 + (x * _f2(x) + 1).ceil();
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
int _cooldownMinutesNegative(int x) => (x * 0.5).ceil();
int _cooldownMinutesUncertain(int x) => (x * 1.2).ceil();
int _cooldownMinutesPositive(int x) => (x * 60 * 0.7).ceil();
int _cooldownMinutesHighThershold() => 60 * 24 * 25;

Duration calculateCooldown(int rate, RateFeedback feedback) {
  switch (feedback) {
    case RateFeedback.lowTheshold:
      return Duration(minutes: _cooldownMinutesLowTheshold());
    case RateFeedback.negative:
      return Duration(minutes: _cooldownMinutesNegative(rate));
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
