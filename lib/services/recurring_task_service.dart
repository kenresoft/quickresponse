import 'dart:async';
import 'dart:isolate';

class BackgroundService {
  static Isolate? _isolate;
  static late ReceivePort _receivePort;
  static late bool _isRunning;

  static Future<void> init() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_startIsolate, _receivePort.sendPort);
    _isRunning = false;
  }

  static startRepeatingTask(Duration interval, Function() task) async {
    if (_isRunning) return;

    _receivePort.listen((data) {
      if (data == 'start') {
        _isRunning = true;
        Timer.periodic(interval, (Timer timer) {
          if (!_isRunning) {
            timer.cancel();
          } else {
            task();
          }
        });
      }
    });

    _receivePort.sendPort.send('start');
  }

  static void _startIsolate(SendPort sendPort) {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      if (message == 'start') {
        Timer.periodic(const Duration(seconds: 1), (Timer timer) {
          sendPort.send('recurringTask');
        });
      }
    });
  }

  static stopRepeatingTask() {
    if (_isolate != null) {
      _isRunning = false;
      _receivePort.sendPort.send('stop');
      _receivePort.close();
      _isolate?.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }
}
