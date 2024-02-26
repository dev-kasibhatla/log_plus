library logs;

import 'package:flutter/foundation.dart';

/// Log levels for the logger
enum LogLevel {
  /// Verbose log level. Used for debugging purposes
  verbose,
  /// Debug log level. Used for debugging purposes
  debug,
  /// Info log level. Used for general information
  info,
  /// Warning log level. Used for warnings. Typically for non-critical issues
  warning,
  /// Error log level. Used for errors. Typically for critical issues
  error,
  /// Use this to disable logging and not print anything
  none,
}

/// A logger class that conditionally stores logs, traces and prints them to the console
///
/// Instantiate this class and use the methods to log messages
///
/// Use includeTrace to include the stack trace in the log. Note that this will use
/// more memory, and should be used only for debugging purposes
///
/// Example:
/// ```dart
/// final log = Logs();
/// log.v('Verbose log');
/// log.d('Debug log');
/// log.i('Info log');
/// log.w('Warning log');
/// log.e('Error log', includeTrace: true);
/// ```
///
/// Additional configuration:
/// - storeLogLevel: The minimum log level to store in the logs list
/// - printLogLevelWhenDebug: The minimum log level to print when running in debug mode
/// - printLogLevelWhenRelease: The minimum log level to print when running in release mode
/// - storeLimit: The maximum number of logs to store in memory
///
/// Example:
/// ```dart
/// final log = Logs(
///  storeLogLevel: LogLevel.verbose,
///  printLogLevelWhenDebug: LogLevel.verbose,
///  printLogLevelWhenRelease: LogLevel.error,
///  storeLimit: 500,
///  );
///  log.v('Verbose log');
///  ```
///  Use getStoredLogs to get the stored logs as a list
///
/// Example:
/// ```dart
/// final log = Logs();
/// log.v('Verbose log');
/// log.d('Debug log');
/// List<Map> logs = log.getStoredLogs();
/// ```
class Logs {
  final LogLevel
  _storeLogLevel,
  _printLogLevelWhenDebug,
  _printLogLevelWhenRelease;
  final List<_SingleLog> _logs = [];
  final int _storeLimit;

  Logs({
    /// The minimum log level to store in memory for later retrieval
    LogLevel storeLogLevel = LogLevel.verbose,
    /// The minimum log level to print when running in debug mode
    LogLevel printLogLevelWhenDebug = LogLevel.verbose,
    /// The minimum log level to print when running in release mode. Use LogLevel.none to disable printing
    LogLevel printLogLevelWhenRelease = LogLevel.error,
    /// The maximum number of logs to store in memory. When the limit is reached, the oldest logs are removed
    int storeLimit = 500,
  })  : _printLogLevelWhenRelease = printLogLevelWhenRelease,
        _printLogLevelWhenDebug = printLogLevelWhenDebug,
        _storeLogLevel = storeLogLevel,
        _storeLimit = storeLimit;


  /// Log a verbose message
  ///
  /// Use includeTrace to include the stack trace in the log. Note that this will use
  /// more memory, and should be used only for debugging purposes
  void v(dynamic message, {bool includeTrace = false}) {
    StackTrace trace = StackTrace.empty;
    if (includeTrace) {
      trace = StackTrace.current;
    }
    _createLog(LogLevel.verbose, message, trace);
  }


  /// Log a debug message
  ///
  /// Use includeTrace to include the stack trace in the log. Note that this will use
  /// more memory, and should be used only for debugging purposes
  void d(dynamic message, {bool includeTrace = false}) {
    StackTrace trace = StackTrace.empty;
    if (includeTrace) {
      trace = StackTrace.current;
    }
    _createLog(LogLevel.debug, message, trace);
  }

  /// Log an info message
  ///
  /// Use includeTrace to include the stack trace in the log. Note that this will use
  /// more memory, and should be used only for debugging purposes
  void i(dynamic message, {bool includeTrace = false}) {
    StackTrace trace = StackTrace.empty;
    if (includeTrace) {
      trace = StackTrace.current;
    }
    _createLog(LogLevel.info, message, trace);
  }


