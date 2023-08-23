import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension BuildCxt<T> on BuildContext {
  void toast(T msg) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(msg.toString())));
  }

  T? get extra => GoRouterState.of(this).extra as T;
}
