extension DateTimeExtensions on DateTime {
  String toStringAsTarget() {
    var ts = difference(DateTime.now().toUtc());

    if (ts.abs().inSeconds < 60) {
      return 'Now';
    }

    var sb = StringBuffer();

    if (ts.isNegative) {
      sb.write('Overdue ');
      ts = ts.abs();
    } else {
      sb.write('In ');
    }

    if (ts.inDays >= 3) {
      sb.write('${ts.inDays} days');
    } else if (ts.inHours >= 2) {
      sb.write('${ts.inHours} hours');
    } else {
      sb.write('${ts.inMinutes} min');
    }

    return sb.toString();
  }
}
