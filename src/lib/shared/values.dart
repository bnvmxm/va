class Values {
  final DateTime minDateTimeUtc = DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true);

  final int targetMinutesLowThreshold = 10;
  final int targetHoursHighThreshold = 48;

  final int rateLowThreshold = 35;
  final int rateHighThreshold = 75;
}
