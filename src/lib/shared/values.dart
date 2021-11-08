class Values {
  final DateTime maxDateTimeUtc = DateTime.now().toUtc().add(const Duration(days: 365 * 10));

  final int targetMinutesLowThreshold = 10;
  final int targetHoursHighThreshold = 24;

  final int rateLowThreshold = 35;
  final int rateHighThreshold = 75;
}
