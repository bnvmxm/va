const bool _isLogEnabled =
    bool.fromEnvironment('VA_IS_LOG_ENABLED', defaultValue: false);

final Settings settings = Settings._internal();

class Settings {
  Settings._internal();

  final DateTime minDateTimeUtc =
      DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true);

  final int targetMinutesLowThreshold = 10;
  final int targetHoursHighThreshold = 48;

  final int rateLowThreshold = 35;
  final int rateHighThreshold = 75;

  bool get isLogEnabled => _isLogEnabled;
}
