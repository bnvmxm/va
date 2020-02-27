part of 'root.dart';

bool isOn(Feature flag) =>
    Environment.current().features.containsKey(flag) && Environment.current().features[flag];
bool isOff(Feature flag) =>
    !Environment.current().features.containsKey(flag) || !Environment.current().features[flag];