  /// Log a warning message
  ///
  /// Use includeTrace to include the stack trace in the log. Note that this will use
  /// more memory, and should be used only for debugging purposes
  void w(dynamic message, {bool includeTrace = false}) {
    StackTrace trace = StackTrace.empty;
    if (includeTrace) {
      trace = StackTrace.current;
    }
    _createLog(LogLevel.warning, message, trace);
  }


  /// Log an error message
  ///
  /// Use includeTrace to include the stack trace in the log. Note that this will use
  /// more memory, and should be used only for debugging purposes
  void e(dynamic message, {bool includeTrace = false}) {
    StackTrace trace = StackTrace.empty;
    if (includeTrace) {
      trace = StackTrace.current;
    }
    _createLog(LogLevel.error, message, trace);
  }


  /// Get the stored logs as a list of maps
  ///
  /// The list is ordered from oldest to newest
  ///
  /// Use limit to get a specific number of logs. The default is 100.
  /// If the limit is greater than the number of stored logs,
  /// the limit is set to the number of stored logs
  List<Map> getStoredLogs({int limit = 100}) {
    if (limit > _logs.length) {
      limit = _logs.length;
    }
    return _logs.sublist(_logs.length - limit).map((e) => e.toMap()).toList();
  }

  void _createLog(LogLevel level, dynamic message, StackTrace trace) {
    final log = _SingleLog(DateTime.now(), level, message, trace);

    if (_storeLogLevel.index <= level.index) {
      _logs.add(log);
      if (_logs.length > _storeLimit) {
        _logs.removeAt(0);
      }
    }

    //check if running in debug or release mode
    if (kDebugMode) {
      if (_printLogLevelWhenDebug.index <= level.index) {
        _beautifulPrint(log);
      }
    } else {
      if (_printLogLevelWhenRelease.index <= level.index) {
        _beautifulPrint(log);
      }
    }
  }

  void _beautifulPrint(_SingleLog log) {
    // print in colours
    switch (log.level) {
      case LogLevel.verbose:
        print('\x1B[2m${log.time.toIso8601String()} [VERBOSE] ${log.message} \x1B[0m');
        if (!log.traceEmpty) {
          print('\x1B[2m${log.trace} \x1B[0m');
        }
        break;
      case LogLevel.debug:
        print('\x1B[34m${log.time.toIso8601String()} [DEBUG] ${log.message} \x1B[0m');
        if (!log.traceEmpty) {
          print('\x1B[34m${log.trace} \x1B[0m');
        }
        break;
      case LogLevel.info:
        print('\x1B[32m${log.time.toIso8601String()} [INFO] ${log.message} \x1B[0m');
        if (!log.traceEmpty) {
          print('\x1B[32m${log.trace} \x1B[0m');
        }
        break;
      case LogLevel.warning:
        print('\x1B[33m${log.time.toIso8601String()} [WARNING] ${log.message} \x1B[0m');
        if (!log.traceEmpty) {
          print('\x1B[33m${log.trace} \x1B[0m');
        }
        break;
      case LogLevel.error:
        print('\x1B[31m${log.time.toIso8601String()} [ERROR] ${log.message} \x1B[0m');
        if (!log.traceEmpty) {
          print('\x1B[31m${log.trace} \x1B[0m');
        }
        break;
      case LogLevel.none:
        break;

    }
  }
}

class _SingleLog {
  final DateTime time;
  final LogLevel level;
  final dynamic message;
  final StackTrace trace;
  bool traceEmpty = true;

  _SingleLog(this.time, this.level, this.message, this.trace) {
    if (trace.toString().isNotEmpty) {
      traceEmpty = false;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time.toIso8601String(),
      'level': level.toString().split('.').last,
      'message': message,
    };
  }
}
