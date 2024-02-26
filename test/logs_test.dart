import 'package:flutter_test/flutter_test.dart';
import 'package:logs/logs.dart';

void main() {
  group('Logs', () {
    Logs logs = Logs();

    test('should log a verbose message', () {
      logs.v('Verbose message');
      expect(logs.getStoredLogs().last['message'], 'Verbose message');
      expect(logs.getStoredLogs().last['level'], 'verbose');
    });

    test('should log a debug message', () {
      logs.d('Debug message');
      expect(logs.getStoredLogs().last['message'], 'Debug message');
      expect(logs.getStoredLogs().last['level'], 'debug');
    });

    test('should log an info message', () {
      logs.i('Info message');
      expect(logs.getStoredLogs().last['message'], 'Info message');
      expect(logs.getStoredLogs().last['level'], 'info');
    });

    test('should log a warning message', () {
      logs.w('Warning message');
      expect(logs.getStoredLogs().last['message'], 'Warning message');
      expect(logs.getStoredLogs().last['level'], 'warning');
    });

    test('should log an error message', () {
      logs.e('Error message');
      expect(logs.getStoredLogs().last['message'], 'Error message');
      expect(logs.getStoredLogs().last['level'], 'error');
    });

    test('should not store logs if log level is none', () {
      logs = Logs(storeLogLevel: LogLevel.none);
      logs.v('Verbose message');
      expect(logs.getStoredLogs(), isEmpty);
    });

    test('should limit the number of stored logs', () {
      logs = Logs(storeLimit: 2);
      logs.v('Verbose message 1');
      logs.v('Verbose message 2');
      logs.v('Verbose message 3');
      expect(logs.getStoredLogs().length, 2);
      expect(logs.getStoredLogs().first['message'], 'Verbose message 2');
      expect(logs.getStoredLogs().last['message'], 'Verbose message 3');
    });

    test('should return limited number of logs', () {
      logs.v('Verbose message 1');
      logs.v('Verbose message 2');
      logs.v('Verbose message 3');
      var limitedLogs = logs.getStoredLogs(limit: 2);
      expect(limitedLogs.length, 2);
      expect(limitedLogs.first['message'], 'Verbose message 2');
      expect(limitedLogs.last['message'], 'Verbose message 3');
    });
  });
}