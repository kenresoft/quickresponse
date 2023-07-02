import 'package:flutter/material.dart';

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
    void Function(Object data) data,
  ) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final result = snapshot.data;
          if (result != null) {
            data(result);
          } else {
            data('Null data returned.');
          }
          return const SizedBox();
        } else if (snapshot.hasError) {
          data('Error: ${snapshot.error}');
          return const SizedBox();
        } else {
          return const SizedBox();
        }
      },
    );
  }

}
