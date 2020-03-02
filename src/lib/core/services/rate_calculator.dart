import 'dart:math';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/definitions.dart';

double _f2(num x) => 2 / (1 + pow(e, -(x / 100)));
double _f4(num x) => 4 / (1 + pow(e, -(x / 100)));

int _lowTheshold() => 1;
int _negative(int x) => x < 10 ? 1 : (x / _f4(x) + 1).ceil();
int _uncertain(int x) => x > 90 ? 99 : (x * 1.02 + 1).ceil();
int _positive(int x) => x > 65
    ? 99
    : x <= 10 ? (x * _f4(x) + 1).ceil() : 11 + (x * _f2(x) + 1).ceil();
int _highThershold() => def.rateHighThreshold;

int calculateNextRate(int rate, RateFeedback feedback) {
  switch (feedback) {
    case RateFeedback.lowTheshold:
      return _lowTheshold();
    case RateFeedback.negative:
      return _negative(rate);
    case RateFeedback.uncertain:
      return _uncertain(rate);
    case RateFeedback.positive:
      return _positive(rate);
    case RateFeedback.highThershold:
      return _highThershold();
    default:
      return rate;
  }
}

Duration calculateCooldown(int rate, RateFeedback feedback) {
  switch (feedback) {
    case RateFeedback.lowTheshold:
      return const Duration(minutes: 1);
    case RateFeedback.negative:
      return Duration(minutes: rate);
    case RateFeedback.uncertain:
      return Duration(minutes: rate * 2);
    case RateFeedback.positive:
      return Duration(minutes: rate * 100);
    case RateFeedback.highThershold:
      return const Duration(days: 25);
    default:
      return const Duration(minutes: 1);
  }
}
