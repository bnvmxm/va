import 'package:flutter/widgets.dart';
import 'package:vocabulary_advancer/shell/feature.dart';

enum Profile { dev, devStub, qa, release }

class Environment {
  Environment._internal(this._profile, this.features);

  factory Environment.current() {
    assert(_instance != null);
    return _instance;
  }
  static Environment _instance;

  static void setup({@required Profile profile, Map<Feature, bool> features}) {
    _instance = Environment._internal(profile ?? Profile.dev, features ?? {});
  }

  Profile _profile = Profile.dev;
  Map<Feature, bool> features = {};

  bool get isDev => _profile == Profile.dev;
  bool get isDevStub => _profile == Profile.devStub;
  bool get isQA => _profile == Profile.qa;
  bool get isRelease => _profile == Profile.release;
}
