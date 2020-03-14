import 'package:logger/logger.dart';
import 'package:vocabulary_advancer/shell/environment.dart';

const Level _devLevel = Level.verbose;
const Level _relLevel = Level.warning;

class AppLogger {
  AppLogger()
      : _level = Environment.current().isDev ? _devLevel : _relLevel,
        _logger = Logger(
            level: Environment.current().isDev ? _devLevel : _relLevel,
            output: ConsoleOutput(),
            printer: SimplePrinter());

  final Level _level;
  final Logger _logger;

  void verbose(String Function() str) {
    if (_level.index > Level.verbose.index) return;
    _logger.v(str?.call());
  }

  void debug(String Function() str) {
    if (_level.index > Level.debug.index) return;
    _logger.d(str?.call());
  }

  void warning(String Function() str, [Error err, StackTrace st]) {
    if (_level.index > Level.warning.index) return;
    _logger.w(str?.call(), err, st);
  }
}
