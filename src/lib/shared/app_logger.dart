import 'dart:developer';

import 'package:flutter/foundation.dart';

const _logLevel = int.fromEnvironment('VA_LOG_LEVEL', defaultValue: kDebugMode ? 3 : 8);

enum LogLevel {
  /* 0 */ all,
  /* 1 */ trace,
  /* 2 */ verbose,
  /* 3 */ debug,
  /* 4 */ info,
  /* 5 */ warnings,
  /* 6 */ errors,
  /* 7 */ criticals,
  /* 8 */ off,
}

class LogSettings {
  LogLevel get logLevel => _logLevel.toLoglevel();
  bool isEnabled(LogLevel level) => level.isOn(_logLevel);
}

class AppLogger {
  AppLogger(this.settings);

  final LogSettings settings;

  /// (Trace)
  /// Consider for HTTP requests or other tracing info.
  void t(String Function() message, [String? logName]) {
    if (settings.isEnabled(LogLevel.trace)) {
      _logInternally('T', logName, message());
    }
  }

  /// (Verbose)
  /// Consider for all possible noisy messages like read/write to local cache.
  void v(String Function() message, [String? logName]) {
    if (settings.isEnabled(LogLevel.verbose)) {
      _logInternally('V', logName, message());
    }
  }

  /// (Debug)
  /// Consider for HTTP responses.
  void d(String Function() message, [String? logName]) {
    if (settings.isEnabled(LogLevel.debug)) {
      _logInternally('D', logName, message());
    }
  }

  /// (Info)
  /// Consider for meaningful logic-related messages.
  void i(String Function() message, [String? logName]) {
    if (settings.isEnabled(LogLevel.info)) {
      _logInternally('I', logName, message());
    }
  }

  /// (Warning)
  /// Consider for exceptions and errors handled when fallback is possible.
  void w(String Function() message, [String? logName]) {
    if (settings.isEnabled(LogLevel.warnings)) {
      _logInternally('W', logName, message());
    }
  }

  /// (Error)
  /// Consider for unhandled exceptions and errors which definitely cause user flow disruption.
  void e(String Function() message, {String? logName, Object? error, StackTrace? stackTrace}) {
    if (settings.isEnabled(LogLevel.errors)) {
      _logInternally('E', logName, message(), error, stackTrace);
    }
  }

  /// (Critical)
  /// Consider for unhandled exceptions and errors which definitely cause user flow disruption.
  void c(String Function() message, {String? logName, Object? error, StackTrace? stackTrace}) {
    if (settings.isEnabled(LogLevel.criticals)) {
      _logInternally('C', logName, message(), error, stackTrace);
    }
  }

  void _logInternally(String level, String? logName, String message,
      [Object? error, StackTrace? stackTrace]) {
    log('[$level] $message',
        time: DateTime.now().toUtc(), name: logName ?? 'APP', error: error, stackTrace: stackTrace);
  }
}

extension on LogLevel {
  bool isOn(int settingsValue) {
    switch (this) {
      case LogLevel.all:
        return settingsValue <= 0;
      case LogLevel.trace:
        return settingsValue <= 1;
      case LogLevel.verbose:
        return settingsValue <= 2;
      case LogLevel.debug:
        return settingsValue <= 3;
      case LogLevel.info:
        return settingsValue <= 4;
      case LogLevel.warnings:
        return settingsValue <= 5;
      case LogLevel.errors:
        return settingsValue <= 6;
      case LogLevel.criticals:
        return settingsValue <= 7;
      case LogLevel.off:
        return false;
    }
  }
}

extension on int {
  LogLevel toLoglevel() {
    switch (this) {
      case 1:
        return LogLevel.all;
      case 2:
        return LogLevel.trace;
      case 3:
        return LogLevel.verbose;
      case 4:
        return LogLevel.debug;
      case 5:
        return LogLevel.info;
      case 6:
        return LogLevel.warnings;
      case 7:
        return LogLevel.errors;
      case 8:
        return LogLevel.criticals;
      default:
        return LogLevel.off;
    }
  }
}
