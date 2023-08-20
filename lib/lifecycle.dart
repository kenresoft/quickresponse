import 'package:flutter/cupertino.dart';

class MyAppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Do something when the app is resumed.
    }
  }
}


/*
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    log('disposed');
    super.dispose();
  }
*/

/*  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && _restarted) {
      //_restarted = true;
      debugPrint('App resumed');
      // Restart the app.
      //WidgetsBinding.instance.reassembleApplication();

    }
  }*/
