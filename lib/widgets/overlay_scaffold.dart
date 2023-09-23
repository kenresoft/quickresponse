import 'package:flutter/material.dart';

import '../utils/wrapper.dart';
import 'custom_fab.dart';

class ScaffoldX extends StatefulWidget {
  ScaffoldX({
    super.key,
    this.backgroundColor,
    this.appBar,
    this.body,
    this.bottomNavigationBar,
    this.focusNode,
    GlobalKey<ScaffoldMessengerState>? sKey,
    this.onPressed1,
    this.onPressed2,
  }) : sKey = sKey ?? GlobalKey<ScaffoldMessengerState>();

  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final FocusNode? focusNode;
  final GlobalKey<ScaffoldMessengerState> sKey;
  final Function()? onPressed1;
  final Function()? onPressed2;

  void toast(String message) {
    sKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  State<ScaffoldX> createState() => _ScaffoldXState();
}

class _ScaffoldXState extends State<ScaffoldX> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldMessengerState> sKey = widget.sKey ?? GlobalKey<ScaffoldMessengerState>();

    return Stack(
      children: [
        ScaffoldMessenger(
          key: sKey,
          child: focus(
            widget.focusNode ?? FocusNode(),
            Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: widget.backgroundColor,
              appBar: widget.appBar,
              body: widget.body,
              bottomNavigationBar: widget.bottomNavigationBar,
            ),
          ),
        ),
        CustomFAB(
          onPressed1: () => widget.onPressed1!(),
          onPressed2: () => widget.onPressed2!(),
        ),
      ],
    );
  }
}
