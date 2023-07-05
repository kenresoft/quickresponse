import 'package:flutter/material.dart';

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
            return const Toast(
              show: true,
              text: 'Null data returned.',
            );
          }
        } else if (snapshot.hasError) {
          //data('Error: ${snapshot.error}');
          return Toast(
            show: true,
            text: 'Error: ${snapshot.error}',
          );
        } else {
          return child(result);
        }
      },
    );
  }
}
