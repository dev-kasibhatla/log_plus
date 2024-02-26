import 'package:logs/logs.dart';
import 'package:test/test.dart';

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

    test('Verbose logs with stacktrace', () {
      // This looks like an error but that just means it's working as expected. 🤧
      Logs logs = Logs();
      logs.v('Verbose message', includeTrace: true);
      expect(logs.getStoredLogs().last['message'], 'Verbose message');
      expect(logs.getStoredLogs().last['level'], 'verbose');
      expect(logs.getStoredLogs().last['trace'], isNotNull);
    });

    test('Debug logs with stacktrace', () {
      // This looks like an error but that just means it's working as expected
      Logs logs = Logs();
      logs.d('Debug message', includeTrace: true);
      expect(logs.getStoredLogs().last['message'], 'Debug message');
      expect(logs.getStoredLogs().last['level'], 'debug');
      expect(logs.getStoredLogs().last['trace'], isNotNull);
    });

    test('Info logs with stacktrace', () {
      // This looks like an error but that just means it's working as expected
      Logs logs = Logs();
      logs.i('Info message', includeTrace: true);
      expect(logs.getStoredLogs().last['message'], 'Info message');
      expect(logs.getStoredLogs().last['level'], 'info');
      expect(logs.getStoredLogs().last['trace'], isNotNull);
    });

    test('Warning logs with stacktrace', () {
      // This looks like an error but that just means it's working as expected
      Logs logs = Logs();
      logs.w('Warning message', includeTrace: true);
      expect(logs.getStoredLogs().last['message'], 'Warning message');
      expect(logs.getStoredLogs().last['level'], 'warning');
      expect(logs.getStoredLogs().last['trace'], isNotNull);
    });

    test('Error logs with stacktrace', () {
      // This looks like an error but that just means it's working as expected
      Logs logs = Logs();
      logs.e('Error message', includeTrace: true);
      expect(logs.getStoredLogs().last['message'], 'Error message');
      expect(logs.getStoredLogs().last['level'], 'error');
      expect(logs.getStoredLogs().last['trace'], isNotNull);
    });
  });

  group('Release mode', () {
    setUp(() => {
          // replace print function with a mock function
          // to read the logs printed to the console
          // TODO: implement this
        });
  });
}
