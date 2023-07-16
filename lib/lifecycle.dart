import 'package:flutter/cupertino.dart';

class MyAppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Do something when the app is resumed.
    }
  }
}
