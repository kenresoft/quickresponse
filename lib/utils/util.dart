import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/toast.dart';

class Util {
  Util._();

  static Widget loadFuture<T>(
    Future<T> future,
    void Function(Object data) data,
    Widget Function(T? data) child,
  ) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final result = snapshot.data;
          if (result != null) {
            data(result);
          } else {
            data('Null data returned.');
          }
          return child(result);
        } else if (snapshot.hasError) {
          data('Error: ${snapshot.error}');
          return const SizedBox();
        } else {
          return const SizedBox();
        }
      },
    );
  }

  static Widget loadStream<T>(
    Stream<T> stream,
    //void Function(Object data) data,
    Widget Function(T? data) child,
  ) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        T? result;
        if (snapshot.hasData) {
          result = snapshot.data;
          if (result != null) {
            //data(result);
            return child(result);
          } else {
            //data('Null data returned.');
            return const Toast('Null data returned.', show: true);
          }
        } else if (snapshot.hasError) {
          //data('Error: ${snapshot.error}');
          return Toast('Error: ${snapshot.error}', show: true);
        } else {
          return child(result);
        }
      },
    );
  }

  static lockOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static unlockOrientation() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

}
