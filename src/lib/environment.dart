import 'package:flutter/widgets.dart';

enum Profile { dev, devStub, qa, release }
enum Feature { feature1, feature2 }

class Environment {
  Environment._internal(this._profile, this._featureSwitch);

  factory Environment.current() {
    assert(_instance != null);
    return _instance;
  }
  static Environment _instance;

  static void setup({@required Profile profile, Map<Feature, bool> featureSwitch}) {
    _instance = Environment._internal(profile ?? Profile.dev, featureSwitch ?? {});
  }

  Profile _profile = Profile.dev;
  Map<Feature, bool> _featureSwitch = {};

  bool get isDev => _profile == Profile.dev;
  bool get isDevStub => _profile == Profile.devStub;
  bool get isQA => _profile == Profile.qa;
  bool get isRelease => _profile == Profile.release;

  bool isOn(Feature flag) => _featureSwitch.containsKey(flag) && _featureSwitch[flag];
  bool isOff(Feature flag) => !_featureSwitch.containsKey(flag) || !_featureSwitch[flag];
}
