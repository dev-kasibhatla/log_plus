import 'package:logs/logs.dart';

void main() {
  print(
      'Run with either `dart example/main.dart` or `dart --enable-asserts example/main.dart`.');
  quickStartDemo(); // quick start demo with no customisation
  customiseDemo(); // example of all customisation options
  hideLogsInRelease(); // example of hiding logs in release
}

void quickStartDemo() {
  Logs log = Logs();
  log.v('This is a verbose log');
  log.d('This is a debug log');
  log.i('This is an info log');
  log.w('This is a warning log');
  log.e('This is an error log', includeTrace: true);
}

void customiseDemo() {
  Logs log = Logs(
    storeLogLevel: LogLevel.warning, // only store warning and error logs
    printLogLevelWhenDebug: LogLevel.verbose, // print all logs in debug
    printLogLevelWhenRelease: LogLevel.error, // only print errors in release
    storeLimit: 500, // log history stored in memory
  );
  log.v('This is a verbose log');
  log.d('This is a debug log');
  log.i('This is an info log');
  log.w('This is a warning log');
  log.e('This is an error log', includeTrace: true);

  List<Map> logs = log.getStoredLogs(); // get stored logs as a list
  print(logs);
}

void hideLogsInRelease() {
  Logs log = Logs(
    printLogLevelWhenRelease: LogLevel.none, // disable printing logs in release
  );

  print('All logs will be shown in debug, but hidden in release mode.');

  log.v('This is a verbose log');
  log.d('This is a debug log');
  log.i('This is an info log');
  log.w('This is a warning log');
  log.e('This is an error log', includeTrace: true);
}