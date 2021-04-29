import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:vocabulary_advancer/shared/settings.dart';

// ignore_for_file: avoid_print

class AppLogger {
  AppLogger._();

  factory AppLogger.init() {
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen((rec) {
      if (kDebugMode && rec.level >= Logger.root.level) {
        final msg = rec.message.replaceAll('\n', ' ');
        print('${rec.level.name} | ${rec.time} | ${rec.loggerName} | $msg');
      }
    });

    return AppLogger._();
  }

  final Map<String, Logger> _namedLoggers = {};

  /// (Verbose) Log a message at level [Level.FINEST].
  /// Consider for all possible noisy messages like read/write to local cache.
  void v(String Function() message, [String? logName]) {
    if (settings.isLogEnabled) {
      _logInternally(Level.FINEST, logName, message);
    }
  }

  /// (Trace) Log a message at level [Level.FINER].
  /// Consider for HTTP requests or other tracing info.
  void t(String Function() message, [String? logName]) {
    if (settings.isLogEnabled) {
      _logInternally(Level.FINER, logName, message);
    }
  }

  /// (Debug) Log a message at level [Level.FINE].
  /// Consider for HTTP responses.
  void d(String Function() message, [String? logName]) {
    if (settings.isLogEnabled) {
      _logInternally(Level.FINE, logName, message);
    }
  }

  /// (Info) Log a message at level [Level.INFO].
  /// Consider for meaningful logic-related messages.
  void i(String Function() message, [String? logName]) {
    if (settings.isLogEnabled) {
      _logInternally(Level.INFO, logName, message);
    }
  }

  /// (Warning) Log a message at level [Level.WARNING].
  /// Consider for exceptions and errors handled when fallback is possible.
  void w(String Function() message, [String? logName]) {
    if (settings.isLogEnabled) {
      _logInternally(Level.WARNING, logName, message);
    }
  }

  /// (Error) Log a message at level [Level.SEVERE].
  /// Consider for unhandled exceptions and errors which definitely cause user flow disruption.
  void e(String Function() message, {String? logName}) {
    if (settings.isLogEnabled) {
      _logInternally(Level.SEVERE, logName, message);
    }
  }

  void _logInternally(Level level, String? logName, String Function() message) {
    final logNameResolved = logName ?? 'APP';
    if (!_namedLoggers.containsKey(logNameResolved)) {
      _namedLoggers[logNameResolved] = Logger(logNameResolved);
    }
    _namedLoggers[logNameResolved]!.log(level, message);
  }
}
